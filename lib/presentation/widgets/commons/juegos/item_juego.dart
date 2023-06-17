import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';

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
            borderRadius: BorderRadius.circular(20), border: Border.all(color: color.tertiary)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _ImagenJuego(
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
                            ?.copyWith(color: color.tertiary),
                      ),
                      Visibility(
                        visible: juego.subtitulo != null,
                        child: Text(
                          juego.subtitulo != null ? juego.subtitulo! : '',
                          style: textstyle.bodySmall
                              ?.copyWith(color: color.tertiary),
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

class _ImagenJuego extends StatelessWidget {
  final Juego juego;
  final bool existeUrl;

  const _ImagenJuego({
    required this.juego,
    this.existeUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 0))
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
                width: 70,
                height: 90,
                child: existeUrl
                    ? Image.network(
                        juego.urlImagen!,
                        fit: BoxFit.fill,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress != null) {
                            return Center(
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(),
                                  Text(juego.nombre)
                                ],
                              ),
                            );
                          }

                          return child;
                        },
                      )
                    : Image.asset('assets/images/no-game-image.webp',
                        fit: BoxFit.cover))),
      ),
    );
  }
}
