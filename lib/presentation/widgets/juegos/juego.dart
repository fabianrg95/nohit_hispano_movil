import 'package:flutter/material.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class JuegoCommons {
  Widget subtitulo(final JuegoDto juego, final Function? redireccion) {
    return GestureDetector(
        onTap: () => redireccion != null ? redireccion() : null,
        child: Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 25, right: 25),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: ViewData().decorationContainerBasic(),
          child: Column(children: [
            Text(juego.nombre.toString(), style: styleTexto.titleLarge),
            if (juego.subtitulo != null) Text(juego.subtitulo.toString(), style: styleTexto.titleSmall)
          ]),
        ));
  }
}
