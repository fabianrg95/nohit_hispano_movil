import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
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
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

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
        return _slideJuego(partida: listaUltimasPartidas[index]);
      },
    );
  }

  Widget _slideJuego({required PartidaDto partida}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
        return FadeTransition(
            opacity: animation,
            child: DetallePartidaView(
              partidaId: partida.id,
              jugadorId: partida.idJugador,
            ));
      })),
      child: Stack(children: [
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 70),
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          height: 185,
          decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.only(left: 60, top: 10),
              child: Column(
                children: [
                  Text(partida.nombreJugador.toString(), style: styleTexto.titleMedium),
                  const Expanded(flex: 2, child: SizedBox(height: 1)),
                  Text(partida.tituloJuego.toString(), style: styleTexto.titleSmall),
                  Visibility(
                    visible: partida.subtituloJuego != null,
                    child: Text(partida.subtituloJuego.toString(), style: styleTexto.labelSmall),
                  ),
                  const Expanded(flex: 3, child: SizedBox(height: 1)),
                  Text(HumanFormat.fecha(partida.fecha.toString()), style: styleTexto.labelSmall),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 5, bottom: 10),
          child: ImagenJuego(
            juego: partida.tituloJuego.toString(),
            urlImagen: partida.urlImagenJuego,
            tamanio: 185,
          ),
        ),
      ]),
    );
  }
}
