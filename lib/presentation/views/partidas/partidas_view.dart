import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PartidasView extends StatelessWidget {
  static const nombre = 'partidas_view';

  const PartidasView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
        child: Scaffold(
            key: scaffoldKey,
            drawer: const CustomDraw(),
            appBar: AppBar(
              title: const Text('No hit hispano'),
              centerTitle: true,
            )));
  }
}
