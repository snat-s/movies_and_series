import 'package:flutter/material.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:movie_app_final/screens/movie_detail_screen.dart';
import 'package:movie_app_final/widgets/movie_card.dart';

class GenreScreen extends StatelessWidget {
  final String genre;
  final List<Movie> movies;

  const GenreScreen({Key? key, required this.genre, required this.movies})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final genreMovies =
        movies.where((movie) => movie.movieGenre == genre).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('$genre Movies'),
      ),
      body: ListView.builder(
        itemCount: genreMovies.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MovieDetailScreen(movie: genreMovies[index])),
                ); //.then((value) => loadMovies());
              },
              child: MovieCard(movie: genreMovies[index]));
        },
      ),
    );
  }
}
