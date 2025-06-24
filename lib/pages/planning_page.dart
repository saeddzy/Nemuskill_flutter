import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/planning_provider.dart';
import '../providers/profile_provider.dart';
// Import data kelas dari kelas_page
import 'kelas_page.dart';

// Halaman untuk mengelola planning/perencanaan
class PlanningPage extends StatelessWidget {
  const PlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planning'),
        actions: [
          // Tombol untuk menambah planning baru
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPlanningDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<PlanningProvider>(
        builder: (context, planningProvider, child) {
          final planningList = planningProvider.planningList;
          
          // Tampilkan empty state jika belum ada planning
          if (planningList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada planning',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          // Tampilkan daftar planning menggunakan ListView
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: planningList.length,
            itemBuilder: (context, index) {
              final planning = planningList[index];
              return _buildPlanningCard(context, planning);
            },
          );
        },
      ),
    );
  }

  // Widget untuk membuat card planning individual
  Widget _buildPlanningCard(BuildContext context, Planning planning) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        // Tap untuk melihat detail planning
        onTap: () {
          _showPlanningDetailDialog(context, planning);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card dengan judul, status, dan menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    planning.judul,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      // Badge status planning
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(planning.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          planning.status,
                          style: TextStyle(
                            color: _getStatusColor(planning.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Menu popup untuk edit dan hapus
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditPlanningDialog(context, planning);
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(context, planning);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 20),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 20, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Hapus', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Informasi tanggal dan prioritas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(planning.tanggal),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Prioritas',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        planning.prioritas,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk mendapatkan warna berdasarkan status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'dalam proses':
        return Colors.orange;
      case 'belum dimulai':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  // Dialog untuk menambah planning baru
  void _showAddPlanningDialog(BuildContext context) {
    // Controller untuk input field
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();
    String selectedStatus = 'Belum Dimulai';
    String selectedPrioritas = 'Rendah';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Planning'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input judul planning
              TextField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              // Input deskripsi planning
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Dropdown untuk pilihan status
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Belum Dimulai', 'Dalam Proses', 'Selesai']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              // Dropdown untuk pilihan prioritas
              DropdownButtonFormField<String>(
                value: selectedPrioritas,
                decoration: const InputDecoration(labelText: 'Prioritas'),
                items: ['Rendah', 'Sedang', 'Tinggi']
                    .map((prioritas) => DropdownMenuItem(
                          value: prioritas,
                          child: Text(prioritas),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedPrioritas = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              // Date picker untuk memilih tanggal
              ListTile(
                title: const Text('Tanggal'),
                subtitle: Text(
                  DateFormat('dd MMMM yyyy').format(selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          // Tombol batal
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          // Tombol simpan planning
          TextButton(
            onPressed: () {
              if (judulController.text.isNotEmpty) {
                context.read<PlanningProvider>().addPlanning(
                      judul: judulController.text,
                      deskripsi: deskripsiController.text,
                      status: selectedStatus,
                      prioritas: selectedPrioritas,
                      tanggal: selectedDate,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Planning berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog untuk menampilkan detail planning
  void _showPlanningDetailDialog(BuildContext context, Planning planning) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Planning'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Judul', planning.judul),
            _buildDetailRow('Deskripsi', planning.deskripsi),
            _buildDetailRow('Tanggal',
                DateFormat('dd MMMM yyyy').format(planning.tanggal)),
            _buildDetailRow('Status', planning.status),
            _buildDetailRow('Prioritas', planning.prioritas),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk baris detail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Dialog untuk mengedit planning
  void _showEditPlanningDialog(BuildContext context, Planning planning) {
    // Pre-fill form dengan data planning yang ada
    final judulController = TextEditingController(text: planning.judul);
    final deskripsiController = TextEditingController(text: planning.deskripsi);
    String selectedStatus = planning.status;
    String selectedPrioritas = planning.prioritas;
    DateTime selectedDate = planning.tanggal;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Planning'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Belum Dimulai', 'Dalam Proses', 'Selesai']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedStatus = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedPrioritas,
                decoration: const InputDecoration(labelText: 'Prioritas'),
                items: ['Rendah', 'Sedang', 'Tinggi']
                    .map((prioritas) => DropdownMenuItem(
                          value: prioritas,
                          child: Text(prioritas),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedPrioritas = value;
                  }
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Tanggal'),
                subtitle: Text(
                  DateFormat('dd MMMM yyyy').format(selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          // Tombol simpan perubahan
          TextButton(
            onPressed: () {
              if (judulController.text.isNotEmpty) {
                context.read<PlanningProvider>().updatePlanning(
                      id: planning.id,
                      judul: judulController.text,
                      deskripsi: deskripsiController.text,
                      status: selectedStatus,
                      prioritas: selectedPrioritas,
                      tanggal: selectedDate,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Planning berhasil diperbarui'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // Dialog konfirmasi untuk menghapus planning
  void _showDeleteConfirmationDialog(BuildContext context, Planning planning) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Planning'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus planning ini? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          // Tombol konfirmasi hapus
          TextButton(
            onPressed: () {
              context.read<PlanningProvider>().deletePlanning(planning.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Planning berhasil dihapus'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
} 