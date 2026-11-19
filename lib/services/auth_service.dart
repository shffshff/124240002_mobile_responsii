import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUsername = 'logged_in_username';

  static const String validNim = '124240002';
  static const String validPassword = '123';

  /// Memeriksa status login saat aplikasi pertama kali dibuka
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Mendapatkan username yang sedang login dari SharedPreferences
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? validNim;
  }

  /// Proses autentikasi login
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final trimmedUser = username.trim();
    final trimmedPass = password.trim();

    if (trimmedUser.isEmpty || trimmedPass.isEmpty) {
      return {
        'success': false,
        'message': 'Username dan password tidak boleh kosong!',
      };
    }

    if (trimmedUser == validNim && trimmedPass == validPassword) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsLoggedIn, true);
      await prefs.setString(_keyUsername, trimmedUser);
      return {
        'success': true,
        'message': 'Login berhasil! Selamat datang.',
      };
    } else {
      return {
        'success': false,
        'message': 'Username atau password salah! (NIM: $validNim, Pass: $validPassword)',
      };
    }
  }

  /// Logout dan hapus status login dari SharedPreferences
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUsername);
  }
}
