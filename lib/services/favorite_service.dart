import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/anime.dart';

class FavoriteService {
  static const String boxName = 'favorite_anime_box';

  /// Inisialisasi Hive dan buka box untuk anime favorit
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(boxName);
  }

  /// Mengambil instance box
  static Box get box => Hive.box(boxName);

  /// Memberikan listenable untuk ValueListenableBuilder pada UI
  static ValueListenable<Box> listenable() {
    return Hive.box(boxName).listenable();
  }

  /// Cek apakah anime sudah ada di daftar favorit
  static bool isFavorite(String animeId) {
    return Hive.box(boxName).containsKey(animeId);
  }

  /// Tambah anime ke favorit
  static Future<void> addFavorite(Anime anime) async {
    await Hive.box(boxName).put(anime.id, anime.toMap());
  }

  /// Hapus anime dari favorit
  static Future<void> removeFavorite(String animeId) async {
    await Hive.box(boxName).delete(animeId);
  }

  /// Toggle favorit (tambah jika belum ada, hapus jika sudah ada)
  static Future<bool> toggleFavorite(Anime anime) async {
    if (isFavorite(anime.id)) {
      await removeFavorite(anime.id);
      return false; // status sekarang: bukan favorit
    } else {
      await addFavorite(anime);
      return true; // status sekarang: favorit
    }
  }

  /// Mengambil semua anime favorit dalam bentuk daftar Anime
  static List<Anime> getFavorites() {
    final currentBox = Hive.box(boxName);
    final List<Anime> list = [];
    for (var key in currentBox.keys) {
      final val = currentBox.get(key);
      if (val != null) {
        final map = Map<String, dynamic>.from(val as Map);
        list.add(Anime.fromMap(map));
      }
    }
    return list;
  }

  /// Mendapatkan jumlah total anime yang disukai
  static int getFavoritesCount() {
    return Hive.box(boxName).length;
  }
}
