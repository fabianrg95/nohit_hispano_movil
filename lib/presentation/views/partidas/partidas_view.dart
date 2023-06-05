import 'package:flutter/material.dart';

class PartidasView extends StatelessWidget {
  const PartidasView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Partidas',
          style: textStyle.titleLarge?.copyWith(color: colors.primary),
        ),
        centerTitle: true,
      ),
    ));
  }
}
