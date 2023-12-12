import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:movie_app_final/screens/movie_edit_screen.dart';
import 'package:movie_app_final/widgets/star_rating.dart';

class MovieDetailScreen extends StatefulWidget {
  Movie movie;

  MovieDetailScreen({
    Key? key,
    required this.movie,
  }) : super(key: key);

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  void _editMovie(BuildContext context, Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieEditScreen(
          movie: movie,
        ),
      ),
    ).then((value) => _handleUpdate());
  }

  void _handleUpdate() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Hero(
                      tag: 'movieImage_${widget.movie.id}',
                      child: Image(
                        height: 450,
                        image: MemoryImage(widget.movie.image!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Genre: ${widget.movie.genre}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Review:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.movie.review,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                StarRating(rating: widget.movie.rating),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _editMovie(context, widget.movie);
        },
        child: const Icon(Icons.edit),
      ),
    );
  }
}
