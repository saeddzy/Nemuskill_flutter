// Import paket-paket yang diperlukan untuk aplikasi Flutter
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nemuskill/screens/classes_page.dart';
import 'package:nemuskill/screens/materials_page.dart';
import 'package:nemuskill/screens/reviews_page.dart';
import 'package:nemuskill/screens/login_page.dart';
import 'package:nemuskill/screens/landing_page.dart';

// Import halaman-halaman custom
import 'pages/home_page.dart';
import 'pages/kelas_page.dart';
import 'pages/planning_page.dart';
import 'pages/profil_page.dart';

// Import provider untuk state management
import 'providers/profile_provider.dart';
import 'providers/planning_provider.dart';

// Titik masuk utama aplikasi Flutter
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NemuskillApp());
}

// Widget root dari aplikasi Nemuskill
class NemuskillApp extends StatelessWidget {
  const NemuskillApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup provider untuk state management menggunakan MultiProvider
    return MultiProvider(
      providers: [
        // Provider untuk mengelola data profil
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        // Provider untuk mengelola data planning/penjadwalan
        ChangeNotifierProvider(create: (_) => PlanningProvider()),
      ],
      // Konfigurasi MaterialApp utama
      child: MaterialApp(
        title: 'Nemuskill',
        debugShowCheckedModeBanner: false,
        // Setup tema aplikasi
        theme: ThemeData(
          // Buat skema warna dengan warna ungu sebagai warna utama
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6C63FF),
            primary: const Color(0xFF6C63FF),
            secondary: const Color(0xFF03DAC5),
          ),
          // Gunakan font Poppins dari Google Fonts
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        // Set halaman utama sebagai LandingPage
        home: const LandingPage(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/main': (context) => const MainPage(),
          '/classes': (context) => const ClassesPage(),
          '/materials': (context) => MaterialsPage(classId: ModalRoute.of(context)!.settings.arguments as int),
          '/reviews': (context) => const ReviewsPage(),
          '/landing': (context) => const LandingPage(),
        },
      ),
    );
  }
}

// Halaman utama yang menampung semua halaman dengan bottom navigation
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index halaman yang sedang dipilih
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    print('MainPage: Widget initialized');
  }

  // Daftar halaman-halaman yang tersedia
  final List<Widget> _pages = const [
    HomePage(),      // Halaman beranda
    KelasPage(),     // Halaman kelas
    PlanningPage(),  // Halaman planning
    ReviewsPage(),   // Halaman reviews/ulasan (baru)
    ProfilPage(),    // Halaman profil
  ];

  // Fungsi untuk mengubah halaman ketika item navigation ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tampilkan halaman sesuai dengan index yang dipilih
      body: _pages[_selectedIndex],
      // Bottom navigation bar dengan 4 destinasi
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          // Tab Home
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          // Tab Kelas
          NavigationDestination(
            icon: Icon(Icons.class_outlined),
            selectedIcon: Icon(Icons.class_),
            label: 'Kelas',
          ),
          // Tab Planning
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Planning',
          ),
          // Tab Reviews/Ulasan (baru)
          NavigationDestination(
            icon: Icon(Icons.reviews_outlined), // Atau ikon lain yang sesuai
            selectedIcon: Icon(Icons.reviews),
            label: 'Ulasan',
          ),
          // Tab Profil
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
