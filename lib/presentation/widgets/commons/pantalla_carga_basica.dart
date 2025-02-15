import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PantallaCargaBasica extends StatelessWidget {
  final String texto;

  const PantallaCargaBasica({
    this.texto = 'Cargando...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomNavigation(),
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const CircularProgressIndicator(strokeWidth: 2), Text(texto, textAlign: TextAlign.center)]),
      ),
    );
  }
}
