import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_hit/presentation/views/introduccion/introduccion_view.dart';
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
  late bool esTemaClaro;
  late bool introduccionFinalizada;

  late ColorScheme color;
  late Size size;
  late TextTheme styleTexto;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward(from: 0.0);

    _actualizarConteos();
  }

  Future<void> _actualizarConteos({bool reload = false}) async {
    setState(() {
      ref.read(totalJugadoresProvider.notifier).loadData(reload);
      ref.read(totalPartidasProvider.notifier).loadData(reload);
      ref.read(totalJuegosProvider.notifier).loadData(reload);
      _controller.reset();
      _controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    size = MediaQuery.of(context).size;
    styleTexto = Theme.of(context).textTheme;

    totalJugadores = ref.watch(totalJugadoresProvider);
    totalPartidas = ref.watch(totalPartidasProvider);
    totalJuegos = ref.watch(totalJuegosProvider);
    esTemaClaro = ref.watch(themeNotifierProvider).esTemaClaro;
    introduccionFinalizada = ref.watch(introduccionProvider);

    if (totalJugadores != 0 && totalPartidas != 0 && totalJuegos != 0) {
      FlutterNativeSplash.remove();
    }

    if (introduccionFinalizada == false) {
      return const IntroduccionView();
    } else {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
            ),
            extendBodyBehindAppBar: true,
            drawer: const CustomNavigation(),
            body: RefreshIndicator(
                onRefresh: () => _actualizarConteos(reload: true),
                color: color.surfaceTint,
                backgroundColor: color.tertiary,
                child: contenido(totalJugadores, totalPartidas, context)),
          ),
        ),
      );
    }
  }

  Widget contenido(final int cantidadTotalJugadores, final int cantidadTotalPartidas, BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            const Expanded(flex: 2, child: SizedBox(height: 1)),
            Hero(
                tag: "headerNoHit",
                child: Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png', height: size.width * 0.6)),
            const Expanded(flex: 3, child: SizedBox(height: 1)),
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
              onTap: () => Navigator.of(context)
                  .push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const PartidasView()))),
              child: Container(
                margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                width: size.width * 0.5,
                decoration: ViewData().decorationContainerBasic(color: color),
                child: Column(
                  children: [
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) => Text((totalPartidas * _controller.value).toInt().toString(),
                            style: TextStyle(color: color.outline, fontSize: size.width * 0.08))),
                    Text(AppLocalizations.of(context)!.partidas('true'), style: TextStyle(color: Colors.white, fontSize: size.width * 0.04)),
                  ],
                ),
              ),
            ),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const ListaJugadoresView()))),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => Text((totalJugadores * _controller.value).toInt().toString(),
                              style: TextStyle(color: color.outline, fontSize: size.width * 0.08))),
                      Text(AppLocalizations.of(context)!.jugadores('true'), style: TextStyle(color: Colors.white, fontSize: size.width * 0.04)),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const ListaJuegosView()))),
                child: Container(
                  margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Column(
                    children: [
                      AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) => Text((totalJuegos * _controller.value).toInt().toString(),
                              style: TextStyle(color: color.outline, fontSize: size.width * 0.08))),
                      Text(AppLocalizations.of(context)!.juegos('true'), style: TextStyle(color: Colors.white, fontSize: size.width * 0.04)),
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
                  onTap: () => Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const PreguntasFrecuentesView()))),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: ViewData().decorationContainerBasic(color: color),
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.preguntas_frecuentes, style: TextStyle(color: Colors.white, fontSize: size.width * 0.04)),
                      ],
                    ),
                  ),
                ),
              ),
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () => setState(() {
              //       ref.read(themeNotifierProvider.notifier).toggleDarkmode();
              //     }),
              //     child: Container(
              //       margin: const EdgeInsets.only(right: 10, top: 10, left: 5),
              //       padding: const EdgeInsets.only(top: 10, bottom: 10),
              //       decoration: ViewData().decorationContainerBasic(color: color),
              //       child: Icon(esTemaClaro ? Icons.dark_mode_outlined : Icons.light_mode_outlined),
              //     ),
              //   ),
              // )
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }
}
