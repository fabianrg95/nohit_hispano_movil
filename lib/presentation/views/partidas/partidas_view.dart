import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/human_format.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(ultimasPartidasProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    listaUltimasPartidas = ref.watch(ultimasPartidasProvider);

    return Scaffold(
      //drawer: const CustomDraw(),
      appBar: _titulo(context),
      body: _contenido(listaUltimasPartidas),
    );
  }

  AppBar _titulo(BuildContext context) {
    return AppBar(
      title: const Text('Partidas'),
    );
  }

  Widget _contenido(final List<PartidaDto>? listaUltimasPartidas) {
    if (listaUltimasPartidas == null || listaUltimasPartidas.isEmpty) {
      return const PantallaCargaBasica(texto: 'Consultando ultimas partidas');
    }

    return ListView.builder(
      itemCount: listaUltimasPartidas.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemPartida(partida: listaUltimasPartidas[index]);
      },
    );
  }

  Widget _itemPartida({required PartidaDto partida}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(
            opacity: animation,
            child: DetallePartidaView(
              partidaId: partida.id,
              jugadorId: partida.idJugador,
            ));
      })),
      child: Container(
        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 20, left: 20),
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        height: 270,
        decoration: BoxDecoration(
            color: AppTheme.base,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15), topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            border: Border.all(color: AppTheme.extra, width: 2),
            image: DecorationImage(
                image: NetworkImage(partida.urlImagenJuego!),
                fit: BoxFit.fitWidth,
                colorFilter: const ColorFilter.mode(AppTheme.base, BlendMode.modulate))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(HumanFormat.fechaMes(partida.fecha.toString()), style: styleTexto.bodySmall),
                  Text(HumanFormat.fechaDia(partida.fecha.toString()), style: styleTexto.bodyLarge)
                ],
              ),
            ),
            const Expanded(flex: 1, child: SizedBox(height: 1)),
            Container(
              padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
              width: double.infinity,
              decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(style: styleTexto.titleMedium?.copyWith(fontWeight: FontWeight.w100), children: [
                    TextSpan(text: partida.tituloJuego),
                    TextSpan(text: partida.subtituloJuego != null ? " ${partida.subtituloJuego!}" : '', style: styleTexto.labelSmall)
                  ])),
                  Text("Por ${partida.nombreJugador!}", style: styleTexto.titleSmall?.copyWith(color: AppTheme.textoResaltado)),
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
      ),
    );
  }
}
