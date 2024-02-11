import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
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
  late ColorScheme color;
  late TextTheme styleTexto;

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
    });
  }

  _avanzarPagina(int page) async {
    if (page <= 2) {
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

    return Scaffold(
      body: _contenido(context),
    );
  }

  Widget _contenido(BuildContext context) {
    return Stack(
      children: [
        PageView(
          controller: pageController,
          onPageChanged: (page) => setState(() {
            indexPage = page;
          }),
          children: const [Placeholder(), Placeholder(), Placeholder()],
        ),
        Container(
            alignment: const Alignment(0, 0.70),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 3,
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
                duration: const Duration(milliseconds: 500),
                firstChild: const Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                secondChild: const Text("Empezar"),
                crossFadeState: indexPage == 2 ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
            ),
          ),
        )
      ],
    );
  }
}
