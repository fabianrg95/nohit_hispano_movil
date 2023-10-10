import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/jugador/ultimos_jugadores_provider.dart';
import 'package:no_hit/infraestructure/providers/partidas/ultimas_partidas_provider.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/views/partidas/detalle_partida_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PartidasView extends ConsumerStatefulWidget {
  static const nombre = 'partidas_view';

  const PartidasView({super.key});

  @override
  PartidasViewState createState() => PartidasViewState();
}

class PartidasViewState extends ConsumerState<PartidasView> {
  List<PartidaDto>? listaUltimasPartidas = [];
  List<JugadorDto>? listaUltimosJugadores = [];

  @override
  void initState() {
    super.initState();
    ref.read(ultimasPartidasProvider.notifier).loadData();
    ref.read(ultimosJugadoresProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);
    listaUltimosJugadores = ref.watch(ultimosJugadoresProvider);

    if ((listaUltimasPartidas == null || listaUltimasPartidas!.isEmpty) && (listaUltimosJugadores == null || listaUltimosJugadores!.isEmpty)) {
      return const PantallaCargaBasica(texto: 'Consultando ultimas partidas');
    }

    return Scaffold(
      appBar: _titulo(context),
      body: _contenido(listaUltimasPartidas, listaUltimosJugadores),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu)),
    );
  }

  Widget _contenido(final List<PartidaDto>? listaUltimasPartidas, final List<JugadorDto>? listaUltimosJugadores) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_ultimasPartidas(listaUltimasPartidas), _ultimosJugadores(listaUltimosJugadores)],
      ),
    );
  }

  Widget _ultimosJugadores(final List<JugadorDto>? listaUltimosJugadores) {
    if (listaUltimosJugadores == null) {
      return const SizedBox(height: 1);
    }

    return Column(
      children: [
        Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: false, topRight: false),
          child: const Center(child: Text('Jugadores nuevos')),
        ),
        const SizedBox(height: 10),
        Swiper(
          viewportFraction: 0.8,
          scale: 0.9,
          layout: SwiperLayout.TINDER,
          itemWidth: 500.0,
          itemHeight: 150.0,
          autoplayDelay: 5000,
          autoplay: true,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(activeColor: color.tertiary, color: color.surface),
            margin: const EdgeInsets.only(top: 150),
          ),
          itemCount: listaUltimosJugadores.length,
          itemBuilder: (context, index) {
            return _slideJugador(jugador: listaUltimosJugadores[index]);
          },
        )
      ],
    );
  }

  Widget _ultimasPartidas(final List<PartidaDto>? listaUltimasPartidas) {
    if (listaUltimasPartidas == null) {
      return const SizedBox(height: 1);
    }

    return Column(
      children: [
        Container(
          width: size.width,
          margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: false, topRight: false),
          child: const Center(child: Text('Ultimas partidas')),
        ),
        Swiper(
          viewportFraction: 0.8,
          scale: 0.9,
          layout: SwiperLayout.TINDER,
          itemWidth: 500.0,
          itemHeight: 350.0,
          autoplayDelay: 5000,
          autoplay: true,
          pagination: SwiperPagination(
            builder: DotSwiperPaginationBuilder(activeColor: color.tertiary, color: color.surface),
            margin: const EdgeInsets.only(top: 350),
          ),
          itemCount: listaUltimasPartidas.length,
          itemBuilder: (context, index) {
            return _slideJuego(partida: listaUltimasPartidas[index]);
          },
        )
      ],
    );
  }

  Widget _slideJuego({required PartidaDto partida}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetallePartidaView(partidaId: partida.id));
      })),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Text(partida.tituloJuego.toString()),
              Visibility(visible: partida.subtituloJuego != null, child: Text(partida.subtituloJuego.toString())),
              ImagenJuego(
                  juego: partida.tituloJuego.toString(), urlImagen: partida.urlImagenJuego, tamanio: partida.subtituloJuego != null ? 170 : 200),
              Text(partida.nombreJugador.toString()),
              Text(partida.fecha.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slideJugador({required JugadorDto jugador}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: jugador.id!));
      })),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: BanderaJugador(codigoBandera: jugador.codigoBandera, tamanio: 90),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(jugador.nombre.toString()),
                    Text(jugador.pronombre.toString()),
                    Text(jugador.gentilicio.toString()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
