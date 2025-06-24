import 'package:flutter/material.dart';
import 'package:nemuskill/services/api_service.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<ClassesPage> createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
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
    // Check if the widget is still mounted before calling setState
    if (mounted) {
      _fetchClasses();
    }
  }

  void _fetchClasses() async {
    // Ensure ApiService is initialized before making API calls
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
      final response = await _apiService.get('student/classes');
      setState(() {
        _classes = response['data']; // Assuming 'data' key holds the list of classes
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
        title: const Text('Classes'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _classes.isEmpty
                  ? const Center(child: Text('No classes available.'))
                  : ListView.builder(
                      itemCount: _classes.length,
                      itemBuilder: (context, index) {
                        final classItem = _classes[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              // Navigate to MaterialsPage with classId
                              if (classItem['id'] != null) {
                                Navigator.pushNamed(
                                  context,
                                  '/materials',
                                  arguments: classItem['id'],
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Class ID not found.')),
                                );
                              }
                            },
                            title: Text(classItem['name'] ?? 'No Name'),
                            subtitle: Text(classItem['description'] ?? 'No Description'),
                            // You can add more details here
                          ),
                        );
                      },
                    ),
    );
  }
} 