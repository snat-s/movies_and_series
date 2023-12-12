import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:movie_app_final/models/database_helper.dart';
import 'package:movie_app_final/models/movie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app_final/screens/search_movie.dart';
import 'package:movie_app_final/widgets/selectable_star_rating.dart';

class AddMovieScreen extends StatefulWidget {
  final int id;
  final List<String> genres;
  const AddMovieScreen({super.key, required this.id, required this.genres});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();
  bool _watched = false;
  List<ChoiceChip> genreChips = List.empty();
  List<bool> selectedGenres = List.empty();
  int _rating = 0;
  int selectedGenreIndex = -1;
  ImagePicker picker = ImagePicker();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    genreChips = widget.genres.map((genre) {
      return ChoiceChip(
        label: Text(genre),
        selected: false, // You can manage the selected state here
        onSelected: (bool selected) {
          selectedGenreIndex = selected ? widget.genres.indexOf(genre) : -1;
        },
      );
    }).toList();
    selectedGenres = List.generate(genreChips.length, (index) => false);

    print('Received id: ${widget.id}');
  }

  Future<void> pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    setState(() {
      _imageFile = File(pickedFile.path);
      print(_imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image(
                    image: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const AssetImage('assets/generic.jpg')
                            as ImageProvider<Object>,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: pickImageFromGallery,
                  child: const Text('Pick a poster'),
                ),
              ),
              Center(
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
              ),
              Wrap(
                children: [
                  for (int index = 0; index < genreChips.length; index++)
                    FilterChip(
                      label: Text(widget.genres[index]),
                      selected: selectedGenreIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedGenreIndex = selected ? index : -1;
                        });
                      },
                    ),
                ],
              ),
              ChoiceChip(
                label: const Text('+ Add'),
                selected: false,
                onSelected: (bool selected) {
                  //addGenre(),
                  String new_genre = "";
                  if (selected) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Add Genre"),
                          content: TextField(
                            onChanged: (value) => new_genre = value,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Handle the logic for adding the genre
                                if (new_genre.isNotEmpty) {
                                  _addGenre(new_genre);
                                }
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  selected = false;
                },
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
              Center(
                child: _watched
                    ? TextField(
                        controller: _reviewController,
                        decoration: const InputDecoration(labelText: 'Review'),
                        maxLines: null,
                      )
                    : null,
              ),
              Center(
                child: _watched
                    ? SelectableStarRating(onRatingChanged: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      })
                    : null,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _addMovie(widget.id);
                  },
                  child: const Text('Add Movie'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMovie(id) async {
    // Validate input
    if (_titleController.text.isEmpty || selectedGenreIndex == -1) {
      return;
    }

    Uint8List imageBytes = await _imageFile!.readAsBytes();

    // Get selected genres
    String genre = widget.genres[selectedGenreIndex];

    // Create a new Movie object
    Movie newMovie = Movie(
      id: id,
      title: _titleController.text,
      genre: genre,
      review: _reviewController.text,
      rating: _rating,
      image: imageBytes,
      watched: _watched,
    );

    // Save the movie to the database
    await DatabaseHelper().saveMovie(newMovie);

    // Notify the calling screen that a new movie was added
    Navigator.pop(context);
  }

  void _addGenre(String new_genre) {
    setState(() {
      widget.genres.add(new_genre);
      genreChips.add(
        ChoiceChip(
          label: Text(new_genre),
          selected: false, // You can manage the selected state here
          onSelected: (bool selected) {},
        ),
      );
      selectedGenres.add(false);
      selectedGenreIndex = widget.genres.indexOf(new_genre);
    });
  }
}
