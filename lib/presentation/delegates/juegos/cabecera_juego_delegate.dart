import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final JuegoDto juego;

  const CustomSliverAppBarDelegate({required this.juego, required this.expandedHeight});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return Stack(
      fit: StackFit.passthrough,
      children: [
        buildJuegoImage(shrinkOffset),
        buildAppBar(shrinkOffset),
      ],
    );
  }

  double appear(double shrinkOffset) {
    if (shrinkOffset / expandedHeight < 0.99) return 0;
    return (shrinkOffset / expandedHeight);
  }

  double desappear(double shrinkOffset) {
    if (shrinkOffset / expandedHeight < 0.99) return 1;
    return 1 - shrinkOffset / expandedHeight;
  }

  double radius(double shrinkOffset) {
    return -180 * (shrinkOffset / expandedHeight) + 200;
  }

  Widget buildAppBar(double shrinkOffset) => Opacity(
      opacity: appear(shrinkOffset),
      child: OverflowBar(
        children: [AppBar(title: Text(juego.nombre), surfaceTintColor: color.tertiary)],
      ));

  Widget buildJuegoImage(double shrinkOffset) => Opacity(
        opacity: desappear(shrinkOffset),
        child: Stack(
          children: [
            Container(
                height: 200,
                width: size.width,
                decoration: BoxDecoration(
                    color: color.tertiary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(radius(shrinkOffset)),
                    ))),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Hero(
                tag: juego.nombre + (juego.subtitulo == null ? juego.subtitulo.toString() : juego.id.toString()),
                child: ImagenJuego(
                  juego: juego.nombre,
                  urlImagen: juego.urlImagen,
                  animarImagen: false,
                  tamanio: 250,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Icon(
                Icons.arrow_back,
                color: color.surfaceTint,
              ),
            ),
          ],
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight - 1;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
