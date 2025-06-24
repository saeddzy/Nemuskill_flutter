import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih bersih
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              // Hero Image/Illustration
              Image.asset(
                'assets/images/nemuskill-logo.png', // Pastikan gambar ini ada
                height: MediaQuery.of(context).size.height * 0.35, // Ukuran responsif
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
              // Headline
              Text(
                'Tingkatkan Skillmu Bersama Nemuskill',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'Jelajahi berbagai kelas berkualitas tinggi dan tingkatkan kemampuanmu di bidang yang kamu minati. Belajar lebih mudah, kapan saja, di mana saja.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 60),
              // Call to Action Button (Get Started)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 7,
                  ),
                  child: Text(
                    'Mulai Belajar Sekarang',
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
} 