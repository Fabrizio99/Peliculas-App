import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  //_pageController es el controlador del pageview widget
  final _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  MovieHorizontal(
    {
      @required
      this.peliculas,
      @required
      this.siguientePagina
    }
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    // se dispara cada vez que se muestra el scroll del pageview widget
    _pageController.addListener(() {
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        print('llego al final de la lista');
        this.siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height*0.25,
      /*child: PageView(
        pageSnapping: false,
        controller: _pageController,
        children: _tarjetas(context),
      ),*/
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: peliculas.length,
        itemBuilder: (BuildContext context, int i)=>_tarjeta(context, peliculas[i])
      ),
    );
  }

  Widget _tarjeta(BuildContext context,Pelicula pelicula){
    pelicula.uniqueId = '${pelicula.id}-poster';
    final tarjeta = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(
        children: [
            Hero(
              //el tag tiene que ser un id único que sirve para identificar la tarjeta y tiene que tener el mismo
              // id a donde va a llegar
              tag: pelicula.uniqueId,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: FadeInImage(
                placeholder: AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(pelicula.getPosterImg()),
                fit: BoxFit.cover,
                height: 130.0
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ],
      )
    );

    return GestureDetector(
      child: tarjeta,
      onTap: (){
        print('ID de la tarjeta ${pelicula.id}');
        //se puede pasar datos a otra vista por medio de la propiedad arguments de Navigator.pushNamed
        Navigator.pushNamed(context, 'detalle',arguments: pelicula);
      },
    );
  }

}