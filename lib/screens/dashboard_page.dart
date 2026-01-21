import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../presentation/widgets/masjid_profile_widget.dart';
import '../presentation/widgets/islamic_calendar_widget.dart';
import '../data/services/masjid_profile_service.dart';
import 'edit_masjid_profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _masjidService = MasjidProfileService();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Logout'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editProfile() async {
    final profile = await _masjidService.getMasjidProfile();

    if (!mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditMasjidProfilePage(
          profile: profile,
          onSuccess: () {
            setState(() {});
          },
        ),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🕌 PROFIL MASJID
            MasjidProfileWidget(
              onEditPressed: _editProfile,
            ),
            const SizedBox(height: AppSpacing.xxl),

            // 🎯 FITUR UTAMA - Grid Layout with Icons & Labels
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.85,
              children: [
                _buildFeatureBox(
                  icon: Icons.calendar_month,
                  label: 'Agenda',
                  color: AppColors.primary,
                  onTap: () => Navigator.pushNamed(context, '/agenda'),
                ),
                _buildFeatureBox(
                  icon: Icons.account_balance_wallet,
                  label: 'Keuangan',
                  color: AppColors.success,
                  onTap: () => Navigator.pushNamed(context, '/keuangan'),
                ),
                _buildFeatureBox(
                  icon: Icons.favorite,
                  label: 'Donasi',
                  color: const Color(0xFFE91E63),
                  onTap: () => Navigator.pushNamed(context, '/donasi'),
                ),
                _buildFeatureBox(
                  icon: Icons.schedule,
                  label: 'Jadwal Shalat',
                  color: const Color(0xFF00897B),
                  onTap: () => Navigator.pushNamed(context, '/jadwal-shalat'),
                ),
                _buildFeatureBoxText(
                  iconText: '🐄',
                  label: 'Qurban',
                  color: AppColors.accent,
                  onTap: () => Navigator.pushNamed(context, '/qurban'),
                ),
                _buildFeatureBoxText(
                  iconText: '🌙',
                  label: 'Ramadhan',
                  color: const Color(0xFF7C4DFF),
                  onTap: () => Navigator.pushNamed(context, '/ramadhan'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),

            // 🌙 KALENDER ISLAM
            const IslamicCalendarWidget(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBox({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureBoxText({
    required String iconText,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                iconText,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
