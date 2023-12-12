import 'package:flutter/material.dart';
import 'package:movie_app_final/models/database_helper.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:movie_app_final/widgets/selectable_star_rating.dart';
import 'package:movie_app_final/widgets/star_rating.dart';

class MovieEditScreen extends StatefulWidget {
  final Movie movie;

  const MovieEditScreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieEditScreenState createState() => _MovieEditScreenState();
}

class _MovieEditScreenState extends State<MovieEditScreen> {
  late TextEditingController _genreController;
  late TextEditingController _reviewController;
  late int _rating;
  late bool _watched;
  @override
  void initState() {
    super.initState();
    _genreController = TextEditingController(text: widget.movie.genre);
    _reviewController = TextEditingController(text: widget.movie.review);
    _rating = widget.movie.rating;
    _watched = widget.movie.watched;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Genre:'),
            TextField(
              controller: _genreController,
            ),
            SizedBox(height: 20),
            Text('Review:'),
            TextField(
              controller: _reviewController,
              maxLines: null,
            ),
            const SizedBox(height: 20),
            const Text('Rating:'),
            Center(
              child: SelectableStarRating(
                initialRating: widget.movie.rating,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),
            CheckboxListTile(
              title: const Text('Watched'),
              value: _watched,
              onChanged: (bool? value) {
                setState(() {
                  _watched = value ?? false;
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Save changes and return to the previous screen
                  int result = await DatabaseHelper().updateMovie(
                    Movie(
                      id: widget.movie.id,
                      title: widget.movie.title,
                      genre: _genreController.text,
                      review: _reviewController.text,
                      rating: _rating,
                      image: widget.movie.image,
                      watched: _watched,
                    ),
                  );
                  if (result > 0) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Delete Movie
                  int result =
                      await DatabaseHelper().deleteMovie(widget.movie.id);
                  if (result > 0) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Delete Movie'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
