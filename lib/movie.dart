class Movie {
  final String title;
  final String poster_path;
  final num vote_average;
  bool fav;

  Movie({this.title, this.poster_path, this.vote_average, this.fav});

  factory Movie.fromJson(Map value) {
    return Movie(
      title: value['title'],
      poster_path: value['poster_path'],
      vote_average: value['vote_average'],
      fav: false
    );
  }
}