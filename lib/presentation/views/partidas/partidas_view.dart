import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
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
  late ColorScheme color;

  @override
  void initState() {
    super.initState();
    ref.read(ultimasPartidasProvider.notifier).loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);
    color = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const CustomNavigation(),
      appBar: _titulo(context),
      body: RefreshIndicator(
        onRefresh: () => _actualizarPartidas(),
        color: color.surfaceTint,
        backgroundColor: color.tertiary,
        child: _contenido(listaUltimasPartidas),
      ),
    );
  }

  Future<void> _actualizarPartidas() async {
    setState(() {
      ref.read(ultimasPartidasProvider.notifier).loadData(true);
    });
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      title: const Text('Ultimas Partidas'),
      forceMaterialTransparency: true,
    );
  }

  Widget _contenido(final List<PartidaDto>? listaUltimasPartidas) {
    if (listaUltimasPartidas == null || listaUltimasPartidas.isEmpty) {
      return const PantallaCargaBasica(texto: 'Consultando ultimas partidas');
    }

    return Swiper(
        autoplayDelay: 5000,
        autoplay: true,
        autoplayDisableOnInteraction: true,
        itemCount: listaUltimasPartidas.length,
        itemBuilder: (context, index) {
          return _itemPartida(partida: listaUltimasPartidas[index], context: context);
        });
  }

  Widget _itemPartida({required PartidaDto partida, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme estiloTexto = Theme.of(context).textTheme;

    final String heroTag = partida.id.toString() +
        partida.tituloJuego.toString() +
        (partida.subtituloJuego == null ? partida.subtituloJuego.toString() : partida.idJuego.toString());

    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(
            opacity: animation,
            child: DetallePartidaView(
                partidaId: partida.id,
                jugadorId: partida.idJugador,
                heroTag: heroTag,
                idJuego: partida.idJuego,
                nombreJuego: partida.tituloJuego.toString(),
                urlImagenJuego: partida.urlImagenJuego.toString()));
      })),
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
        child: Stack(children: [
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(tag: heroTag, child: Image.network(partida.urlImagenJuego!, fit: BoxFit.fitWidth)))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(HumanFormat.fechaMes(partida.fecha.toString()), style: estiloTexto.bodySmall),
                      Text(HumanFormat.fechaDia(partida.fecha.toString()), style: estiloTexto.bodyLarge)
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: SizedBox(height: 1)),
                Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                  width: double.infinity,
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(style: estiloTexto.titleMedium?.copyWith(fontWeight: FontWeight.w100), children: [
                        TextSpan(text: partida.tituloJuego),
                        TextSpan(text: partida.subtituloJuego != null ? " ${partida.subtituloJuego!}" : '', style: estiloTexto.labelSmall)
                      ])),
                      Text("Por ${partida.nombreJugador!}", style: estiloTexto.titleSmall?.copyWith(color: color.outline)),
                      Container(
                          margin: const EdgeInsets.only(top: 15, bottom: 5),
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                  child: Text(
                                partida.nombre!,
                                textAlign: TextAlign.center,
                              ))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
