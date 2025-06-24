import 'package:flutter/material.dart';
import 'package:nemuskill/services/api_service.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late ApiService _apiService;
  List<dynamic> _reviews = [];
  bool _isLoading = true;
  String _errorMessage = '';
  final TextEditingController _reviewContentController =
      TextEditingController();
  int? _editingReviewId;
  int _selectedRating = 4; // Default rating

  @override
  void initState() {
    super.initState();
    _initApiServiceAndFetchReviews();
  }

  Future<void> _initApiServiceAndFetchReviews() async {
    _apiService = await ApiService.getInstance();
    if (mounted) {
      _fetchReviews();
    }
  }

  void _fetchReviews() async {
    if (!mounted || _apiService == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication token not found. Please log in.';
        });
        return;
      }
      final response = await _apiService.get('student/reviews');
      print('API Response for reviews (GET): $response'); // Debug print
      setState(() {
        _reviews =
            response['data'] ??
            []; // Pastikan ini adalah list kosong jika data null
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load reviews: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addReview() async {
    if (!mounted || _apiService == null) return;
    if (_reviewContentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ulasan tidak boleh kosong.')),
      );
      return;
    }
    print(
      'Attempting to add review with content: ${_reviewContentController.text}, rating: $_selectedRating',
    ); // Debug print
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication token not found. Please log in.';
        });
        return;
      }
      final dataToSend = {
        'review': _reviewContentController.text, // Corrected key to 'review'
        'rating': _selectedRating, // Add rating to the payload
      };
      print('Sending POST data: $dataToSend'); // Debug print
      final response = await _apiService.post('student/reviews', dataToSend);
      print('Review added: $response');
      _reviewContentController.clear();
      _selectedRating = 4; // Reset rating
      _fetchReviews();
    } catch (e) {
      print('Failed to add review: $e');
      setState(() {
        _errorMessage = 'Failed to add review: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menambah ulasan: ${e.toString()}')),
      );
    }
  }

  void _editReview() async {
    if (!mounted || _apiService == null) return;
    if (_reviewContentController.text.isEmpty || _editingReviewId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan atau ID edit tidak boleh kosong.'),
        ),
      );
      return;
    }
    print(
      'Attempting to edit review ID: $_editingReviewId with content: ${_reviewContentController.text}, rating: $_selectedRating',
    ); // Debug print
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication token not found. Please log in.';
        });
        return;
      }
      final dataToSend = {
        'review': _reviewContentController.text, // Corrected key to 'review'
        'rating': _selectedRating, // Add rating to the payload
      };
      print('Sending PUT data: $dataToSend'); // Debug print
      final response = await _apiService.put(
        'student/reviews/$_editingReviewId',
        dataToSend,
      );
      print('Review updated: $response');
      _reviewContentController.clear();
      _editingReviewId = null;
      _selectedRating = 4; // Reset rating
      _fetchReviews();
    } catch (e) {
      print('Failed to update review: $e');
      setState(() {
        _errorMessage = 'Failed to update review: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengedit ulasan: ${e.toString()}')),
      );
    }
  }

  void _deleteReview(int id) async {
    if (!mounted || _apiService == null) return;
    print('Attempting to delete review ID: $id'); // Debug print
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        setState(() {
          _errorMessage = 'Authentication token not found. Please log in.';
        });
        return;
      }
      await _apiService.delete('student/reviews/$id');
      print('Review deleted: $id');
      _fetchReviews();
    } catch (e) {
      print('Failed to delete review: $e');
      setState(() {
        _errorMessage = 'Failed to delete review: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus ulasan: ${e.toString()}')),
      );
    }
  }

  void _startEdit(dynamic review) {
    _reviewContentController.text =
        review['review'] ?? ''; // Corrected key to 'review'
    _editingReviewId = review['id'] as int?; // Ensure id is an int
    _selectedRating =
        review['rating'] as int? ?? 4; // Load existing rating, default to 4
    _showAddEditReviewDialog(reviewToEdit: review);
  }

  void _showAddEditReviewDialog({Map<String, dynamic>? reviewToEdit}) {
    if (reviewToEdit != null) {
      _reviewContentController.text =
          reviewToEdit['review'] ?? ''; // Corrected key to 'review'
      _editingReviewId = reviewToEdit['id'] as int?;
      _selectedRating =
          reviewToEdit['rating'] as int? ?? 4; // Set initial rating for edit
    } else {
      _reviewContentController.clear();
      _editingReviewId = null;
      _selectedRating = 4; // Reset to default for new review
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            reviewToEdit == null ? 'Tambah Ulasan Baru' : 'Edit Ulasan',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star Rating Selection
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateDialog) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          icon: Icon(
                            index < _selectedRating
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            setStateDialog(() {
                              _selectedRating = index + 1;
                            });
                          },
                        );
                      }),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _reviewContentController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Ulasan',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
                _reviewContentController.clear();
                _editingReviewId = null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (reviewToEdit == null) {
                  _addReview();
                } else {
                  _editReview();
                }
                Navigator.of(context).pop();
              },
              child: Text(reviewToEdit == null ? 'Tambah' : 'Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate average rating
    double averageRating = 0;
    if (_reviews.isNotEmpty) {
      int totalRating = 0;
      for (var review in _reviews) {
        totalRating += review['rating'] as int? ?? 0;
      }
      averageRating = totalRating / _reviews.length;
    }

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Ulasan',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < averageRating.floor()
                                  ? Icons.star
                                  : (index < averageRating.ceil() &&
                                      averageRating % 1 != 0)
                                  ? Icons.star_half
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${averageRating.toStringAsFixed(1)} (${_reviews.length} ulasan)',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed:
                      _apiService == null
                          ? null
                          : () => _showAddEditReviewDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Ulasan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage.isNotEmpty)
            Expanded(child: Center(child: Text(_errorMessage)))
          else if (_reviews.isEmpty)
            const Expanded(child: Center(child: Text('No reviews available.')))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: _reviews.length,
                itemBuilder: (context, index) {
                  final review = _reviews[index];
                  // Default values for rating, user, and date if not available in API response
                  final int rating = 4; // Placeholder
                  final String userName =
                      review['user']?['name'] ??
                      'Pengguna Tidak Dikenal'; // Access user name from API
                  final DateTime? createdAt = DateTime.tryParse(
                    review['created_at'] ?? '',
                  );
                  final String formattedDate =
                      createdAt != null
                          ? DateFormat('dd MMM yyyy HH:mm').format(createdAt)
                          : 'Tanggal Tidak Tersedia';

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Bintang Rating (Menggunakan rating dari API jika ada, default ke 4)
                              Row(
                                children: List.generate(5, (starIndex) {
                                  final currentRating =
                                      review['rating'] as int? ??
                                      4; // Use actual rating if available
                                  return Icon(
                                    starIndex < currentRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                userName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Konten Ulasan
                          Text(
                            review['review'] ??
                                'No Content', // Corrected key to 'review'
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          // Tanggal
                          Text(
                            formattedDate,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          // Tombol Edit dan Hapus
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () => _startEdit(review),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.amber, // Warna kuning untuk Edit
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => _deleteReview(review['id']),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red, // Warna merah untuk Hapus
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
