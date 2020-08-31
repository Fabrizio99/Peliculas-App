import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider {
  String _apiKey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  // el broadcast permite que se trabaje con varios listeners

  //retorna una función que recibe una lista de película
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream =>_popularesStreamController.stream;

  void disposeStreams(){
    //si tiene el método close, entonces lo llama
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url)async{
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines()async{
    final url = Uri.https(
      _url,
      '3/movie/now_playing',{
        'api_key' : _apiKey,
        'language' : _language,
      }
    );
    
    return (await _procesarRespuesta(url));
  }

  Future<List<Pelicula>> getPopulares()async{
    if(_cargando)  return [];

    _cargando = true;
    _popularesPage++;
    final url = Uri.https(
      _url,
      '3/movie/popular',{
        'api_key' : _apiKey,
        'language' : _language,
        'page'     : _popularesPage.toString()
      }
    );

    final resp = await _procesarRespuesta(url);

    _populares.addAll(resp);
    this.popularesSink(_populares);

    _cargando = false;
    return resp;
  }

  Future<List<Pelicula>> buscarPelicula(String query)async{
    final url = Uri.https(
      _url,
      '3/search/movie',{
        'api_key'       : _apiKey,
        'language'      : _language,
        'query'         : query,
      }
    );
    
    return (await _procesarRespuesta(url));
  }
}