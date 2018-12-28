import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cartelera/movie_list.dart';
import 'package:cartelera/favorite.dart';

// Create a stateful widget
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

// Create the state for our stateful widget
class HomePageState extends State<HomePage> {
  //final String url = "http://www.mocky.io/v2/5c24e7bc30000068007a61de";
  final String url = "https://api.themoviedb.org/3/discover/movie?api_key=bf8fd38dca5a76f8943629f454221dac";

  // Funcion para sacar los datos de forma asincronica.
  Future<MovieList> getJSONData() async {
    var response = await http.get(
        // Codifica la url con % (seguridad)
        Uri.encodeFull(url),
        // Solo aceptar respuestas Json
        headers: {"Accept": "application/json"});

    // Convierte la respuesta a formato json
    var jsonConvertedData = jsonDecode(response.body);
    // Crea la lista de peliculas
    MovieList list = MovieList.fromMap(jsonConvertedData);

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getJSONData(),
      builder: (context, snapshots) {
        if (snapshots.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Cartelera'),
            ),
            body: Text('Error: No se pudo cargar la cartelera'),
          );
        }
        switch (snapshots.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            List data = snapshots.data.movies;
            return Scaffold(
              backgroundColor: Colors.red.withOpacity(0.3),
              appBar: AppBar(
                title: Text('Cartelera'),
              ),
              // Crea un GridView.
              body: GridView(
                padding: EdgeInsets.only(top: 10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 0.6),
                children: List.generate(data.length, (index) {                
                  return Card(
                    color: Colors.black.withOpacity(0.6),
                    elevation: 5.0,
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          'https://image.tmdb.org/t/p/w500' +
                              data[index.toInt()].poster_path,
                        ),
                        Favorite(movie: data[index.toInt()]),                        
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
                              child: Text(
                                'Rating : ${data[index.toInt()].vote_average}',
                                style: TextStyle(color: Colors.white),
                                textScaleFactor: 0.8,
                              ),
                            ))
                      ],
                    ),
                  );
                }),
              ),
            );
          default:
        }
      },
    );
  }
}
