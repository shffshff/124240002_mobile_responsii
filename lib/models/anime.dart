class Anime {
  final String id;
  final String title;
  final String? posterImage;
  final String? coverImage;
  final String ageRating;
  final String averageRating;
  final int? episodeCount;
  final String synopsis;

  Anime({
    required this.id,
    required this.title,
    this.posterImage,
    this.coverImage,
    required this.ageRating,
    required this.averageRating,
    this.episodeCount,
    required this.synopsis,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    final attributes = (json['attributes'] as Map<String, dynamic>?) ?? {};
    final titles = attributes['titles'] as Map<String, dynamic>?;

    // Nama Anime clue key di JSON: titles->en_jp (with graceful fallbacks)
    String title = titles?['en_jp'] ??
        attributes['canonicalTitle'] ??
        titles?['en'] ??
        titles?['ja_jp'] ??
        'Untitled';

    // Poster Image clue key: posterImage->tiny/small/etc
    final posterImageMap = attributes['posterImage'] as Map<String, dynamic>?;
    String? poster = posterImageMap?['small'] ??
        posterImageMap?['medium'] ??
        posterImageMap?['large'] ??
        posterImageMap?['original'] ??
        posterImageMap?['tiny'];

    // Cover Image clue key: coverImage->tiny/small/etc
    final coverImageMap = attributes['coverImage'] as Map<String, dynamic>?;
    String? cover = coverImageMap?['large'] ??
        coverImageMap?['original'] ??
        coverImageMap?['small'] ??
        coverImageMap?['tiny'] ??
        poster; // Fallback to poster if cover is absent

    // Rating clue key: averageRating
    final rating = attributes['averageRating']?.toString() ?? 'N/A';

    // Rating Umur clue key: ageRating
    final age = attributes['ageRating']?.toString() ?? 'PG';

    // Episode Count clue key: episodeCount
    final episodes = attributes['episodeCount'] as int?;

    // Sinopsis clue key: synopsis
    final syn = attributes['synopsis']?.toString() ?? 'Sinopsis tidak tersedia.';

    return Anime(
      id: json['id']?.toString() ?? '',
      title: title,
      posterImage: poster,
      coverImage: cover,
      ageRating: age,
      averageRating: rating,
      episodeCount: episodes,
      synopsis: syn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'posterImage': posterImage,
      'coverImage': coverImage,
      'ageRating': ageRating,
      'averageRating': averageRating,
      'episodeCount': episodeCount,
      'synopsis': synopsis,
    };
  }

  factory Anime.fromMap(Map<dynamic, dynamic> map) {
    return Anime(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? 'Untitled',
      posterImage: map['posterImage']?.toString(),
      coverImage: map['coverImage']?.toString(),
      ageRating: map['ageRating']?.toString() ?? 'PG',
      averageRating: map['averageRating']?.toString() ?? 'N/A',
      episodeCount: map['episodeCount'] is int ? map['episodeCount'] as int : null,
      synopsis: map['synopsis']?.toString() ?? 'Sinopsis tidak tersedia.',
    );
  }
}
