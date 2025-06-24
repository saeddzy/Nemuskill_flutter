import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/planning_provider.dart';
import '../providers/profile_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Consumer<ProfileProvider>(
                builder: (context, profileProvider, child) {
                  return Text(
                    'Welcome, ${profileProvider.profile.nama}!',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  );
                },
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.school,
                        size: 120,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Center(
                      child: Hero(
                        tag: 'logo',
                        child: Icon(
                          Icons.school,
                          size: 80,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBar(context),
                      const SizedBox(height: 24),
                      _buildQuickActions(context),
                      const SizedBox(height: 24),
                      _buildStatistics(context),
                      const SizedBox(height: 24),
                      _buildTodaySchedule(context),
                      const SizedBox(height: 24),
                      _buildClassList(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari planning atau kelas...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onTap: () {
          // TODO: Implementasi fungsi pencarian
        },
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aksi Cepat',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                // TODO: Implementasi lihat semua aksi
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildQuickActionItem(
                context,
                Icons.school,
                'Lihat Kelas',
                () {
                  Navigator.of(context).pushNamed('/kelas');
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionItem(
                context,
                Icons.book,
                'Lihat Materi',
                () {
                  Navigator.of(context).pushNamed('/materials');
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionItem(
                context,
                Icons.reviews,
                'Kelola Ulasan',
                () {
                  Navigator.of(context).pushNamed('/reviews');
                },
              ),
              _buildQuickActionItem(
                context,
                Icons.calendar_today,
                'Planning Baru',
                () {
                  // TODO: Implementasi buat planning baru
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionItem(
                context,
                Icons.assignment,
                'Tambah Tugas',
                () {
                  // TODO: Implementasi tambah tugas
                },
              ),
              const SizedBox(width: 16),
              _buildQuickActionItem(
                context,
                Icons.event,
                'Jadwal Ujian',
                () {
                  // TODO: Implementasi jadwal ujian
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.7),
              Theme.of(context).colorScheme.primary,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistik',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              context,
              'Total Planning',
              '12',
              Icons.calendar_today,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'Dalam Proses',
              '5',
              Icons.pending_actions,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'Selesai',
              '7',
              Icons.check_circle,
              Colors.green,
            ),
            _buildStatCard(
              context,
              'Kelas Aktif',
              '3',
              Icons.class_,
              Colors.purple,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const Spacer(),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Jadwal Hari Ini',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/planning');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<PlanningProvider>(
          builder: (context, planningProvider, child) {
            final todayPlannings = planningProvider.planningList
                .where((planning) =>
                    DateFormat('yyyy-MM-dd').format(planning.tanggal) ==
                    DateFormat('yyyy-MM-dd').format(DateTime.now()))
                .toList();

            if (todayPlannings.isEmpty) {
              return _buildEmptyState(
                context,
                Icons.event_busy,
                'Tidak ada jadwal hari ini',
                'Tambahkan planning baru untuk mengisi jadwalmu',
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayPlannings.length,
              itemBuilder: (context, index) {
                final planning = todayPlannings[index];
                return _buildScheduleCard(context, planning);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildScheduleCard(BuildContext context, Planning planning) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implementasi detail planning
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStatusColor(planning.status),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      planning.judul,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      planning.deskripsi,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(planning.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  planning.status,
                  style: GoogleFonts.poppins(
                    color: _getStatusColor(planning.status),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Kelas',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/kelas');
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildClassCard(
                context,
                'Flutter Development',
                'Pemrograman Mobile',
                '24 Anggota',
                Icons.code,
                Colors.blue,
              ),
              _buildClassCard(
                context,
                'UI/UX Design',
                'Desain Aplikasi',
                '18 Anggota',
                Icons.design_services,
                Colors.purple,
              ),
              _buildClassCard(
                context,
                'Web Development',
                'Pemrograman Web',
                '32 Anggota',
                Icons.web,
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassCard(
    BuildContext context,
    String title,
    String category,
    String memberCount,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/kelas');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 32,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Aktif',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    memberCount,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

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
} 