import 'package:flutter/material.dart';
import 'package:movie_app_final/functions/search.dart';
import 'package:movie_app_final/models/tmdb/movie.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> _searchResults = [];
  List<String> _movieImages = [];

  void _performSearch(String query) async {
    List<TMDBMovie> movies = await fetchMovies(query);
    String base_url = "http://image.tmdb.org/t/p/";
    String poster_sizes = "w185";
    List<String> results = movies.map(
      (e) {
        return e.title;
      },
    ).toList();
    List<String> results_images = movies.map(
      (e) {
        return base_url + poster_sizes + e.posterPath;
      },
    ).toList();

    setState(() {
      _searchResults = results;
      _movieImages = results_images;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movie'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    _performSearch(query);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    hintText: 'Enter your search query',
                  ),
                ),
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (_searchResults.isNotEmpty) {
                return Card(
                  child: Column(
                    children: [
                      Text(_searchResults[index]),
                      //Image.network(_movieImages[index]),
                    ],
                  ),
                );
              }
              return const Center(
                child: Text('No results found'),
              );
            }),
          ),
        ],
      ),
    );
  }
}
