import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CardJuego extends StatelessWidget {
  final JuegoDto juego;
  final Function? accion;
  final bool animarImagen;
  final double tamanio;
  const CardJuego({super.key, required this.juego, this.accion, this.animarImagen = true, this.tamanio = 270});

  @override
  Widget build(BuildContext context) {
    if (accion != null) {
      return GestureDetector(
        onTap: () => accion!(),
        child: _ItemJuegoGrilla(juego: juego, animarImagen: animarImagen, tamanio: tamanio),
      );
    } else {
      return _ItemJuegoGrilla(juego: juego, animarImagen: animarImagen, tamanio: tamanio);
    }
  }
}

class _ItemJuegoGrilla extends StatelessWidget {
  const _ItemJuegoGrilla({required this.juego, required this.animarImagen, required this.tamanio});

  final JuegoDto juego;
  final bool animarImagen;
  final double tamanio;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'Juego-${juego.id}',
        child: ImagenJuego(
          juego: juego.nombre,
          urlImagen: juego.urlImagen,
          tamanio: tamanio,
        ),
      ),
    );
  }
}
