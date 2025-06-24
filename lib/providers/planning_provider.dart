import 'package:flutter/foundation.dart';

// Model data untuk menyimpan informasi planning/perencanaan
class Planning {
  final String id;           // ID unik planning
  final String judul;        // Judul planning
  final String deskripsi;    // Deskripsi detail planning
  final String status;       // Status planning (Belum Dimulai, Dalam Proses, Selesai)
  final String prioritas;    // Tingkat prioritas (Rendah, Sedang, Tinggi)
  final DateTime tanggal;    // Tanggal planning

  Planning({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.status,
    required this.prioritas,
    required this.tanggal,
  });

  // Method untuk membuat salinan planning dengan beberapa field yang diubah
  Planning copyWith({
    String? id,
    String? judul,
    String? deskripsi,
    String? status,
    String? prioritas,
    DateTime? tanggal,
  }) {
    return Planning(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      status: status ?? this.status,
      prioritas: prioritas ?? this.prioritas,
      tanggal: tanggal ?? this.tanggal,
    );
  }
}

// Provider untuk mengelola state planning/perencanaan
class PlanningProvider with ChangeNotifier {
  // List planning dengan data contoh awal
  final List<Planning> _planningList = [
    Planning(
      id: '1',
      judul: 'Menyelesaikan Tugas Flutter',
      deskripsi: 'Menyelesaikan tugas akhir mata kuliah Flutter',
      status: 'Dalam Proses',
      prioritas: 'Tinggi',
      tanggal: DateTime.now(),
    ),
    Planning(
      id: '2',
      judul: 'Belajar State Management',
      deskripsi: 'Mempelajari Provider dan Bloc',
      status: 'Belum Dimulai',
      prioritas: 'Sedang',
      tanggal: DateTime.now().add(const Duration(days: 2)),
    ),
  ];

  // Getter untuk mengakses list planning (immutable copy)
  List<Planning> get planningList => [..._planningList];

  // Method untuk menambahkan planning baru
  void addPlanning({
    required String judul,
    required String deskripsi,
    required String status,
    required String prioritas,
    required DateTime tanggal,
  }) {
    // Buat planning baru dengan ID berdasarkan timestamp
    final newPlanning = Planning(
      id: DateTime.now().toString(),
      judul: judul,
      deskripsi: deskripsi,
      status: status,
      prioritas: prioritas,
      tanggal: tanggal,
    );
    // Tambahkan ke list planning
    _planningList.add(newPlanning);
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }

  // Method untuk mengupdate planning yang sudah ada
  void updatePlanning({
    required String id,
    required String judul,
    required String deskripsi,
    required String status,
    required String prioritas,
    required DateTime tanggal,
  }) {
    // Cari index planning berdasarkan ID
    final planningIndex = _planningList.indexWhere((planning) => planning.id == id);
    
    // Jika planning ditemukan, update datanya
    if (planningIndex >= 0) {
      _planningList[planningIndex] = Planning(
        id: id,
        judul: judul,
        deskripsi: deskripsi,
        status: status,
        prioritas: prioritas,
        tanggal: tanggal,
      );
      // Beritahu listeners bahwa data telah berubah
      notifyListeners();
    }
  }

  // Method untuk menghapus planning berdasarkan ID
  void deletePlanning(String id) {
    // Hapus planning dari list berdasarkan ID
    _planningList.removeWhere((planning) => planning.id == id);
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }
} 