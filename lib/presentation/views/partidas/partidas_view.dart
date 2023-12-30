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
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _cargarPartidas();
    scrollController.addListener(() {
      if ((scrollController.position.pixels + 500) > scrollController.position.maxScrollExtent) {
        _cargarPartidas();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);
    color = Theme.of(context).colorScheme;

    return Scaffold(
      drawer: const CustomNavigation(),
      appBar: _titulo(context),
      body: RefreshIndicator(
        onRefresh: () => _reiniciarPartidas(),
        color: color.surfaceTint,
        backgroundColor: color.tertiary,
        child: _contenido(listaUltimasPartidas),
      ),
    );
  }

  Future<void> _cargarPartidas() async {
    setState(() {
      ref.read(ultimasPartidasProvider.notifier).loadData();
    });
  }

  Future<void> _reiniciarPartidas() async {
    setState(() {
      ref.read(ultimasPartidasProvider.notifier).loadData();
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

    return SizedBox(
      height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
      child: ListView.builder(
          controller: scrollController,
          itemCount: listaUltimasPartidas.length,
          itemBuilder: (context, index) {
            return _itemPartida(partida: listaUltimasPartidas[index], context: context);
          }),
    );
  }

  Widget _itemPartida({required PartidaDto partida, required BuildContext context}) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme estiloTexto = Theme.of(context).textTheme;

    final String heroTag = 'Partida-${partida.id}';

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
          margin: const EdgeInsets.only(right: 20, left: 20),
          height: 600,
          child: Column(
            children: [
              Row(
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
                  Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person_outline),
                              const SizedBox(width: 5),
                              Text(partida.nombreJugador!, style: estiloTexto.titleMedium)
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.sports_esports_outlined, color: color.inverseSurface.withOpacity(0.6)),
                              const SizedBox(width: 5),
                              RichText(
                                  text: TextSpan(style: estiloTexto.titleSmall?.copyWith(color: color.inverseSurface.withOpacity(0.6)), children: [
                                TextSpan(text: partida.tituloJuego),
                                TextSpan(text: partida.subtituloJuego != null ? " ${partida.subtituloJuego!}" : '')
                              ]))
                            ],
                          )
                        ],
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 500,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Stack(children: [
                  Hero(
                      tag: heroTag,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          partida.urlImagenJuego!,
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width - 40,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress != null) {
                              return Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(
                                      color: color.tertiary,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return child;
                          },
                        ),
                      )),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: ViewData().decorationContainerBasic(color: color),
                        child: Center(
                            child: Text(
                          partida.nombre!,
                          style: estiloTexto.bodyLarge,
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ],
                  )
                ]),
              ),
              Divider(
                color: color.secondary,
              )
            ],
          )),
    );
  }
}
