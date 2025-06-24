import 'package:flutter/material.dart';
import 'package:nemuskill/services/api_service.dart';

class MaterialsPage extends StatefulWidget {
  final int classId;

  const MaterialsPage({super.key, required this.classId});

  @override
  State<MaterialsPage> createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  late ApiService _apiService;
  List<dynamic> _materials = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initApiServiceAndFetchMaterials();
  }

  Future<void> _initApiServiceAndFetchMaterials() async {
    _apiService = await ApiService.getInstance();
    if (mounted) {
      _fetchMaterials(widget.classId);
    }
  }

  void _fetchMaterials(int classId) async {
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
      final response = await _apiService.get('student/classes/$classId/materials');
      setState(() {
        _materials = response['data'];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load materials: $e';
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
        title: const Text('Materials'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _materials.isEmpty
                  ? const Center(child: Text('No materials available for this class.'))
                  : ListView.builder(
                      itemCount: _materials.length,
                      itemBuilder: (context, index) {
                        final materialItem = _materials[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(materialItem['title'] ?? 'No Title'),
                            subtitle: Text(materialItem['type'] ?? 'No Type'),
                          ),
                        );
                      },
                    ),
    );
  }
} 