import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/anime.dart';

class ApiService {
  static const String baseUrl = 'https://kitsu.io/api/edge';

  static final Map<String, String> _headers = {
    'Accept': 'application/vnd.api+json',
    'Content-Type': 'application/vnd.api+json',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
  };

  /// Mengambil daftar semua anime (default 20 item)
  static Future<List<Anime>> fetchAnimeList({int limit = 20, int offset = 0}) async {
    final uri = Uri.parse('$baseUrl/anime/?page[limit]=$limit&page[offset]=$offset');
    
    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final List<dynamic> dataList = decoded['data'] as List<dynamic>? ?? [];

        return dataList
            .map((item) => Anime.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Gagal memuat daftar anime (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data: $e');
    }
  }

  /// Mengambil detail anime berdasarkan anime_id
  static Future<Anime> fetchAnimeDetail(String animeId) async {
    final uri = Uri.parse('$baseUrl/anime/$animeId');

    try {
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>;

        return Anime.fromJson(data);
      } else {
        throw Exception('Gagal memuat detail anime (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail anime: $e');
    }
  }
}
