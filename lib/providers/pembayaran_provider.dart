import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

// Provider untuk mengelola state pembayaran
class PembayaranProvider with ChangeNotifier {
  // List private untuk menyimpan data pembayaran
  final List<Pembayaran> _pembayaranList = [];
  // Instance UUID untuk generate ID unik
  final _uuid = const Uuid();

  // Getter untuk mengakses list pembayaran
  List<Pembayaran> get pembayaranList => _pembayaranList;

  // Method untuk menambahkan pembayaran baru
  void addPembayaran({
    required String kelas,    // Nama kelas yang dibayar
    required double total,    // Total pembayaran
    required String status,   // Status pembayaran (Lunas, Pending, Gagal)
  }) {
    // Buat objek pembayaran baru
    final pembayaran = Pembayaran(
      id: _uuid.v4(),                                              // Generate ID unik menggunakan UUID
      kelas: kelas,
      tanggal: DateTime.now(),                                     // Set tanggal pembayaran ke waktu sekarang
      total: total,
      status: status,
      metode: 'Transfer Bank',                                     // Metode pembayaran default
      referensi: 'REF-${DateTime.now().millisecondsSinceEpoch}',  // Generate nomor referensi unik
    );

    // Tambahkan pembayaran ke list
    _pembayaranList.add(pembayaran);
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }

  // Method untuk menghapus pembayaran berdasarkan ID
  void deletePembayaran(String id) {
    // Hapus pembayaran dari list berdasarkan ID
    _pembayaranList.removeWhere((pembayaran) => pembayaran.id == id);
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }

  // Method untuk mengupdate pembayaran yang sudah ada
  void updatePembayaran({
    required String id,       // ID pembayaran yang akan diupdate
    String? kelas,           // Nama kelas (opsional)
    double? total,           // Total pembayaran (opsional)
    String? status,          // Status pembayaran (opsional)
    String? metode,          // Metode pembayaran (opsional)
  }) {
    // Cari index pembayaran berdasarkan ID
    final index = _pembayaranList.indexWhere((p) => p.id == id);
    
    // Jika pembayaran ditemukan, update datanya
    if (index != -1) {
      final pembayaran = _pembayaranList[index];
      // Buat pembayaran baru dengan data yang diupdate
      _pembayaranList[index] = Pembayaran(
        id: pembayaran.id,
        kelas: kelas ?? pembayaran.kelas,           // Gunakan nilai baru atau nilai lama
        tanggal: pembayaran.tanggal,                // Tanggal tidak berubah
        total: total ?? pembayaran.total,           // Gunakan nilai baru atau nilai lama
        status: status ?? pembayaran.status,        // Gunakan nilai baru atau nilai lama
        metode: metode ?? pembayaran.metode,        // Gunakan nilai baru atau nilai lama
        referensi: pembayaran.referensi,            // Referensi tidak berubah
      );
      // Beritahu listeners bahwa data telah berubah
      notifyListeners();
    }
  }
}

// Model data untuk menyimpan informasi pembayaran
class Pembayaran {
  final String id;          // ID unik pembayaran
  final String kelas;       // Nama kelas yang dibayar
  final DateTime tanggal;   // Tanggal pembayaran
  final double total;       // Total jumlah pembayaran
  final String status;      // Status pembayaran (Lunas, Pending, Gagal)
  final String metode;      // Metode pembayaran (Transfer Bank, E-Wallet, dll)
  final String referensi;   // Nomor referensi pembayaran

  Pembayaran({
    required this.id,
    required this.kelas,
    required this.tanggal,
    required this.total,
    required this.status,
    required this.metode,
    required this.referensi,
  });
} 