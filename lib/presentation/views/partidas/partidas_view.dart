import 'package:flutter/material.dart';

class PartidasView extends StatelessWidget {
  const PartidasView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Partidas'),
        centerTitle: true,
      ),
    ));
  }
}
