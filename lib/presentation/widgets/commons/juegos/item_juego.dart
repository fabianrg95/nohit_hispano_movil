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

    return Stack(
      children: [
        Align(
          alignment: AlignmentDirectional.center,
          child: Card(
              margin: const EdgeInsets.only(top: 40),
              child: SizedBox(
                width: size.width * 0.39,
                height: 160,
              )),
        ),
        Column(
          children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: ImagenJuego(
                juego: juego,
                existeUrl: juego.urlImagen != null,
              ),
            ),
            SizedBox(
              width: size.width * 0.35,
              child: Text(
                juego.nombre,
                style: textstyle.titleSmall?.copyWith(color: color.primary),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            Visibility(
                visible: juego.subtitulo != null,
                child: Text(
                  juego.subtitulo != null ? juego.subtitulo! : '',
                  style: textstyle.bodySmall?.copyWith(color: color.primary),
                )),
          ],
        )
      ],
    );
    // Row(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     ImagenJuego(
    //       juego: juego,
    //       existeUrl: juego.urlImagen != null,
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.only(top: 10),
    //       child: SizedBox(
    //         //width: size.width * 0.55,
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           children: [
    //             Text(
    //               juego.nombre,
    //               style:
    //                   textstyle.titleMedium?.copyWith(color: color.surface),
    //             ),
    //             Visibility(
    //               visible: juego.subtitulo != null,
    //               child: Text(
    //                 juego.subtitulo != null ? juego.subtitulo! : '',
    //                 style:
    //                     textstyle.bodySmall?.copyWith(color: color.surface),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     )
    //   ],
    // )
  }
}
