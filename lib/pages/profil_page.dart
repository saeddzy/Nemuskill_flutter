import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/profile_provider.dart';
import '../services/api_service.dart';
import '../screens/login_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final ApiService apiService = await ApiService.getInstance();
    await apiService.clearToken();
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditProfileDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          final profile = profileProvider.profile;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          // Profile Photo
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: ClipOval(
                              child: profile.fotoProfil.isNotEmpty
                                  ? Image.file(
                                      File(profile.fotoProfil),
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                          'https://ui-avatars.com/api/?name=${profile.nama}&background=6C63FF&color=fff',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Center(
                                              child: Text(
                                                profile.nama.isNotEmpty
                                                    ? profile.nama[0].toUpperCase()
                                                    : '?',
                                                style: const TextStyle(
                                                  fontSize: 32,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    )
                                  : Image.network(
                                      'https://ui-avatars.com/api/?name=${profile.nama}&background=6C63FF&color=fff',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Center(
                                          child: Text(
                                            profile.nama.isNotEmpty
                                                ? profile.nama[0].toUpperCase()
                                                : '?',
                                            style: const TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          // Edit Button
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
                                ),
                                onPressed: () {
                                  _showImageOptions(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.nama,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        profile.email,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Profile Information
                _buildInfoSection(
                  context,
                  'Informasi Pribadi',
                  [
                    _buildInfoRow(context, 'Nama Lengkap', profile.nama),
                    _buildInfoRow(context, 'Email', profile.email),
                    _buildInfoRow(context, 'No. Telepon', profile.telepon),
                    _buildInfoRow(context, 'Alamat', profile.alamat),
                  ],
                ),
                const SizedBox(height: 24),

                _buildInfoSection(
                  context,
                  'Informasi Tambahan',
                  [
                    _buildInfoRow(context, 'Pendidikan Terakhir', profile.pendidikan),
                    _buildInfoRow(context, 'Pekerjaan', profile.pekerjaan),
                    _buildInfoRow(context, 'Minat', profile.minat),
                  ],
                ),
                const SizedBox(height: 24),

                // Settings Section
                _buildInfoSection(
                  context,
                  'Pengaturan',
                  [
                    _buildSettingsTile(
                      context,
                      'Ubah Password',
                      Icons.lock_outline,
                      () {
                        // TODO: Implement password change
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'Notifikasi',
                      Icons.notifications_outlined,
                      () {
                        // TODO: Implement notifications settings
                      },
                    ),
                    _buildSettingsTile(
                      context,
                      'Tentang Aplikasi',
                      Icons.info_outline,
                      () {
                        // TODO: Show about dialog
                      },
                    ),
                  ],
                ),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _logout(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text('Upload Gambar'),
              onTap: () {
                Navigator.pop(context);
                _updateProfilePhoto(context, ImageSource.gallery);
              },
            ),
            if (context.read<ProfileProvider>().profile.fotoProfil.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Hapus Gambar', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteProfilePhoto(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Future<void> _updateProfilePhoto(BuildContext context, ImageSource source) async {
    try {
      await context.read<ProfileProvider>().updateFotoProfil(source);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil diperbarui'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal mengubah foto profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteProfilePhoto(BuildContext context) async {
    try {
      await context.read<ProfileProvider>().deleteFotoProfil();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto profil berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus foto profil'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showEditProfileDialog(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final profile = profileProvider.profile;

    final namaController = TextEditingController(text: profile.nama);
    final emailController = TextEditingController(text: profile.email);
    final teleponController = TextEditingController(text: profile.telepon);
    final alamatController = TextEditingController(text: profile.alamat);
    final pendidikanController = TextEditingController(text: profile.pendidikan);
    final pekerjaanController = TextEditingController(text: profile.pekerjaan);
    final minatController = TextEditingController(text: profile.minat);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profil'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: teleponController,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
              ),
              TextField(
                controller: alamatController,
                decoration: const InputDecoration(labelText: 'Alamat'),
              ),
              TextField(
                controller: pendidikanController,
                decoration: const InputDecoration(labelText: 'Pendidikan Terakhir'),
              ),
              TextField(
                controller: pekerjaanController,
                decoration: const InputDecoration(labelText: 'Pekerjaan'),
              ),
              TextField(
                controller: minatController,
                decoration: const InputDecoration(labelText: 'Minat'),
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
              if (namaController.text.isNotEmpty &&
                  emailController.text.isNotEmpty) {
                profileProvider.updateProfile(
                  nama: namaController.text,
                  email: emailController.text,
                  telepon: teleponController.text,
                  alamat: alamatController.text,
                  pendidikan: pendidikanController.text,
                  pekerjaan: pekerjaanController.text,
                  minat: minatController.text,
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
}