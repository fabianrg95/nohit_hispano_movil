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
                    textStyle: textStyle,
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
  final TextTheme textStyle;

  const _CustomSliverAppBarDelegate(
      {required this.juego,
      required this.colors,
      required this.size,
      required this.textStyle,
      required this.expandedHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
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
        children: [
          AppBar(
            title: Text(juego.nombre),
            surfaceTintColor: colors.tertiary,
          ),
          Visibility(
              visible: juego.subtitulo != null,
              child: Align(
                alignment: AlignmentDirectional.topCenter,
                child: Container(
                    width: size.width * 0.85,
                    margin: const EdgeInsets.only(left: 5, right: 5),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: colors.tertiary),
                        color: colors.secondary,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 0))
                        ]),
                    child: Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: Text(juego.subtitulo.toString(),
                          style: textStyle.bodyMedium
                              ?.copyWith(color: colors.tertiary)),
                    )),
              ))
        ],
      ));

  Widget buildJuegoImage(double shrinkOffset) => Opacity(
        opacity: desappear(shrinkOffset),
        child: Stack(
          children: [
            Container(
                height: 200,
                width: size.width,
                decoration: BoxDecoration(
                    color: colors.tertiary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(radius(shrinkOffset)),
                    ))),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Hero(
                tag: juego.nombre +
                    (juego.subtitulo == null
                        ? juego.subtitulo.toString()
                        : juego.id.toString()),
                child: ImagenJuego(
                  juego: juego,
                  existeUrl: juego.urlImagen != null,
                  animarImagen: false,
                  tamanio: 250,
                ),
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
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight - 1;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
