import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';

class ActoresProvider{
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Actor>> getCast(String peliId)async{
    final url = Uri.https(
      _url,
      '3/movie/$peliId/credits',{
        'api_key'  : _apiKey,
        'language' : _language,
      }
    );
    
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = Actores.fromJsonList(decodedData['cast']);
    return cast.actores;
  }
}