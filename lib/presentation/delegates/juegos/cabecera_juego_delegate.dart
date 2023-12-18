import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final JuegoDto? juego;
  final String heroTag;

  const CustomSliverAppBarDelegate({required this.juego, required this.expandedHeight, required this.heroTag});

  @override
  Widget build(final BuildContext context, final double shrinkOffset, final bool overlapsContent) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final Size size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.passthrough,
      children: [
        buildJuegoImage(shrinkOffset, heroTag, color, size),
        buildAppBar(shrinkOffset, color),
      ],
    );
  }

  double appear(final double shrinkOffset) {
    if (shrinkOffset / expandedHeight < 0.99) return 0;
    return (shrinkOffset / expandedHeight);
  }

  double desappear(final double shrinkOffset) {
    if (shrinkOffset / expandedHeight < 0.99) return 1;
    return 1 - shrinkOffset / expandedHeight;
  }

  double radius(final double shrinkOffset) {
    return -180 * (shrinkOffset / expandedHeight) + 200;
  }

  Widget buildAppBar(final double shrinkOffset, final ColorScheme color) => Opacity(
      opacity: appear(shrinkOffset),
      child: OverflowBar(
        children: [AppBar(title: Text(juego != null ? juego!.nombre : ""), surfaceTintColor: color.tertiary)],
      ));

  Widget buildJuegoImage(double shrinkOffset, final String heroTag, final ColorScheme color, final Size size) {
    return Opacity(
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
              tag: heroTag,
              child: ImagenJuego(
                juego: juego != null ? juego!.nombre : "",
                urlImagen: juego != null ? juego!.urlImagen : "",
                animarImagen: false,
                tamanio: 250,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Icon(Icons.arrow_back, color: color.surfaceTint),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight - 1;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
