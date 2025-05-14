import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/introduccion/introduccion_view.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

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
        height: AppInfo().alto - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            const Expanded(flex: 2, child: SizedBox(height: 1)),
            Hero(
                tag: "headerNoHit",
                child: Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png',
                    height: AppInfo().porcentajeAncho(0.6))),
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
            contenedorInformativoLink(context, totalPartidas, AppLocalizations.of(context)!.partidas('true'), const PartidasView()),
          ]),
          Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            contenedorInformativoLink(context, totalJugadores, AppLocalizations.of(context)!.jugadores('true'), const ListaJugadoresView()),
            contenedorInformativoLink(context, totalJuegos, AppLocalizations.of(context)!.juegos('true'), const ListaJuegosView()),
          ]),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const PreguntasFrecuentesView()))),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  width: AppInfo().porcentajeAncho(0.70),
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Column(
                    children: [
                      Text(AppLocalizations.of(context)!.preguntas_frecuentes, style: styleTexto.titleMedium),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() {
                  ref.read(themeNotifierProvider.notifier).toggleDarkmode();
                }),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: AppInfo().porcentajeAncho(0.20),
                  decoration: ViewData().decorationContainerBasic(color: color),
                  child: Icon(esTemaClaro ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
                ),
              )
            ],
          ),
          const SizedBox(height: 10)
        ],
      ),
    );
  }

  GestureDetector contenedorInformativoLink(BuildContext context, int cantidad, String dato, Widget destino) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: destino))),
      child: contenedorInformativo(context, totalPartidas, dato),
    );
  }

  Container contenedorInformativo(BuildContext context, int cantidad, String dato) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: AppInfo().porcentajeAncho(0.45),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: Column(
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Text((cantidad * _controller.value).toInt().toString(),
                  style: TextStyle(color: color.outline, fontSize: AppInfo().porcentajeAncho(0.08)))),
          Text(dato, style: styleTexto.titleMedium),
        ],
      ),
    );
  }
}
