import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

late ColorScheme color;
late TextTheme styleTexto;
late Size size;

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
    final JugadorDto? jugador = ref.watch(detalleJugadorProvider);

    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica(texto: "Consultando la informacion del jugador");
    }

    return SafeArea(
      child: Scaffold(
        appBar: _cabecera(jugador),
        body: _contenido(jugador),
      ),
    );
  }
}

AppBar _cabecera(final JugadorDto jugador) {
  return AppBar(
      title: Text(jugador.nombre!),
      centerTitle: true,
      actions: [Padding(padding: const EdgeInsets.only(right: 5), child: BanderaJugador(codigoBandera: jugador.codigoBandera))]);
}

Widget _contenido(final JugadorDto jugador) {
  return ListView(
    children: [
      Container(
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: false, topRight: false),
        child: _informacionJugador(jugador),
      ),
      _resumenPartidas(jugador: jugador),
      _Partidas(jugador: jugador)
    ],
  );
}

Widget _informacionJugador(JugadorDto jugador) {
  return Visibility(
      visible: jugador.mostrarInformacion,
      replacement: const Center(child: Text('Jugador sin informacion')),
      child: Column(
        children: [
          Visibility(visible: jugador.pronombre != null, child: Text(jugador.pronombre.toString())),
          Visibility(visible: jugador.gentilicio != null, child: Text(jugador.gentilicio.toString())),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _link(jugador.urlYoutube, 'assets/images/youtube.png'),
            Visibility(
                visible: jugador.urlYoutube != null && jugador.urlTwitch != null,
                child: VerticalDivider(
                  color: color.tertiary,
                )),
            _link(jugador.urlTwitch, 'assets/images/twitch.png')
          ])
        ],
      ));
}

Visibility _link(final String? url, final String urlImagen) {
  return Visibility(
    visible: url != null,
    child: GestureDetector(
      onTap: () => _lanzarUrl(url.toString()),
      child: Image.asset(urlImagen, width: 30, height: 30),
    ),
  );
}

Future<void> _lanzarUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('no puede ser lanzada la url $url');
  }
}

Widget _resumenPartidas({required JugadorDto jugador}) {
  return IntrinsicHeight(
    child: Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: true, topRight: true),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              children: [
                _muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  Text(jugador.juegos.length.toString(), style: styleTexto.titleLarge),
                  Text('Juego${jugador.juegos.length != 1 ? 's' : ''}')
                ]),
                VerticalDivider(color: color.tertiary, thickness: 2, indent: 0),
                _muestraInformacion(alineacion: CrossAxisAlignment.center, items: [
                  Text(jugador.cantidadPartidas.toString(), style: styleTexto.titleLarge),
                  Text('Partida${jugador.cantidadPartidas != 1 ? 's' : ''}')
                ])
              ],
            ),
          ),
          Divider(color: color.tertiary, thickness: 2, height: 1),
          _muestraInformacion(alineacion: CrossAxisAlignment.start, items: [
            Text('${jugador.primeraPartida!.tituloJuego.toString()} ${jugador.primeraPartida!.subtituloJuego ?? ''}', style: styleTexto.bodyMedium),
            Text(jugador.primeraPartida!.nombre.toString(),
                style: styleTexto.bodySmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(jugador.primeraPartida!.fecha.toString(), style: styleTexto.bodySmall),
            Text(
              'Primera ${jugador.primeraPartida!.id == jugador.ultimaPartida!.id ? 'y unica' : ''} partida',
              style: styleTexto.bodyLarge?.copyWith(color: AppTheme.textoResaltado),
            )
          ]),
          Visibility(
            visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
            child: Divider(color: color.tertiary, thickness: 2, height: 1),
          ),
          Visibility(
              visible: jugador.primeraPartida!.id != jugador.ultimaPartida!.id,
              child: _muestraInformacion(alineacion: CrossAxisAlignment.end, items: [
                Text('${jugador.ultimaPartida!.tituloJuego.toString()} ${jugador.ultimaPartida!.subtituloJuego ?? ''}', style: styleTexto.bodyMedium),
                Text(jugador.ultimaPartida!.nombre.toString(),
                    style: styleTexto.bodySmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(jugador.ultimaPartida!.fecha.toString(), style: styleTexto.bodySmall),
                Text('Ultima partida', style: styleTexto.bodyLarge?.copyWith(color: AppTheme.textoResaltado))
              ]))
        ],
      ),
    ),
  );
}

Widget _muestraInformacion({required List<Widget> items, required CrossAxisAlignment alineacion}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      child: Row(children: [Expanded(child: Column(crossAxisAlignment: alineacion, children: items))]),
    ),
  );
}

Widget _informacionPartidasJugador({required List<PartidaDto> partidas}) {
  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: partidas.isEmpty ? 0 : partidas.length,
    itemBuilder: (BuildContext context, int index) {
      PartidaDto partida = partidas[index];
      final bool par = index.isOdd;
      return _tarjetaPartidaJuegoJugador(partida: partida, par: par);
    },
  );
}

class _Partidas extends StatefulWidget {
  final JugadorDto jugador;

  const _Partidas({required this.jugador});

  @override
  State<_Partidas> createState() => _PartidasState();
}

class _PartidasState extends State<_Partidas> {
  late List<PartidaDto> partidasJuegoSeleccionado;

  @override
  void initState() {
    super.initState();
    partidasJuegoSeleccionado = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 170,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.jugador.juegos.length,
              itemBuilder: (context, index) {
                final JuegoDto juego = widget.jugador.juegos[index];
                return SizedBox(
                    width: 170,
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            partidasJuegoSeleccionado = juego.partidas;
                          });
                        },
                        child: CardJuego(juego: juego, accion: null)));
              }),
        ),
        _informacionPartidasJugador(partidas: partidasJuegoSeleccionado)
      ],
    );
  }
}

Widget _tarjetaPartidaJuegoJugador({required PartidaDto partida, required bool par}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
    child: Transform.rotate(
      angle: -0.02 + Random().nextDouble() * (0.02 - -0.02),
      child: Container(
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: Column(
          children: [
            Text('${partida.tituloJuego.toString()} ${partida.subtituloJuego ?? ''}', style: styleTexto.bodyMedium),
            Text(partida.nombre.toString(), style: styleTexto.bodySmall, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
            Text(partida.fecha.toString(), style: styleTexto.bodySmall),
          ],
        ),
      ),
    ),
  );
}
