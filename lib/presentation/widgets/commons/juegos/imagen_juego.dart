import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:simple_shadow/simple_shadow.dart';

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
    final colors = Theme.of(context).colorScheme;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Visibility(
          visible: existeUrl,
          child: SimpleShadow(
              opacity: 0.6, // Default: 0.5
              color: colors.tertiary, // Default: Black
              offset: const Offset(5, 5), // Default: Offset(2, 2)
              sigma: 7,
              child: Image.network(
                juego.urlImagen.toString(),
                height: 170,
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

                  return ZoomIn(child: child);
                },
              ) // Default: 2
              ),
        ));
  }
}
