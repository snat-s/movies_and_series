import 'package:flutter/material.dart';

class SelectableStarRating extends StatefulWidget {
  final Function(int) onRatingChanged;
  final int initialRating;
  SelectableStarRating({
    required this.onRatingChanged,
    this.initialRating = 0,
  });

  @override
  _SelectableStarRatingState createState() => _SelectableStarRatingState();
}

class _SelectableStarRatingState extends State<SelectableStarRating> {
  late int _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _rating ? Icons.star : Icons.star_border,
          ),
          onPressed: () {
            setState(() {
              _rating = index + 1;
              widget.onRatingChanged(_rating);
            });
          },
        );
      }),
    );
  }
}
