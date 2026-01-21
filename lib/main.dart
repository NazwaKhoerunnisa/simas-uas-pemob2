import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'core/utils/animated_navigation.dart';

// AUTH
import 'screens/login_page.dart';
import 'screens/register_page.dart';

// CORE
import 'screens/splash_page.dart';
import 'screens/dashboard_page.dart';

// FITUR
import 'screens/agenda_list_page.dart';
import 'screens/keuangan_list_page.dart';
import 'screens/qurban_list_page.dart';
import 'screens/donasi_list_page.dart';
import 'screens/ramadhan_list_page.dart';
import 'screens/jadwal_shalat_page.dart';

// THEME
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Inisialisasi date formatting untuk semua locale
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SIMAS',
      theme: AppTheme.lightTheme, // ✅ Masjid vibes theme

      // 👉 mulai dari splash
      initialRoute: '/splash',

      routes: {
        '/splash': (context) => const SplashPage(),
        '/': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/agenda': (context) => const AgendaListPage(),
        '/keuangan': (context) => const KeuanganListPage(),
        '/qurban': (context) => const QurbanListPage(),
        '/donasi': (context) => const DonasiListPage(),
        '/ramadhan': (context) => const RamadhanListPage(),
        '/jadwal-shalat': (context) => const JadwalShalatPage(),
      },
      onGenerateRoute: (settings) {
        return SlidePageRoute(builder: (_) => Container());
      },
    );
  }
}
