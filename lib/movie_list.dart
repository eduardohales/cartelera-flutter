import 'package:cartelera/movie.dart';

class MovieList {
  final List<Movie> movies;

  MovieList({this.movies});

  MovieList.fromMap(Map<String, dynamic> value) : 
  movies = List<Movie>.from(value['results'].map((movie) => Movie.fromJson(movie)));
}