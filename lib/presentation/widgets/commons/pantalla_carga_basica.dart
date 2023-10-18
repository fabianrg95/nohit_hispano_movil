import 'package:flutter/material.dart';

class PantallaCargaBasica extends StatelessWidget {
  final String texto;

  const PantallaCargaBasica({
    this.texto = 'Cargando...',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const CircularProgressIndicator(strokeWidth: 2), Text(texto, textAlign: TextAlign.center)]),
      ),
    );
  }
}
