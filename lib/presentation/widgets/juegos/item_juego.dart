import 'package:flutter/material.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CardJuego extends StatelessWidget {
  final JuegoDto juego;
  final Function? accion;
  final bool animarImagen;
  const CardJuego({super.key, required this.juego, this.accion, this.animarImagen = true});

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    if (accion != null) {
      return GestureDetector(
        onTap: () => accion!(),
        child: _ItemJuego(
          color: color,
          juego: juego,
          textstyle: textstyle,
          animarImagen: animarImagen,
        ),
      );
    } else {
      return _ItemJuego(
        color: color,
        juego: juego,
        textstyle: textstyle,
        animarImagen: animarImagen,
      );
    }
  }
}

class _ItemJuego extends StatelessWidget {
  const _ItemJuego({
    required this.color,
    required this.juego,
    required this.textstyle,
    required this.animarImagen,
  });

  final ColorScheme color;
  final JuegoDto juego;
  final TextTheme textstyle;
  final bool animarImagen;

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: Hero(
            tag: juego.nombre + (juego.subtitulo == null ? juego.subtitulo.toString() : juego.id.toString()),
            child: ImagenJuego(
              juego: juego.nombre,
              urlImagen: juego.urlImagen,
            ),
          ),
        ));
  }
}
