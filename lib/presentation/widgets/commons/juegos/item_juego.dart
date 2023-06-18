import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class CardJuego extends StatelessWidget {
  final Juego juego;
  final Function accion;

  const CardJuego({
    super.key,
    required this.juego,
    required this.accion,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textstyle = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => accion(),
      child: Container(
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                    color: Colors.black38,
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 0))
              ], // Desplazamiento de la sombra en eje x, y
              color: color.secondary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.tertiary)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImagenJuego(
                juego: juego,
                existeUrl: juego.urlImagen != null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: size.width * 0.55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        juego.nombre,
                        style: textstyle.titleMedium
                            ?.copyWith(color: color.surface),
                      ),
                      Visibility(
                        visible: juego.subtitulo != null,
                        child: Text(
                          juego.subtitulo != null ? juego.subtitulo! : '',
                          style: textstyle.bodySmall
                              ?.copyWith(color: color.surface),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
