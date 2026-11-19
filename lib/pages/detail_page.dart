import 'package:flutter/material.dart';
import '../models/anime.dart';
import '../services/api_service.dart';
import '../services/favorite_service.dart';
import '../widgets/kitsu_image.dart';

class DetailPage extends StatefulWidget {
  final String animeId;
  final Anime? initialAnime;

  const DetailPage({
    super.key,
    required this.animeId,
    this.initialAnime,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Anime> _detailFuture;
  late bool _isFavorite;
  Anime? _currentAnime;

  @override
  void initState() {
    super.initState();
    _currentAnime = widget.initialAnime;
    _isFavorite = FavoriteService.isFavorite(widget.animeId);
    _detailFuture = ApiService.fetchAnimeDetail(widget.animeId);
  }

  void _toggleFavorite(Anime anime) async {
    final status = await FavoriteService.toggleFavorite(anime);
    setState(() {
      _isFavorite = status;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status
              ? 'Berhasil ditambahkan ke favorit!'
              : 'Dihapus dari daftar favorit!',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: status ? const Color(0xFFFF4500) : Colors.grey[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFFF4500);

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0F0F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder<Anime>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // Ada loading indicator untuk saat load data detail anime
          if (snapshot.connectionState == ConnectionState.waiting && _currentAnime == null) {
            return const Center(
              child: CircularProgressIndicator(color: accentColor),
            );
          }

          if (snapshot.hasError && _currentAnime == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat detail anime:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _detailFuture = ApiService.fetchAnimeDetail(widget.animeId);
                        });
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: accentColor),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          final anime = snapshot.data ?? _currentAnime!;
          final displayCover = (anime.coverImage != null && anime.coverImage!.isNotEmpty)
              ? anime.coverImage!
              : (anime.posterImage ?? '');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // i. Cover Image, sebagai hero image
                Hero(
                  tag: 'anime_cover_${anime.id}',
                  child: SizedBox(
                    width: double.infinity,
                    height: 220,
                    child: KitsuImage(
                      imageUrl: displayCover.isNotEmpty ? displayCover : null,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 220,
                      errorWidget: Container(
                        color: const Color(0xFF1E1E1E),
                        child: const Center(
                          child: Icon(Icons.image_not_supported,
                              color: Colors.white38, size: 50),
                        ),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Anime
                      Text(
                        anime.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // ii. Rating (averageRating)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            anime.averageRating,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // iii. Rating Umur & Jumlah Episode (ageRating, episodeCount)
                      Text(
                        '${anime.ageRating} • ${anime.episodeCount != null ? "${anime.episodeCount} Episodes" : "N/A Episodes"}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Action Row: Button "Nonton" & Button Favorit
                      Row(
                        children: [
                          // v. Button "Nonton" (bersifat static)
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Memutar anime "${anime.title}"... (Fitur statis)'),
                                      backgroundColor: accentColor,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.play_arrow, color: Colors.white, size: 22),
                                label: const Text(
                                  'Nonton',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // vi. Button untuk menambahkan anime ke daftar favorit dengan UI berbeda
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF242424),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: _isFavorite ? accentColor : Colors.white24,
                                width: 1.2,
                              ),
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: _isFavorite ? accentColor : Colors.white70,
                                size: 24,
                              ),
                              onPressed: () => _toggleFavorite(anime),
                              tooltip: _isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // iv. Sinopsis anime
                      const Text(
                        'Overview',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        anime.synopsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
