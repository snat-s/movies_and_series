import 'package:flutter/material.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:movie_app_final/screens/movie_detail_screen.dart';
import 'package:movie_app_final/widgets/star_rating.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Hero(
            tag: 'movieImage_${movie.id}',
            child: Image.memory(
              movie.image!,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    if (movie.watched)
                      const Text(
                        'Rating:',
                        style: TextStyle(fontSize: 16),
                      ),
                    if (movie.watched) SizedBox(width: 7),
                    if (movie.watched) StarRating(rating: movie.rating),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Text(
                      'Genre:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 4),
                    Chip(label: Text(movie.genre))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
