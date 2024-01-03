import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/juegos/informacion_juego_provider.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaPartidas extends ConsumerWidget {
  final PartidaDto? primeraPartida;
  final PartidaDto? ultimaPartida;
  final List<PartidaDto>? listaPartidas;
  final String heroTag;

  const ListaPartidas({super.key, this.primeraPartida, this.ultimaPartida, required this.heroTag, required this.listaPartidas});

  @override
  Widget build(BuildContext context, ref) {
    final ColorScheme color = Theme.of(context).colorScheme;

    if (primeraPartida == null && ultimaPartida == null) {
      return const Center(child: Text('El juego no cuenta con partidas registradas'));
    }

    final TextTheme styleTexto = Theme.of(context).textTheme;

    return SafeArea(
      child: SizedBox(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: ViewData().decorationContainerBasic(color: color),
              child: IntrinsicHeight(
                child: Column(children: [
                  ViewData().muestraInformacionAccion(
                      alineacion: CrossAxisAlignment.start,
                      items: [
                        Text(primeraPartida!.nombreJugador.toString(), style: styleTexto.titleMedium),
                        Text(primeraPartida!.nombre.toString(), style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                        Text(primeraPartida!.fecha.toString(), style: styleTexto.bodySmall),
                        Text(
                          'Primera ${primeraPartida!.id == ultimaPartida!.id ? 'y unica ' : ''}partida',
                          style: styleTexto.bodyLarge?.copyWith(color: color.outline),
                        )
                      ],
                      accion: () => navegarPartida(context, ref, primeraPartida!)),
                  Visibility(
                    visible: primeraPartida!.id != ultimaPartida!.id,
                    child: Divider(color: color.tertiary, thickness: 2, height: 1),
                  ),
                  Visibility(
                      visible: primeraPartida!.id != ultimaPartida!.id,
                      child: ViewData().muestraInformacionAccion(
                          alineacion: CrossAxisAlignment.end,
                          items: [
                            Text(ultimaPartida!.nombreJugador.toString(), style: styleTexto.titleMedium),
                            Text(ultimaPartida!.nombre.toString(), style: styleTexto.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(ultimaPartida!.fecha.toString(), style: styleTexto.bodySmall),
                            Text('Ultima partida', style: styleTexto.bodyLarge?.copyWith(color: color.outline))
                          ],
                          accion: () => navegarPartida(context, ref, ultimaPartida!)))
                ]),
              ),
            ),
            const SizedBox(height: 10),
            if (listaPartidas!.length > 2) Expanded(child: _listaPartidas(listaPartidas, styleTexto, ref))
          ],
        ),
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
              heroTag: heroTag,
              idJuego: partida.idJuego,
              nombreJuego: partida.tituloJuego.toString()));
    }));
  }

  Widget _listaPartidas(final List<PartidaDto>? listaPartidas, TextTheme styleTexto, WidgetRef ref) {
    if (listaPartidas!.isEmpty) {
      return const Center(
        child: Text("El juego no posee partidas."),
      );
    }

    return ListView.builder(
      itemCount: listaPartidas.length,
      itemBuilder: (BuildContext context, int index) {
        PartidaDto partida = listaPartidas[index];
        return PartidaCommons().tarjetaPartidaJuegoJugador(partida: partida, context: context, mostrarJugador: true, ref: ref);
      },
    );
  }
}
