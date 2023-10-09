import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/partidas/ultimas_partidas_provider.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PartidasView extends ConsumerStatefulWidget {
  static const nombre = 'partidas_view';

  const PartidasView({super.key});

  @override
  PartidasViewState createState() => PartidasViewState();
}

class PartidasViewState extends ConsumerState<PartidasView> {
  List<PartidaDto>? listaUltimasPartidas = [];

  @override
  void initState() {
    super.initState();
    ref.read(ultimasPartidasProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);

    if (listaUltimasPartidas == null || listaUltimasPartidas!.isEmpty) {
      return const PantallaCargaBasica(texto: 'Consultando ultimas partidas');
    }

    return Scaffold(
      appBar: _titulo(context),
      body: _contenido(listaUltimasPartidas),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      leading: IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu)),
    );
  }

  Widget _contenido(final List<PartidaDto>? listaUltimasPartidas) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_ultimasPartidas(listaUltimasPartidas), _ultimosJugadores()],
      ),
    );
  }

  Widget _ultimosJugadores() {
    return Container(
      width: size.width,
      margin: const EdgeInsets.only(left: 25, right: 25, top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: AppTheme.decorationContainerBasic(bottomLeft: true, bottomRight: true, topLeft: false, topRight: false),
      child: const Center(child: Text('Jugadores nuevos')),
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
        SizedBox(
          height: 310,
          width: double.infinity,
          child: Swiper(
            viewportFraction: 0.8,
            scale: 0.8,
            autoplay: true,
            pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(activeColor: color.primary, color: color.secondary), margin: const EdgeInsets.only(top: 0)),
            itemCount: listaUltimasPartidas.length,
            itemBuilder: (context, index) {
              return _slide(partida: listaUltimasPartidas[index]);
            },
          ),
        )
      ],
    );
  }

  Widget _slide({required PartidaDto partida}) {
    return Column(
      children: [
        ImagenJuego(juego: partida.tituloJuego.toString(), urlImagen: partida.urlImagenJuego),
        Text(partida.tituloJuego.toString()),
        Visibility(visible: partida.subtituloJuego != null, child: Text(partida.subtituloJuego.toString())),
        Text(partida.nombreJugador.toString()),
        Text(partida.fecha.toString()),
      ],
    );
  }
}
