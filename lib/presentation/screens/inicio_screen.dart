import 'package:flutter/material.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InicioScreen extends StatelessWidget {
  static const String nombre = 'inicio_screen';

  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const CustomDraw(),
      body: Builder(builder: (context) => const InicioView()),
    );
  }
}
