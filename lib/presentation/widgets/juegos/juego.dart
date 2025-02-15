import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class JuegoCommons {
  Widget subtitulo(final JuegoDto juego, final Function? redireccion, final BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;
    final Size size = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () => redireccion != null ? redireccion() : null,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: ViewData().decorationContainerBasic(color: color),
          child: Column(children: [
            Text(
              juego.nombre.toString(),
              style: TextStyle(color: Colors.white, fontSize: size.width * 0.05),
              textAlign: TextAlign.center,
            ),
            if (juego.subtitulo != null)
              Text(
                juego.subtitulo.toString(),
                style: styleTexto.titleSmall,
                textAlign: TextAlign.center,
              )
          ]),
        ));
  }
}
