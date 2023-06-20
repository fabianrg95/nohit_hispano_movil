import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';

class DetalleJuego extends StatelessWidget {
  final Juego juego;

  const DetalleJuego({super.key, required this.juego});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).colorScheme.tertiary;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: colors.tertiary,
              expandedHeight: size.height * 0.5,
              foregroundColor: colors.tertiary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(bottom: 0),
                title: _CustomGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.7, 1.0],
                    colors: [Colors.transparent, scaffoldBackgroundColor]),
                background: Stack(children: [
                  SizedBox.expand(
                    child: juego.urlImagen != null
                        ? Image.network(juego.urlImagen!, fit: BoxFit.cover)
                        : Image.asset('assets/images/no-game-image.webp',
                            fit: BoxFit.cover),
                  ),
                  const _CustomGradient(begin: Alignment.topLeft, stops: [
                    0.0,
                    0.3
                  ], colors: [
                    Colors.black87,
                    Colors.transparent,
                  ])
                ]),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: Center(
                      child: Text(juego.nombre,
                          textAlign: TextAlign.center,
                          style: textStyle.titleLarge!
                              .copyWith(color: colors.primary)),
                    ),
                  ),
                  Container(
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
                      child: Column(
                        children: [
                          Visibility(
                              visible: juego.subtitulo != null,
                              child: Text(juego.subtitulo.toString()))
                        ],
                      ))
                ],
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final List<double> stops;
  final List<Color> colors;

  const _CustomGradient(
      {this.begin = Alignment.centerLeft,
      this.end = Alignment.centerRight,
      required this.stops,
      required this.colors});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: begin, end: end, stops: stops, colors: colors))),
    );
  }
}
