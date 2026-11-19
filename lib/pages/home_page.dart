import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../widgets/keripikroll_logo.dart';
import '../widgets/kitsu_image.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Anime>> _animeListFuture;

  @override
  void initState() {
    super.initState();
    _animeListFuture = ApiService.fetchAnimeList();
  }

  void _refresh() {
    setState(() {
      _animeListFuture = ApiService.fetchAnimeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF4500);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        title: const Row(
          children: [
            KeripikrollLogo(size: 26),
            SizedBox(width: 8),
            Text(
              'Keripikroll',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Anime>>(
        future: _animeListFuture,
        builder: (context, snapshot) {
          // Loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: accentColor),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off,
                        color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat anime:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refresh,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: accentColor),
                      child: const Text('Coba Lagi',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final animeList = snapshot.data ?? [];
          if (animeList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada data anime ditemukan.',
                style: TextStyle(color: Colors.white60),
              ),
            );
          }

          // GridView daftar anime
          return RefreshIndicator(
            color: accentColor,
            backgroundColor: const Color(0xFF1E1E1E),
            onRefresh: () async => _refresh(),
            child: GridView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 14,
                childAspectRatio: 0.60,
              ),
              itemCount: animeList.length,
              itemBuilder: (context, index) {
                final anime = animeList[index];

                return GestureDetector(
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Poster Image (pakai KitsuImage) ─────────
                        Expanded(
                          child: KitsuImage(
                            imageUrl: anime.posterImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),

                        // ── Info ─────────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Nama Anime
                              Text(
                                anime.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 3),

                              // Rating Umur & Jumlah Episode
                              Text(
                                '${anime.ageRating} • ${anime.episodeCount != null ? "${anime.episodeCount} Eps" : "N/A Eps"}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),

                              // Rating
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 13),
                                  const SizedBox(width: 4),
                                  Text(
                                    anime.averageRating,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
