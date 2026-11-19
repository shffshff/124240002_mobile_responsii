import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/main_page.dart';
import 'services/auth_service.dart';
import 'services/favorite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk penyimpanan lokal favorit
  await FavoriteService.init();

  // Cek status login dari SharedPreferences
  final bool loggedIn = await AuthService.isLoggedIn();

  runApp(KeripikrollApp(isLoggedIn: loggedIn));
}

class KeripikrollApp extends StatelessWidget {
  final bool isLoggedIn;

  const KeripikrollApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF4500);

    return MaterialApp(
      title: 'Keripikroll',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        primaryColor: accentColor,
        colorScheme: const ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          surface: Color(0xFF1E1E1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0F0F0F),
          elevation: 0,
          centerTitle: false,
        ),
        useMaterial3: true,
      ),
      home: isLoggedIn ? const MainPage() : const LoginPage(),
    );
  }
}
