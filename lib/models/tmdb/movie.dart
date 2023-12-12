class TMDBMovie {
  final String backdropPath;
  final List<int> genreIds;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String posterPath;
  final String releaseDate;
  final String title;

  TMDBMovie({
    this.backdropPath = "",
    required this.genreIds,
    required this.id,
    this.originalLanguage = "",
    required this.originalTitle,
    this.posterPath = "",
    this.releaseDate = "",
    this.title = "",
  });

  factory TMDBMovie.fromJson(Map<String, dynamic> json) {
    return TMDBMovie(
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: List<int>.from(json['genre_ids'].map((x) => x as int)),
      id: json['id'],
      originalLanguage: json['original_language'] ?? '',
      originalTitle: json['original_title'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      title: json['title'] ?? '',
    );
  }
}
