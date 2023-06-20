import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/utils/informacion_jugador_utils.dart';
import 'package:no_hit/infraestructure/utils/nacionalidad_utils.dart';
import 'package:no_hit/presentation/providers/providers.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleJugadorView extends ConsumerStatefulWidget {
  final int idJugador;

  const DetalleJugadorView({super.key, required this.idJugador});

  @override
  DetalleJugadorState createState() => DetalleJugadorState();
}

class DetalleJugadorState extends ConsumerState<DetalleJugadorView> {
  @override
  void initState() {
    super.initState();
    ref.read(detalleJugadorProvider.notifier).loadData(widget.idJugador);
  }

  @override
  Widget build(BuildContext context) {
    final DetalleJugador? jugador = ref.watch(detalleJugadorProvider);
    final color = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica();
    }

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          title: Text(jugador.nombre),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: BanderaJugador(codigoBandera: jugador.codigoBandera),
            )
          ]),
      body: Column(
        children: [
          Container(
              width: size.width * 0.85,
              margin: const EdgeInsets.only(left: 5, right: 5),
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: color.tertiary),
                  color: color.secondary,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 0))
                  ]),
              child: InformacionJugadorUtils.validarInformacionJugador(jugador)
                  ? Column(
                      children: [
                        Visibility(
                            visible: jugador.pronombre != null,
                            child: Text(jugador.pronombre.toString())),
                        Visibility(
                            visible:
                                jugador.genero != null && jugador.pais != null,
                            child: Text(Nacionalidad.obtenerGentilicioJugador(
                                jugador))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Visibility(
                              visible: jugador.urlYoutube != null,
                              child: GestureDetector(
                                onTap: () =>
                                    _lanzarUrl(jugador.urlYoutube.toString()),
                                child: Image.asset(
                                  'assets/images/youtube.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Visibility(
                                visible: jugador.urlYoutube != null &&
                                    jugador.urlTwitch != null,
                                child: VerticalDivider(
                                  color: color.tertiary,
                                )),
                            Visibility(
                                visible: jugador.urlTwitch != null,
                                child: GestureDetector(
                                  onTap: () =>
                                      _lanzarUrl(jugador.urlTwitch.toString()),
                                  child: Image.asset(
                                    'assets/images/twitch.png',
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ))
                          ],
                        )
                      ],
                    )
                  : const Center(child: Text('Jugador sin informacion'))),
          _ListaPartidasJugador(jugador: jugador),
        ],
      ),
    );
  }

  Future<void> _lanzarUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('no puede ser lanzada la url $url');
    }
  }
}

class _ListaPartidasJugador extends StatelessWidget {
  const _ListaPartidasJugador({
    required this.jugador,
  });

  final DetalleJugador? jugador;

  @override
  Widget build(BuildContext context) {
    return _InformacionPartidasJugador(jugador: jugador);
  }
}

class _InformacionPartidasJugador extends StatelessWidget {
  const _InformacionPartidasJugador({
    required this.jugador,
  });

  final DetalleJugador? jugador;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Container(
      height: 265,
      margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: color.tertiary),
          color: color.secondary,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12,
                spreadRadius: 0,
                blurRadius: 5,
                offset: Offset(0, 0))
          ]),
      child: Column(
        children: [
          Text('Partidas NoHit',
              style: textStyle.titleMedium?.copyWith(color: color.surface)),
          Divider(color: color.tertiary),
          SizedBox(
            height: 200,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: jugador!.partidas.length,
              itemBuilder: (BuildContext context, int index) {
                Partidas partida = jugador!.partidas[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _TarjetaPartidaJuegoJugador(partida: partida),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TarjetaPartidaJuegoJugador extends StatelessWidget {
  final Partidas partida;

  const _TarjetaPartidaJuegoJugador({required this.partida});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return SizedBox(
      width: 170,
      child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: color.tertiary)),
          color: color.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImagenJuego(
                  juego: partida.juego,
                  existeUrl: partida.juego.urlImagen != null),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(partida.juego.nombre,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style:
                        textStyle.bodyMedium?.copyWith(color: color.surface)),
              ),
              Visibility(
                visible: partida.juego.subtitulo != null,
                child: Text(partida.juego.subtitulo.toString(),
                    textAlign: TextAlign.center,
                    style:
                        textStyle.labelSmall?.copyWith(color: color.surface)),
              ),
              const Expanded(child: Text('')),
              Text(
                  '${partida.partidas.length} partida${partida.partidas.length > 1 ? 's' : ''}',
                  style: textStyle.labelSmall?.copyWith(color: color.surface))
            ],
          )),
    );
  }
}
