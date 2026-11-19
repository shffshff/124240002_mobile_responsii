import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_cipatumblerbarulecet/services/api_service.dart';

void main() {
  test('ApiService fetchAnimeList returns list of Anime', () async {
    final list = await ApiService.fetchAnimeList(limit: 2);
    expect(list.isNotEmpty, true);
    expect(list.first.title.isNotEmpty, true);
    expect(list.first.id.isNotEmpty, true);
    expect(list.first.ageRating.isNotEmpty, true);
  });

  test('ApiService fetchAnimeDetail returns Anime detail', () async {
    final anime = await ApiService.fetchAnimeDetail('1');
    expect(anime.id, '1');
    expect(anime.title, 'Cowboy Bebop');
    expect(anime.averageRating.isNotEmpty, true);
    expect(anime.synopsis.isNotEmpty, true);
  });
}
