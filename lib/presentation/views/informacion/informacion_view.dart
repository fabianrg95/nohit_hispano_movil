import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InformacionView extends ConsumerStatefulWidget {
  static const nombre = 'informacion-screen';
  const InformacionView({super.key});

  @override
  InformacionViewState createState() => InformacionViewState();
}

class InformacionViewState extends ConsumerState<InformacionView> with SingleTickerProviderStateMixin {
  int totalJugadores = 0;
  int totalPartidas = 0;
  int totalJuegos = 0;
  late bool esTemaClaro;

  late ColorScheme color;
  late Size size;
  late TextTheme styleTexto;

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
    size = MediaQuery.of(context).size;
    styleTexto = Theme.of(context).textTheme;

    totalJugadores = ref.watch(totalJugadoresProvider);
    totalPartidas = ref.watch(totalPartidasProvider);
    totalJuegos = ref.watch(totalJuegosProvider);
    esTemaClaro = ref.watch(themeNotifierProvider).esTemaClaro;

    FlutterNativeSplash.remove();

    return SafeArea(
      child: Scaffold(
        drawer: const CustomNavigation(),
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("Información"),
        ),
        body: const Placeholder(),
      ),
    );
  }
}
