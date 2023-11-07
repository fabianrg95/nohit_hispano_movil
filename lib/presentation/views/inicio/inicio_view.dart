import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InicioView extends ConsumerStatefulWidget {
  static const nombre = 'inicio_view';

  const InicioView({super.key});

  @override
  InicioViewState createState() => InicioViewState();
}

class InicioViewState extends ConsumerState<InicioView> with SingleTickerProviderStateMixin {
  int totalJugadores = 0;
  int totalPartidas = 0;
  int totalJuegos = 0;
  bool esTemaClaro = true;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward(from: 0.0);

    _actualizarConteos();
  }

  Future<void> _actualizarConteos() async {
    setState(() {
      ref.read(totalJugadoresProvider.notifier).loadData();
      ref.read(totalPartidasProvider.notifier).loadData();
      ref.read(totalJuegosProvider.notifier).loadData();
      _controller.reset();
      _controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    totalJugadores = ref.watch(totalJugadoresProvider);
    totalPartidas = ref.watch(totalPartidasProvider);
    totalJuegos = ref.watch(totalJuegosProvider);
    esTemaClaro = ref.watch(themeNotifierProvider).esTemaClaro;

    if (totalJugadores == 0 || totalPartidas == 0 || totalJuegos == 0) {
      return const PantallaCargaBasica(texto: 'Consultando informacion inicial');
    }

    FlutterNativeSplash.remove();

    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () => _actualizarConteos(),
            color: color.surfaceTint,
            backgroundColor: color.tertiary,
            child: contenido(totalJugadores, totalPartidas, context)),
      ),
    );
  }

  Widget contenido(final int cantidadTotalJugadores, final int cantidadTotalPartidas, BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: size.height - MediaQuery.of(context).padding.top,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png', height: 160),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: Text(
                'Una partida No hit/hitless consiste en completar un juego de principio a fin sin recibir ningún golpe de un enemigo o una trampa.',
                textAlign: TextAlign.center,
                style: styleTexto.bodyMedium,
              ),
            ),
            const Expanded(flex: 1, child: SizedBox(height: 1)),
            _informacionHispano(context),
          ],
        ),
      ),
    );
  }

  Widget _informacionHispano(BuildContext context) {
    return FadeInUp(
      child: Column(
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
              onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                return FadeTransition(opacity: animation, child: const PartidasView());
              })),
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: size.width * 0.5,
                decoration: AppTheme().decorationContainerBasic(
                    topLeft: true, bottomLeft: true, bottomRight: true, topRight: true, background: color.secondary, bordeColor: color.tertiary),
                child: Column(
                  children: [
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Text((totalPartidas * _controller.value).toInt().toString(),
                            style: styleTexto.displaySmall?.copyWith(color: color.outline))),
                    Text('Partidas', style: styleTexto.titleMedium),
                    Align(
                      alignment: const AlignmentDirectional(1.00, 0.00),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                        child: Text(
                          'Ver todos >',
                          style: styleTexto.labelSmall,
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
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                  return FadeTransition(opacity: animation, child: const ListaJugadoresView());
                })),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: AppTheme().decorationContainerBasic(
                      topLeft: true, bottomLeft: true, bottomRight: true, topRight: true, background: color.secondary, bordeColor: color.tertiary),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => Text((totalJugadores * _controller.value).toInt().toString(),
                              style: styleTexto.displaySmall?.copyWith(color: color.outline))),
                      Text('Jugadores', style: styleTexto.titleMedium),
                      Align(
                        alignment: const AlignmentDirectional(1.00, 0.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                          child: Text(
                            'Ver todos >',
                            style: styleTexto.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                  return FadeTransition(opacity: animation, child: const ListaJuegosView());
                })),
                child: Container(
                  margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: AppTheme().decorationContainerBasic(
                      topLeft: true, bottomLeft: true, bottomRight: true, topRight: true, background: color.secondary, bordeColor: color.tertiary),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => Text((totalJuegos * _controller.value).toInt().toString(),
                              style: styleTexto.displaySmall?.copyWith(color: color.outline))),
                      Text('Juegos', style: styleTexto.titleMedium),
                      Align(
                        alignment: const AlignmentDirectional(1.00, 0.00),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 10, 0),
                          child: Text(
                            'Ver todos >',
                            style: styleTexto.labelSmall,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                    return FadeTransition(opacity: animation, child: const InformacionView());
                  })),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: AppTheme().decorationContainerBasic(
                        topLeft: true, bottomLeft: true, bottomRight: true, topRight: true, background: color.secondary, bordeColor: color.tertiary),
                    child: Column(
                      children: [
                        Text('Información', style: styleTexto.titleMedium),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => ref.read(themeNotifierProvider.notifier).toggleDarkmode(),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: AppTheme().decorationContainerBasic(
                        topLeft: true, bottomLeft: true, bottomRight: true, topRight: true, background: color.secondary, bordeColor: color.tertiary),
                    child: Icon(esTemaClaro ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
