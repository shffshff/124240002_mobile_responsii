import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/anime.dart';
import '../services/favorite_service.dart';
import '../widgets/kitsu_image.dart';
import 'detail_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF4500);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      // c. Data anime pada library disimpan dan dikelola dengan Hive
      body: ValueListenableBuilder<Box>(
        valueListenable: FavoriteService.listenable(),
        builder: (context, box, child) {
          final List<Anime> favorites = FavoriteService.getFavorites();

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.white.withAlpha(70),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada anime favorit.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tambahkan anime yang kamu sukai dari Beranda!',
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }

          // a. Anime ditampilkan dalam bentuk list
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final Anime anime = favorites[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  // b. Ketika anime di klik, akan menuju Detail Page dari anime tersebut
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(
                          animeId: anime.id,
                          initialAnime: anime,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        // i. Poster Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 50,
                            height: 70,
                            child: KitsuImage(
                              imageUrl: anime.posterImage,
                              fit: BoxFit.cover,
                              errorWidget: Container(
                                color: const Color(0xFF2E2E2E),
                                child: const Icon(Icons.broken_image,
                                    color: Colors.white38, size: 24),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        // Nama & Rating
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Anime
                              Text(
                                anime.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 6),

                              // Rating
                              Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    anime.averageRating,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // ii. Tombol delete untuk menghapus anime dari library
                        IconButton(
                          icon: const Icon(Icons.delete, color: accentColor),
                          onPressed: () async {
                            await FavoriteService.removeFavorite(anime.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('"${anime.title}" dihapus dari favorit.'),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.grey[850],
                              ),
                            );
                          },
                          tooltip: 'Hapus dari favorit',
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
