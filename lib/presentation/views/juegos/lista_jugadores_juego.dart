import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/presentation/views/views.dart';

import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class ListaJugadoresJuego extends ConsumerWidget {
  final List<JugadorDto>? listaJugadores;
  final PartidaDto? primeraPartida;
  final PartidaDto? ultimaPartida;

  const ListaJugadoresJuego({super.key, required this.listaJugadores, required this.primeraPartida, required this.ultimaPartida});

  @override
  Widget build(BuildContext context, ref) {
    if (listaJugadores == null || listaJugadores!.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.juego_sin_jugadores));
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            primerUltimoJugador(primeraPartida: primeraPartida!, ultimaPartida: ultimaPartida!, context: context, ref: ref),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: listaJugadores!.length,
                itemBuilder: (BuildContext context, int index) => ItemJugador(jugador: listaJugadores![index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget primerUltimoJugador(
      {required PartidaDto primeraPartida, required PartidaDto ultimaPartida, required BuildContext context, required WidgetRef ref}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: IntrinsicHeight(
        child: Column(children: [
          ViewData().muestraInformacionAccion(
              alineacion: CrossAxisAlignment.start,
              items: [
                Text(primeraPartida.nombreJugador.toString(), style: styleTexto.titleMedium),
                Text(primeraPartida.fecha.toString(), style: styleTexto.bodySmall),
                Text(
                  AppLocalizations.of(context)!.primera_partida((primeraPartida.id == ultimaPartida.id).toString()),
                  style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                )
              ],
              accion: () => navegarJugador(context, primeraPartida.idJugador)),
          Visibility(
            visible: primeraPartida.id != ultimaPartida.id,
            child: Divider(color: color.tertiary, thickness: 2, height: 1),
          ),
          Visibility(
              visible: primeraPartida.id != ultimaPartida.id,
              child: ViewData().muestraInformacionAccion(
                  alineacion: CrossAxisAlignment.end,
                  items: [
                    Text(ultimaPartida.nombreJugador.toString(), style: styleTexto.titleMedium),
                    Text(ultimaPartida.fecha.toString(), style: styleTexto.bodySmall),
                    Text(AppLocalizations.of(context)!.ultimo_jugador, style: styleTexto.bodyLarge?.copyWith(color: color.outline))
                  ],
                  accion: () => navegarJugador(context, ultimaPartida.idJugador)))
        ]),
      ),
    );
  }

  void navegarJugador(BuildContext context, int jugadorId) {
    Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: jugadorId));
    }));
  }
}
