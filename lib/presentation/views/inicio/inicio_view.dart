import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/juegos/lista_juegos_view.dart';
import 'package:no_hit/presentation/views/jugadores/lista_jugadores_view.dart';
import 'package:no_hit/presentation/views/partidas/partidas_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InicioView extends ConsumerStatefulWidget {
  static const nombre = 'inicio_view';

  const InicioView({super.key});

  @override
  InicioViewState createState() => InicioViewState();
}

class InicioViewState extends ConsumerState<InicioView> {
  int totalJugadores = 0;
  int totalPartidas = 0;
  int totalJuegos = 0;

  @override
  void initState() {
    super.initState();
    ref.read(totalJugadoresProvider.notifier).loadData();
    ref.read(totalPartidasProvider.notifier).loadData();
    ref.read(totalJuegosProvider.notifier).loadData();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    totalJugadores = ref.watch(totalJugadoresProvider);
    totalPartidas = ref.watch(totalPartidasProvider);
    totalJuegos = ref.watch(totalJuegosProvider);

    if (totalJugadores == 0 || totalPartidas == 0 || totalJuegos == 0) {
      return const PantallaCargaBasica(texto: 'Consultando informacion inicial');
    }

    FlutterNativeSplash.remove();

    return SafeArea(
      child: Scaffold(
        body: contenido(totalJugadores, totalPartidas, context),
      ),
    );
  }

  Widget contenido(final int cantidadTotalJugadores, final int cantidadTotalPartidas, BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/panel_negro.png', width: 260),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
          child: Text(
            'Una partida No hit/hitless consiste en completar un juego de principio a fin sin recibir ningún golpe de un enemigo o una trampa.',
            textAlign: TextAlign.center,
            style: styleTexto.bodyMedium,
          ),
        ),
        const Expanded(child: SizedBox(height: 1)),
        _informacionHispano(context),
      ],
    );
  }

  Widget _informacionHispano(BuildContext context) {
    return FadeInUp(
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                            child: Text(
                              'Jugadores',
                              style: styleTexto.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            totalJugadores.toString(),
                            style: styleTexto.displaySmall,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.00, 0.00),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(opacity: animation, child: const ListaJugadoresView());
                          })),
                          child: Text(
                            'Ver todos >',
                            style: styleTexto.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                            child: Text(
                              'Juegos',
                              style: styleTexto.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            totalJuegos.toString(),
                            style: styleTexto.displaySmall,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.00, 0.00),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(opacity: animation, child: const ListaJuegosView());
                          })),
                          child: Text(
                            'Ver todos >',
                            style: styleTexto.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                            child: Text(
                              'Partidas',
                              style: styleTexto.titleSmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                          child: Text(
                            totalPartidas.toString(),
                            style: styleTexto.displaySmall,
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: const AlignmentDirectional(1.00, 0.00),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(opacity: animation, child: const PartidasView());
                          })),
                          child: Text(
                            'Ver todas >',
                            style: styleTexto.labelSmall,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
