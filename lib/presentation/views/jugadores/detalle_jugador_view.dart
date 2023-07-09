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
        appBar: AppBar(
            title: Text(jugador.nombre),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: BanderaJugador(
                    codigoBandera: jugador.codigoBandera, defaultNegro: false),
              )
            ]),
        body: Column(
          children: [
            Container(
                width: size.width * 0.85,
                margin: const EdgeInsets.only(left: 5, right: 5),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
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
                              child: Text(
                                jugador.pronombre.toString(),
                                style: styleTexto.bodyMedium
                                    ?.copyWith(color: color.tertiary),
                              )),
                          Visibility(
                              visible:
                                  jugador.genero != null && jugador.pais != null,
                              child: Text(
                                  Nacionalidad.obtenerGentilicioJugador(jugador),
                                  style: styleTexto.bodyMedium
                                      ?.copyWith(color: color.tertiary))),
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
                    : Center(
                        child: Text('Jugador sin informacion',
                            style: styleTexto.bodyMedium
                                ?.copyWith(color: color.tertiary)))),
            _ListaPartidasJugador(jugador: jugador),
          ],
        ),
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

  final DetalleJugador jugador;

  @override
  Widget build(BuildContext context) {
    return _InformacionPartidasJugador(jugador: jugador);
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
  Partidas? partidaSeleccionada;
  double? heigthContainer;

  @override
  void initState() {
    super.initState();
    heigthContainer = 0;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    void seleccionarPartida(Partidas partida) async {
      heigthContainer = 0;
      await Future(() => const Duration(milliseconds: 500));
      partidaSeleccionada = partida;
      setState(() {});
      heigthContainer = 200;
    }

    return Column(
      children: [
        Container(
          height: 230,
          margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
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
              Text('Juegos NoHit',
                  style:
                      textStyle.titleMedium?.copyWith(color: color.tertiary)),
              Divider(color: color.tertiary),
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
            ],
          ),
        ),
        AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: size.width * 0.85,
            height: heigthContainer,
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
            child: partidaSeleccionada == null
                ? const Text('Seleccione una partida')
                : _DetallePartidas(partidaSeleccionada: partidaSeleccionada!)),
      ],
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(partidaSeleccionada.juego.nombre,
              style: textStyle.titleMedium?.copyWith(color: color.tertiary)),
        ),
        Divider(color: color.primary),
        SizedBox(
          height: 120,
          width: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: partidaSeleccionada.partidas.length,
            itemBuilder: (BuildContext context, int index) {
              DetallePartida partida = partidaSeleccionada.partidas[index];
              return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Container(
                      width: 300,
                      color: color.primary,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(partida.nombre,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: textStyle.bodySmall
                                    ?.copyWith(color: color.tertiary)),
                          )
                        ],
                      )));
            },
          ),
        )
      ],
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
                    color: color.primary,
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
