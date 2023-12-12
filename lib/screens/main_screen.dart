import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_app_final/models/database_helper.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:movie_app_final/screens/add_movie_screen.dart';
import 'package:movie_app_final/screens/genre_screen.dart';
import 'package:movie_app_final/screens/movie_detail_screen.dart';
import 'package:movie_app_final/screens/movie_edit_screen.dart';
import 'package:movie_app_final/widgets/genre_card.dart';
import 'package:movie_app_final/widgets/movie_card.dart';

class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Movie> movies = [];
  Set<String> genres = {};
  List<Uint8List?> pictures = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
    loadMovies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _handleTabChange() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  loadMovies() async {
    movies = await _dbHelper.getMovies();
    for (final Movie movie in movies) {
      if (!genres.contains(movie.movieGenre)) {
        genres.add(movie.movieGenre);
        pictures.add(movie.poster);
      }
    }
    setState(() {});
  }

  void _addMovieScreen(int id, List<Movie> movies) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddMovieScreen(
          id: id + 1,
          genres: genres.toList(),
        ),
      ),
    ).then((result) {
      loadMovies(); // Reload movies if a new movie was added
    });
  }

  void _navigateToGenreScreen(String genre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenreScreen(genre: genre, movies: movies),
      ),
    ).then((value) => loadMovies());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movie Logger'),
          bottom: TabBar(
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            controller: _tabController,
            tabs: const [
              Tab(text: 'Genres'),
              Tab(text: 'Movies'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            // Tab 1: Genres
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: genres.toList().length,
              itemBuilder: (context, index) {
                final genre = genres.toList()[index];
                return InkWell(
                  onTap: () => _navigateToGenreScreen(genre),
                  child: GenreCard(
                    image: pictures[index],
                    genre: genre,
                  ),
                );
              },
            ),

            // Tab 2: All Movies
            ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailScreen(movie: movies[index])),
                      ).then((value) => loadMovies());
                    },
                    child: MovieCard(movie: movies[index]));
              },
            ),
          ],
        ),
        floatingActionButton: _tabController.index == 1
            ? FloatingActionButton(
                onPressed: () {
                  _addMovieScreen(movies.length, movies);
                },
                child: const Icon(Icons.add),
              )
            : null,
      ),
    );
  }
}
