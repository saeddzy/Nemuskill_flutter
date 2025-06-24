import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/pembayaran_provider.dart';

class PembayaranPage extends StatelessWidget {
  const PembayaranPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddPaymentDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<PembayaranProvider>(
        builder: (context, pembayaranProvider, child) {
          final pembayaranList = pembayaranProvider.pembayaranList;
          
          if (pembayaranList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.payment,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pembayaran',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: pembayaranList.length,
            itemBuilder: (context, index) {
              final pembayaran = pembayaranList[index];
              return _buildPaymentCard(context, pembayaran);
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, Pembayaran pembayaran) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _showPaymentDetailDialog(context, pembayaran);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pembayaran.kelas,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(pembayaran.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          pembayaran.status,
                          style: TextStyle(
                            color: _getStatusColor(pembayaran.status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditPaymentDialog(context, pembayaran);
                          } else if (value == 'delete') {
                            _showDeleteConfirmationDialog(context, pembayaran);
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
                        DateFormat('dd MMM yyyy').format(pembayaran.tanggal),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        currencyFormat.format(pembayaran.total),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'gagal':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddPaymentDialog(BuildContext context) {
    final kelasController = TextEditingController();
    final totalController = TextEditingController();
    String selectedStatus = 'Pending';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kelasController,
                decoration: const InputDecoration(labelText: 'Kelas'),
              ),
              TextField(
                controller: totalController,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Lunas', 'Pending', 'Gagal']
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (kelasController.text.isNotEmpty &&
                  totalController.text.isNotEmpty) {
                context.read<PembayaranProvider>().addPembayaran(
                      kelas: kelasController.text,
                      total: double.parse(totalController.text),
                      status: selectedStatus,
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDetailDialog(BuildContext context, Pembayaran pembayaran) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Detail Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Kelas', pembayaran.kelas),
            _buildDetailRow('Tanggal',
                DateFormat('dd MMMM yyyy').format(pembayaran.tanggal)),
            _buildDetailRow('Total', currencyFormat.format(pembayaran.total)),
            _buildDetailRow('Status', pembayaran.status),
            _buildDetailRow('Metode', pembayaran.metode),
            _buildDetailRow('No. Referensi', pembayaran.referensi),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.read<PembayaranProvider>().deletePembayaran(pembayaran.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

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

  void _showEditPaymentDialog(BuildContext context, Pembayaran pembayaran) {
    final kelasController = TextEditingController(text: pembayaran.kelas);
    final totalController = TextEditingController(text: pembayaran.total.toString());
    String selectedStatus = pembayaran.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pembayaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: kelasController,
                decoration: const InputDecoration(labelText: 'Kelas'),
              ),
              TextField(
                controller: totalController,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Lunas', 'Pending', 'Gagal']
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              if (kelasController.text.isNotEmpty &&
                  totalController.text.isNotEmpty) {
                context.read<PembayaranProvider>().updatePembayaran(
                      id: pembayaran.id,
                      kelas: kelasController.text,
                      total: double.parse(totalController.text),
                      status: selectedStatus,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pembayaran berhasil diperbarui'),
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

  void _showDeleteConfirmationDialog(BuildContext context, Pembayaran pembayaran) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pembayaran'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus pembayaran ini? Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<PembayaranProvider>().deletePembayaran(pembayaran.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pembayaran berhasil dihapus'),
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