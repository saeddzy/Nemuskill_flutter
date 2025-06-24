import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';

// Model data untuk menyimpan informasi profil pengguna
class Profile {
  final String nama;
  final String email;
  final String telepon;
  final String alamat;
  final String pendidikan;
  final String pekerjaan;
  final String minat;
  final String fotoProfil;

  Profile({
    required this.nama,
    required this.email,
    required this.telepon,
    required this.alamat,
    required this.pendidikan,
    required this.pekerjaan,
    required this.minat,
    required this.fotoProfil,
  });

  // Method untuk membuat salinan profil dengan beberapa field yang diubah
  Profile copyWith({
    String? nama,
    String? email,
    String? telepon,
    String? alamat,
    String? pendidikan,
    String? pekerjaan,
    String? minat,
    String? fotoProfil,
  }) {
    return Profile(
      nama: nama ?? this.nama,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      pendidikan: pendidikan ?? this.pendidikan,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      minat: minat ?? this.minat,
      fotoProfil: fotoProfil ?? this.fotoProfil,
    );
  }
}

// Provider untuk mengelola state profil pengguna
class ProfileProvider with ChangeNotifier {
  // Data profil default dengan informasi awal
  Profile _profile = Profile(
    nama: 'Said Al',
    email: 'said@gmail.com',
    telepon: '+62 812-3456-7890',
    alamat: 'Jl. Contoh No. 123, Jambi',
    pendidikan: 'D3 Sistem Informasi',
    pekerjaan: 'Mahasiswa',
    minat: 'UI/UX Design',
    fotoProfil: '',
  );

  // Getter untuk mengakses data profil
  Profile get profile => _profile;

  // Method untuk mengupdate informasi profil
  Future<void> updateProfile({
    String? nama,
    String? email,
    String? telepon,
    String? alamat,
    String? pendidikan,
    String? pekerjaan,
    String? minat,
  }) async {
    // Buat salinan profil baru dengan data yang diupdate
    _profile = _profile.copyWith(
      nama: nama,
      email: email,
      telepon: telepon,
      alamat: alamat,
      pendidikan: pendidikan,
      pekerjaan: pekerjaan,
      minat: minat,
    );
    // Beritahu listeners bahwa data telah berubah
    notifyListeners();
  }

  // Method untuk mengupdate foto profil dari kamera atau galeri
  Future<void> updateFotoProfil(ImageSource source) async {
    try {
      final picker = ImagePicker();
      // Pilih gambar dari sumber yang ditentukan
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 500,  // Maksimal lebar 500px
        maxHeight: 500, // Maksimal tinggi 500px
        imageQuality: 85, // Kualitas kompresi 85%
      );

      if (pickedFile != null) {
        // Dapatkan direktori dokumen aplikasi
        final directory = await getApplicationDocumentsDirectory();
        final fileName = 'profile_photo${path.extension(pickedFile.path)}';
        final savedImage = File('${directory.path}/$fileName');

        // Salin gambar yang dipilih ke direktori aplikasi
        await File(pickedFile.path).copy(savedImage.path);

        // Update path foto profil
        _profile = _profile.copyWith(fotoProfil: savedImage.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating profile photo: $e');
      rethrow;
    }
  }

  // Method untuk menghapus foto profil
  Future<void> deleteFotoProfil() async {
    try {
      // Cek apakah ada foto profil yang tersimpan
      if (_profile.fotoProfil.isNotEmpty) {
        final file = File(_profile.fotoProfil);
        // Hapus file jika ada
        if (await file.exists()) {
          await file.delete();
        }
        // Reset path foto profil menjadi string kosong
        _profile = _profile.copyWith(fotoProfil: '');
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting profile photo: $e');
      rethrow;
    }
  }

  // Method untuk mereset profil ke data kosong
  void resetProfile() {
    _profile = Profile(
      nama: '',
      email: '',
      telepon: '',
      alamat: '',
      pendidikan: '',
      pekerjaan: '',
      minat: '',
      fotoProfil: '',
    );
    notifyListeners();
  }
}