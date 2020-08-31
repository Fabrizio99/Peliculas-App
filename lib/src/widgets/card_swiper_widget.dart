import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;
  CardSwiper({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //width: double.infinity,   //le indica que use todo el ancho posible
      //width: _screenSize.width * 0.7,
      //height: 300,
      //height: _screenSize.height * 0.5,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          peliculas[index].uniqueId = '${peliculas[index].id}-tarjeta';
          return Hero(
            tag: peliculas[index].uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: GestureDetector(
                child: FadeInImage(
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  image: NetworkImage(peliculas[index].getPosterImg()),
                  fit: BoxFit.cover,
                ),
                onTap: (){
                  Navigator.pushNamed(context, 'detalle',arguments: peliculas[index]);
                },
              )
            )
          );
        },
        itemCount: peliculas.length,
        itemWidth: _screenSize.width * 0.6,
        itemHeight: _screenSize.height * 0.50,
        layout: SwiperLayout.STACK,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}