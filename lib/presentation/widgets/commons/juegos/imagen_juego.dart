import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';

class ImagenJuego extends StatelessWidget {
  final Juego juego;
  final bool existeUrl;

  const ImagenJuego({
    super.key,
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
