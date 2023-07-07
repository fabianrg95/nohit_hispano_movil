import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CardJuego extends StatelessWidget {
  final Juego juego;
  final Function accion;

  const CardJuego({super.key, required this.juego, required this.accion});

  @override
  Widget build(BuildContext context) {
    final textstyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => accion(),
      child: _ItemJuego(color: color, juego: juego, textstyle: textstyle),
    );
  }
}

class _ItemJuego extends StatelessWidget {
  const _ItemJuego({
    required this.color,
    required this.juego,
    required this.textstyle,
  });

  final ColorScheme color;
  final Juego juego;
  final TextTheme textstyle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final color = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.center,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, -0.01) // Perspectiva 3D
              ..rotateX(0.25),
            alignment: FractionalOffset.center, // Rotación en el eje X,
            child: Container(
                decoration: BoxDecoration(
                  color: color.secondary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: color.tertiary,
                        spreadRadius: 0,
                        blurRadius: 6,
                        offset: const Offset(0, 3))
                  ],
                ),
                margin: const EdgeInsets.only(top: 40),
                child: SizedBox(
                  width: size.width * 0.39,
                  height: 110,
                )),
          ),
        ),
        Align(
          alignment: AlignmentDirectional.topCenter,
          child: ImagenJuego(
            juego: juego,
            existeUrl: juego.urlImagen != null,
          ),
        )
      ],
    );
  }
}
