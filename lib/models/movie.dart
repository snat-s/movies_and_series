import 'dart:typed_data';

class Movie {
  int id;
  String title;
  String genre;
  String review;
  Uint8List? image;
  int rating;
  bool watched;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.review,
    required this.rating,
    required this.watched,
    this.image,
  });
  String get movieGenre => genre;
  Uint8List? get poster => image;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'review': review,
      'image': image,
      'rating': rating,
      'watched': watched,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      genre: map['genre'],
      review: map['review'],
      image: map['image'],
      rating: map['rating'],
      watched: map['watched'] is int ? map['watched'] != 0 : map['watched'],
    );
  }
}
