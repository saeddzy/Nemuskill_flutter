import 'package:flutter/material.dart';
import 'package:nemuskill/services/api_service.dart'; // Import ApiService
// Hapus atau komentari import dummy data jika ada
// import '../../models/kelas.dart';
// import '../../dummy_data.dart';
// import 'detail_kelas_page.dart'; // Baris ini harus dihapus

class KelasPage extends StatefulWidget {
  const KelasPage({super.key});

  @override
  State<KelasPage> createState() => _KelasPageState();
}

class _KelasPageState extends State<KelasPage> {
  late ApiService _apiService;
  List<dynamic> _classes = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initApiServiceAndFetchClasses();
  }

  Future<void> _initApiServiceAndFetchClasses() async {
    _apiService = await ApiService.getInstance();
    if (mounted) {
      _fetchClasses();
    }
  }

  void _fetchClasses() async {
    if (!mounted) return; // _apiService will be initialized by _initApiServiceAndFetchClasses()

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
      final response = await _apiService.get('student/classes');
      print('API Response for classes: $response'); // Debug print
      setState(() {
        _classes = response['data'];
        print('Classes after assignment: $_classes'); // Debug print
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load classes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelas Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implementasi fitur filter
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _classes.isEmpty
                  ? const Center(child: Text('No classes available.'))
                  : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
                        // Bagian Progress Belajar (akan menggunakan data kelas asli)
                        // Ini hanya placeholder, perlu logika untuk menghitung progress dari data API
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress Belajar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                          '--%',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'Kelas Selesai',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                          ),
                        ],
                      ),
                    ),
                    CircularProgressIndicator(
                                    value: 0.0, // Placeholder
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

                        // Bagian Kelas Aktif (menggunakan data API)
          Text(
            'Kelas Aktif',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
                          itemCount: _classes.where((k) => k['status'] == 'approved').length, // Changed to 'approved'
            itemBuilder: (context, index) {
                            final kelas = _classes.where((k) => k['status'] == 'approved').toList()[index]; // Changed to 'approved'
              return _buildKelasCard(context, kelas);
            },
          ),
          const SizedBox(height: 24),

                        // Bagian Kelas Yang Sudah Selesai (menggunakan data API)
          Text(
            'Kelas Selesai',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
                          itemCount: _classes.where((k) => k['status'] == 'completed').length, // Assuming 'completed' for Selesai
            itemBuilder: (context, index) {
                            final kelas = _classes.where((k) => k['status'] == 'completed').toList()[index]; // Assuming 'completed' for Selesai
              return _buildKelasCard(context, kelas);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKelasCard(BuildContext context, Map<String, dynamic> kelas) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          if (kelas['id'] != null) {
            // Simplified print for robustness
            print('Navigating to DetailKelasPage with classId: ${kelas["id"]}');
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailKelasPage(classId: kelas['id'] as int), // Pass classId
            ),
          );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Class ID not found.')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.class_,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kelas['title'] ?? 'No Title', // Access title from API data
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '0 Materi', // Placeholder as materials_count not in list API
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: kelas['status'] == 'approved' // Changed to 'approved'
                          ? Colors.green[100]
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kelas['status'] == 'approved' ? 'Aktif' : kelas['status'] ?? 'N/A', // Display 'Aktif' for 'approved'
                      style: TextStyle(
                        color: kelas['status'] == 'approved' // Changed to 'approved'
                            ? Colors.green[800]
                            : Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (kelas['status'] == 'approved') ...[ // Changed to 'approved'
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 0.0, // Placeholder as progress not in list API
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '0% Selesai', // Placeholder as progress not in list API
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DetailKelasPage extends StatefulWidget { // Ubah menjadi StatefulWidget
  final int classId;

  const DetailKelasPage({super.key, required this.classId});

  @override
  State<DetailKelasPage> createState() => _DetailKelasPageState();
}

class _DetailKelasPageState extends State<DetailKelasPage> {
  late ApiService _apiService;
  Map<String, dynamic>? _classDetail;
  List<dynamic> _materials = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initApiServiceAndFetchData();
  }

  Future<void> _initApiServiceAndFetchData() async {
    _apiService = await ApiService.getInstance();
    if (mounted) {
      // await _fetchClassDetail(); // Hapus atau komentari baris ini
      await _fetchMaterials();
    }
    setState(() {
      _isLoading = false;
    });
  }

  // Anda bisa menghapus atau mengomentari seluruh fungsi _fetchClassDetail() jika tidak lagi diperlukan
  /*
  Future<void> _fetchClassDetail() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Authentication token not found. Please log in.';
          });
        }
        return;
      }
      final classDetailUrl = 'student/classes/${widget.classId}'; // Store URL for printing
      print('Fetching class detail endpoint: $classDetailUrl'); // Debug print fixed
      final response = await _apiService.get(classDetailUrl);
      if (mounted) {
        setState(() {
          _classDetail = response['data'];
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load class detail: $e';
        });
      }
    }
  }
  */

  Future<void> _fetchMaterials() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Authentication token not found. Please log in.';
          });
        }
        return;
      }
      final materialsUrl = 'student/classes/${widget.classId}/materials'; // Store URL for printing
      print('Fetching materials endpoint: $materialsUrl'); // Debug print fixed
      final response = await _apiService.get(materialsUrl); // Make sure 'response' is defined here
      print('API Response for materials: $response'); // Debug print fixed
      print('Type of response data for materials: ${response['data'].runtimeType}'); // Debug print fixed
      if (mounted) {
        setState(() {
          // Mengambil detail kelas dari respons materi
          _classDetail = response['data']['class']; // Mengakses nested class detail
          // Asumsi daftar materi ada di dalam key 'materials' di objek data
          _materials = response['data']['materials'] ?? []; // Mengakses nested materials list
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load materials: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_classDetail?['name'] ?? 'Detail Kelas'), // Tampilkan nama kelas jika sudah dimuat
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _classDetail == null
                  ? const Center(child: Text('Class detail not found.'))
                  : ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card Informasi Kelas
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informasi Kelas',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(
                    context,
                    'Status',
                                  _classDetail!['status'] ?? 'N/A',
                                  _classDetail!['status'] == 'Aktif' ? Colors.green : Colors.grey,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    context,
                    'Total Materi',
                                  '${_classDetail!['materials_count'] ?? 0} Materi',
                    Theme.of(context).colorScheme.primary,
                  ),
                  const Divider(),
                  _buildInfoRow(
                    context,
                    'Progress',
                                  '${_classDetail!['progress']?.toInt() ?? 0}% Selesai',
                    Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
                        const SizedBox(height: 16),
          Text(
            'Daftar Materi',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
                        _materials.isEmpty
                            ? const Center(child: Text('No materials found for this class.'))
                            : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
                                itemCount: _materials.length,
            itemBuilder: (context, index) {
                                  final materi = _materials[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                    child: Icon(
                                          Icons.book,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  title: Text(
                                        materi['title'] ?? 'No Title',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                                      subtitle: Text(materi['description'] ?? 'No Description'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                                          child: Text(materi['content'] ?? 'No Content'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
              value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}