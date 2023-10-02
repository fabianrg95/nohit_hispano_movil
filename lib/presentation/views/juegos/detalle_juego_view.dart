import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/presentation/delegates/juegos/cabecera_juego_delegate.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

late ColorScheme colors;
late TextTheme textStyle;
late Size size;

class DetalleJuego extends StatelessWidget {
  final JuegoDto juego;

  const DetalleJuego({super.key, required this.juego});

  final double tamanioImagen = 150;

  @override
  Widget build(BuildContext context) {
    colors = Theme.of(context).colorScheme;
    textStyle = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(delegate: CustomSliverAppBarDelegate(juego: juego, expandedHeight: size.height * 0.35), pinned: true),
            SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
              return SingleChildScrollView(
                child: Column(children: [
                  _subtitulo(),
                ]),
              );
            }, childCount: 1))
          ],
        ),
      ),
    );
  }

  Visibility _subtitulo() {
    return Visibility(
        visible: juego.subtitulo != null,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
          child: Center(child: Text(juego.subtitulo.toString(), style: textStyle.titleMedium)),
        ));
  }
}
