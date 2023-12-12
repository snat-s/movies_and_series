import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'movie.dart';

class DatabaseHelper {
  static Database? _db; // Declare _db as nullable

  Future<Database?> get db async {
    if (_db != null) return _db;

    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    print(documentsDirectory);
    String path = join(documentsDirectory.path, "entertainment.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE Movies (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, genre TEXT, review TEXT, image BLOB, rating INTEGER, watched BOOLEAN)",
    );
  }

  Future<int> saveMovie(Movie movie) async {
    var dbClient = await db;
    if (dbClient == null) {
      return -1;
    }
    int res = await dbClient.insert("Movies", movie.toMap());
    return res;
  }

  Future<int> updateMovie(Movie movie) async {
    var dbClient = await db;
    if (dbClient == null) {
      return -1;
    }

    int res = await dbClient.update(
      "Movies",
      movie.toMap(),
      where: 'id = ?',
      whereArgs: [movie.id],
    );
    return res;
  }

  Future<List<Movie>> getMovies() async {
    var dbClient = await db;
    if (dbClient == null) {
      return [];
    }
    List<Map<String, dynamic>> list =
        await dbClient.rawQuery('SELECT * FROM Movies');
    List<Movie> movies = [];
    for (var item in list) {
      movies.add(Movie.fromMap(item));
    }
    return movies;
  }

  Future<int> deleteMovie(int id) async {
    var dbClient = await db;
    if (dbClient == null) {
      return -1;
    }
    int res = await dbClient.delete(
      "Movies",
      where: 'id = ?',
      whereArgs: [id],
    );
    return res;
  }
}
