import 'package:flutter/material.dart';

class PantallaCargaBasica extends StatelessWidget {
  final String texto;

  const PantallaCargaBasica({
    required this.texto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: Scaffold(
            body: Center(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            Text('Consultando informacion jugador')
          ]),
    )));
  }
}
