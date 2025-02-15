import 'package:flutter/material.dart';

class BanderaJugador extends StatelessWidget {
  final String? codigoBandera;
  final double tamanio;

  const BanderaJugador({super.key, required this.codigoBandera, this.tamanio = 40});

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    return Visibility(
      visible: codigoBandera != null,
      replacement: Image.asset('assets/images/nohit_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png',
          fit: BoxFit.fill, width: tamanio - 5, height: tamanio + 10),
      child: ClipOval(
        child: Image.asset('icons/flags/png100px/$codigoBandera.png', package: 'country_icons', fit: BoxFit.fill, width: tamanio, height: tamanio),
      ),
    );
  }
}
