import 'package:flutter/material.dart';
import 'package:cartelera/movie.dart';

class Favorite extends StatefulWidget {
  final Movie movie;

  Favorite({@required this.movie});

  @override
  State<StatefulWidget> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  Movie currentMovie;

  @override
  void initState() {
    currentMovie = widget.movie;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Align(
        alignment: Alignment.bottomLeft,
        child: new IconButton(
            splashColor: Colors.transparent,
            padding: EdgeInsets.only(bottom: 5, right: 10),
            color: Colors.white.withOpacity(0.8),
            icon: Icon(
              currentMovie.fav ? Icons.star : Icons.star_border,
            ), // Icon
            onPressed: onFavoredImagePressed), // IconButton
      ), // Align
    ); // Container
  }

  onFavoredImagePressed() {
    setState(() => currentMovie.fav = !currentMovie.fav);
  }
}
