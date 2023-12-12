// Search for a particular movie on TMDB.
// For now it is free and I hope I can maintain it like that.

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app_final/models/tmdb/movie.dart';

Future<List<TMDBMovie>> fetchMovies(String query) async {
  String processed_query = Uri.encodeQueryComponent(query);
  String key = dotenv.env['API_MOVIES_TMDB'] ?? '';

  final response = await http.get(
    Uri.parse(
        'https://api.themoviedb.org/3/search/movie?query=$processed_query&include_adult=false&language=en-US&page=1'),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $key',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> json = jsonDecode(response.body);
    //print(json['results']);
    List<TMDBMovie> movie_list = [];
    for (final dynamic part in json['results']) {
      movie_list.add(TMDBMovie.fromJson(part));
    }
    return movie_list;
  } else {
    print("HOLY ERROR BATMAN");
    throw Exception('Failed to load movies check the key parameter.');
  }
}
