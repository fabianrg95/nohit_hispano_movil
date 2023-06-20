import 'package:flutter/material.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InicioScreen extends StatefulWidget {
  static const String nombre = 'inicio_screen';
  final int pageIndex;

  const InicioScreen({super.key, required this.pageIndex});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen>
    with AutomaticKeepAliveClientMixin {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(keepPage: true, initialPage: 1);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final viewRoutes = const <Widget>[
    JugadoresView(),
    PartidasView(),
    JuegosView(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (pageController.hasClients) {
      pageController.animateToPage(
        widget.pageIndex,
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 250),
      );
    }

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      body: const PartidasView(),
      //drawer: CustomDraw(currentIndex: widget.pageIndex),
      // bottomNavigationBar: CustomBottomNavigation(
      //   currentIndex: widget.pageIndex,
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
