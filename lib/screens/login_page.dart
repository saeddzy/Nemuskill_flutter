import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'package:nemuskill/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _initApiService();
  }

  Future<void> _initApiService() async {
    _apiService = await ApiService.getInstance();
    if (mounted) {
      setState(() {}); // Rebuild the widget after ApiService is ready
    }
  }

  void _login() async {
    // Ensure ApiService is initialized before making API calls
    if (!mounted || _apiService == null) return;

    try {
      final response = await _apiService.post('login', {
        'email': _emailController.text,
        'password': _passwordController.text,
      });
      // Handle successful login (e.g., save token, navigate to main page)
      print('Login successful: $response');
      print('LoginPage: Type of response[\'data\']: ${response['data'].runtimeType}');
      print('Token received: ${response['data']?['token']}');
      if (response['data']?['token'] != null) {
        print('LoginPage: Inside token check block.');
        try {
          print('LoginPage: Attempting to save token...');
          await _apiService.saveToken(response['data']['token']);
          print('Token saved successfully to SharedPreferences.');
        } catch (e) {
          print('Error saving token to SharedPreferences: $e');
        }
      }
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      // Handle login error
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Tanpa bayangan
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey), // Warna ikon abu-abu
          onPressed: () {
            Navigator.of(context).pop(); // Go back to LandingPage
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // Logo or app name
            Text(
              'Nemuskill',
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Selamat Datang Kembali!',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Silakan masuk untuk melanjutkan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Email TextField
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'nama@example.com',
                labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: GoogleFonts.poppins(color: Colors.black87),
            ),
            const SizedBox(height: 20.0),
            // Password TextField
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '••••••••',
                labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              style: GoogleFonts.poppins(color: Colors.black87),
            ),
            const SizedBox(height: 30.0),
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _apiService == null ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary, // Menggunakan warna utama untuk login
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Login',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Alternative to register (if re-added later)
            TextButton(
              onPressed: () {
                // TODO: Implement navigation to registration page if needed
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Fitur registrasi belum diimplementasikan.')),
                );
              },
              child: Text(
                'Belum punya akun? Daftar di sini',
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 