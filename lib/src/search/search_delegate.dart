import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{

  String seleccion = '';
  final peliculasProvider = PeliculasProvider();

  final peliculas = [
    'Aquaman',
    'The Batman',
    'Zack Snyder\'s Justice League',
    'The Flash'
  ];
  final peliculasRecientes = [
    'Spiderman',
    'Capitan America'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // las acciones del appbar
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          // variable interna del searchdelegate donde se almacena lo que escribe el usuario
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda del appbar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        // progress es el tiempo en que se va a animar el icono
        progress: transitionAnimation,
      ),
      onPressed: (){
        //metodo interno del searchdelegate
        close(context,null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados que se va a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escribe
    /*final listaSugerida = (query.isEmpty)?peliculasRecientes
                                          :peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();
    return ListView.builder(
      itemCount: listaSugerida.length,
      itemBuilder: (BuildContext context, int index){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listaSugerida[index]),
          onTap: (){
            seleccion = listaSugerida[index];
            //metodo que permite mostrar el resultado
            showResults(context);
          },
        );
      },
    );*/

    if(query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if(snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula){
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(pelicula.getPosterImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, 'detalle',arguments: pelicula);
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}