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
    final styleTexto = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    if (jugador == null || jugador.id == 0 || jugador.id != widget.idJugador) {
      return const PantallaCargaBasica();
    }

    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(title: Text(jugador.nombre), centerTitle: true, actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: BanderaJugador(
                codigoBandera: jugador.codigoBandera, defaultNegro: false),
          )
        ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: color.tertiary),
                      color: color.secondary,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  child: Visibility(
                    visible: InformacionJugadorUtils.validarInformacionJugador(
                        jugador),
                    replacement:
                        const Center(child: Text('Jugador sin informacion')),
                    child: _informacionJugador(jugador, styleTexto, color),
                  )),
              _InformacionPartidasJugador(jugador: jugador),
            ],
          ),
        ),
      ),
    );
  }

  Column _informacionJugador(
      DetalleJugador jugador, TextTheme styleTexto, ColorScheme color) {
    return Column(
      children: [
        Visibility(
            visible: jugador.pronombre != null,
            child: Text(
              jugador.pronombre.toString(),
            )),
        Visibility(
            visible: jugador.genero != null && jugador.pais != null,
            child: Text(Nacionalidad.obtenerGentilicioJugador(jugador))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: jugador.urlYoutube != null,
              child: GestureDetector(
                onTap: () => _lanzarUrl(jugador.urlYoutube.toString()),
                child: Image.asset(
                  'assets/images/youtube.png',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
            Visibility(
                visible:
                    jugador.urlYoutube != null && jugador.urlTwitch != null,
                child: VerticalDivider(
                  color: color.tertiary,
                )),
            Visibility(
                visible: jugador.urlTwitch != null,
                child: GestureDetector(
                  onTap: () => _lanzarUrl(jugador.urlTwitch.toString()),
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
    );
  }

  Future<void> _lanzarUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('no puede ser lanzada la url $url');
    }
  }
}

class _InformacionPartidasJugador extends StatefulWidget {
  const _InformacionPartidasJugador({
    required this.jugador,
  });

  final DetalleJugador jugador;

  @override
  State<_InformacionPartidasJugador> createState() =>
      _InformacionPartidasJugadorState();
}

class _InformacionPartidasJugadorState
    extends State<_InformacionPartidasJugador> {
  late Partidas partidaSeleccionada;

  @override
  void initState() {
    super.initState();
    partidaSeleccionada = widget.jugador.partidas[0];
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    void seleccionarPartida(Partidas partida) async {
      partidaSeleccionada = partida;
      setState(() {});
    }

    return Container(
      width: size.width,
      height: size.height,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
      color: color.secondary,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      border: Border.all(color: color.tertiary),
      boxShadow: const [
        BoxShadow(
            color: Colors.black12,
            spreadRadius: 0,
            blurRadius: 5,
            offset: Offset(0, 0))
      ]),
      child: Column(
    children: [
      SizedBox(
        height: 160,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: widget.jugador.partidas.length,
          itemBuilder: (BuildContext context, int index) {
            Partidas partida = widget.jugador.partidas[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () => seleccionarPartida(partida),
                child: _TarjetaPartidaJuegoJugador(
                    partida: partida, jugador: widget.jugador.nombre),
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(partidaSeleccionada.juego.nombre,
            style: textStyle.titleMedium),
      ),
      Divider(color: color.primary),
      _DetallePartidas(partidaSeleccionada: partidaSeleccionada)
    ],
      ),
    );
  }
}

class _DetallePartidas extends StatelessWidget {
  const _DetallePartidas({
    required this.partidaSeleccionada,
  });

  final Partidas partidaSeleccionada;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Expanded(
      child: SizedBox(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: partidaSeleccionada.partidas.length,
          itemBuilder: (BuildContext context, int index) {
            DetallePartida partida = partidaSeleccionada.partidas[index];
            return Card(
              elevation: 5,
              color: color.primary,
              child: ExpansionTile(
                title: Text(partida.nombre,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: textStyle.labelSmall),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TarjetaPartidaJuegoJugador extends StatelessWidget {
  final Partidas partida;
  final String jugador;

  const _TarjetaPartidaJuegoJugador(
      {required this.partida, required this.jugador});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return SizedBox(
      width: 150,
      child: Stack(
        children: [
          Align(
            alignment: AlignmentDirectional.center,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, -0.01) // Perspectiva 3D
                ..rotateX(0.25),
              alignment: FractionalOffset.center, // Rotación en el eje X,
              child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: color.tertiary),
                    color: color.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: const EdgeInsets.only(top: 20, right: 10, left: 10),
                  child: const SizedBox(
                    width: 150,
                    height: 110,
                  )),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.center,
            child: ImagenJuego(
              juego: partida.juego,
              existeUrl: partida.juego.urlImagen != null,
              tamanio: 110,
            ),
          )
        ],
      ),
    );
  }
}
