import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class DetalleJuego extends StatelessWidget {
  final Juego juego;

  const DetalleJuego({super.key, required this.juego});

  final double tamanioImagen = 150;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
                delegate: _CustomSliverAppBarDelegate(
                    juego: juego,
                    expandedHeight: size.height * 0.35,
                    colors: colors,
                    size: size),
                pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return SingleChildScrollView(
                child: Column(children: [
                  Container(
                      width: size.width,
                      height: size.height,
                      decoration: BoxDecoration(
                        color: colors.secondary,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(50)),
                      ),
                      child: Visibility(
                          visible: juego.subtitulo != null,
                          child: Align(
                            alignment: AlignmentDirectional.topCenter,
                            child: Text(juego.subtitulo.toString(),
                                style: textStyle.titleMedium
                                    ?.copyWith(color: colors.tertiary)),
                          ))),
                ]),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }
}

class _CustomSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Juego juego;
  final ColorScheme colors;
  final Size size;

  const _CustomSliverAppBarDelegate(
      {required this.juego,
      required this.colors,
      required this.size,
      required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [buildJuegoImage(shrinkOffset), buildAppBar(shrinkOffset)],
    );
  }

  double appear(double shrinkOffset) {
    if (shrinkOffset / expandedHeight < 0.9) return 0;
    return shrinkOffset / expandedHeight;
  }

  Widget buildAppBar(double shrinkOffset) => Opacity(
      opacity: appear(shrinkOffset), child: AppBar(title: Text(juego.nombre), backgroundColor: colors.tertiary, ));

  Widget buildJuegoImage(double shrinkOffset) => Stack(
        children: [
          Container(
              height: 200,
              width: size.width,
              decoration: BoxDecoration(
                  color: colors.tertiary,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(500),
                  ))),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: ImagenJuego(
              juego: juego,
              existeUrl: juego.urlImagen != null,
              animarImagen: false,
              tamanio: 250,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Icon(
              Icons.arrow_back,
              color: colors.surfaceTint,
            ),
          ),
        ],
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
