import 'package:flutter/material.dart';

class ImagenJuego extends StatelessWidget {
  final String juego;
  final String? urlImagen;
  final bool animarImagen;
  final double tamanio;

  const ImagenJuego({super.key, required this.juego, this.animarImagen = true, this.tamanio = 170, this.urlImagen});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: urlImagen != null,
          replacement: Align(alignment: AlignmentDirectional.center, child: Text(juego)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              urlImagen.toString(),
              height: tamanio,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress != null) {
                  return const Center(
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                      ],
                    ),
                  );
                }
          
                //if (animarImagen) return ZoomIn(child: child);
                return child;
              },
            ),
          ),
        ));
  }
}
