import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroduccionView extends ConsumerStatefulWidget {
  static const nombre = 'introduccion-screen';
  const IntroduccionView({super.key});

  @override
  IntroduccionViewState createState() => IntroduccionViewState();
}

class IntroduccionViewState extends ConsumerState<IntroduccionView> {
  PageController pageController = PageController();
  int indexPage = 0;
  int cantidadPantallas = 2;
  late ColorScheme color;
  late TextTheme styleTexto;
  late Size size;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _marcarIntroduccionFinalizada() async {
    setState(() {
      ref.read(introduccionProvider.notifier).introduccionFinalizada();
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: const InicioView())));
    });
  }

  _avanzarPagina(int page) async {
    if (page <= cantidadPantallas - 1) {
      setState(() {
        indexPage = page;
        pageController.animateToPage(page, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      });
    } else {
      _marcarIntroduccionFinalizada();
    }
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: _contenido(context),
    );
  }

  Widget _contenido(BuildContext context) {
    return Stack(
      children: [
        Container(
          alignment: const Alignment(0, -0.46),
          child: Hero(
              tag: "headerNoHit",
              child: Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png', height: 260)),
        ),
        PageView(
          controller: pageController,
          onPageChanged: (page) => setState(() {
            indexPage = page;
          }),
          children: [pantalla1(), pantalla2()],
        ),
        Container(
            alignment: const Alignment(0, 0.68),
            child: SmoothPageIndicator(
              controller: pageController,
              count: cantidadPantallas,
              effect: ExpandingDotsEffect(dotColor: color.secondary, activeDotColor: color.tertiary),
            )),
        Container(
          alignment: const Alignment(0, 0.85),
          child: TextButton(
            style: TextButton.styleFrom(backgroundColor: color.tertiary, textStyle: styleTexto.titleLarge),
            onPressed: () => _avanzarPagina(indexPage + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              child: AnimatedCrossFade(
                firstCurve: Curves.linear,
                secondCurve: Curves.linear,
                duration: const Duration(milliseconds: 300),
                firstChild: const Icon(Icons.arrow_forward_ios_outlined),
                secondChild: const Text("Empezar"),
                crossFadeState: indexPage == cantidadPantallas - 1 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget pantalla1() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: const Alignment(0, 0.3),
      child: Text(
        'Aca encontraras las partidas, Jugadores y juegos registrados en la comunidad No Hit Hispanohablante.',
        textAlign: TextAlign.center,
        style: styleTexto.titleLarge,
      ),
    );
  }

  Widget pantalla2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: const Alignment(0, 0.3),
      child: Text(
        'Una partida No hit/hitless consiste en completar un juego de principio a fin sin recibir algún golpe de un enemigo o una trampa.',
        textAlign: TextAlign.center,
        style: styleTexto.titleLarge,
      ),
    );
  }

  Widget pantalla3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png', height: 260),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 50, bottom: 10),
          child: Text(
            'No olvides apoyar a todos.',
            textAlign: TextAlign.center,
            style: styleTexto.titleMedium,
          ),
        )
      ],
    );
  }
}
