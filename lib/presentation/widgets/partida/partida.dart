import 'dart:math';

import 'package:flutter/material.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PartidaCommons {
  Widget tarjetaPartidaJuegoJugador(
      {required PartidaDto partida, required BuildContext context, required bool partidaUnica, bool mostrarJugador = false}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      child: Transform.rotate(
        angle: partidaUnica ? 0 : -0.02 + Random().nextDouble() * (0.02 - -0.02),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
            return FadeTransition(
                opacity: animation,
                child: DetallePartidaView(
                    partidaId: partida.id,
                    jugadorId: partida.idJugador,
                    heroTag: partida.id.toString(),
                    idJuego: partida.idJuego,
                    nombreJuego: partida.tituloJuego.toString(),
                    urlImagenJuego: partida.urlImagenJuego.toString()));
          })),
          child: Container(
              decoration: ViewData().decorationContainerBasic(color: color),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(HumanFormat.fechaMes(partida.fecha.toString())),
                        Text(HumanFormat.fechaDia(partida.fecha.toString())),
                        Text(HumanFormat.fechaAnio(partida.fecha.toString()))
                      ],
                    ),
                  ),
                  if (!mostrarJugador) const SizedBox(width: 10),
                  Expanded(
                    child: Center(
                      child: Column(children: [
                        if (mostrarJugador)
                          Center(child: Text(partida.nombreJugador.toString(), style: styleTexto.titleMedium, textAlign: TextAlign.center)),
                        Center(
                          child: Text(partida.nombre.toString(),
                              style: mostrarJugador ? styleTexto.labelSmall : styleTexto.labelMedium,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                        )
                      ]),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
