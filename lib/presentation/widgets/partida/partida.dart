import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/juegos/informacion_juego_provider.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PartidaCommons {
  Widget tarjetaPartidaJuegoJugador(
      {required PartidaDto partida, required BuildContext context, required WidgetRef ref, bool mostrarJugador = false}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: GestureDetector(
        onTap: () => navegarPartida(context, ref, partida),
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
    );
  }

  Future<dynamic> navegarPartida(BuildContext context, WidgetRef ref, PartidaDto partida) {
    ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: partida.getJuegoDto());
    return Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return FadeTransition(
          opacity: animation,
          child: DetallePartidaView(
              partidaId: partida.id,
              jugadorId: partida.idJugador,
              heroTag: partida.id.toString(),
              idJuego: partida.idJuego,
              nombreJuego: partida.tituloJuego.toString()));
    }));
  }
}
