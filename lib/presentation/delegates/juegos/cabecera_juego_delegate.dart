import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';

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

  Widget buildAppBar(final double shrinkOffset, final ColorScheme color) => AppBar(
        forceMaterialTransparency: true,
      );

  Widget buildJuegoImage(double shrinkOffset, final String heroTag, final ColorScheme color, final Size size) {
    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Hero(
              tag: heroTag,
              child: Image.network(
                juego!.urlImagen.toString(),
                height: size.height * 0.70,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return const Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                        ],
                      ),
                    );
                  }

                  //if (animarImagen) return ZoomIn(child: child);
                  return child;
                },
              )),
        ),
      ],
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight - 1;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
