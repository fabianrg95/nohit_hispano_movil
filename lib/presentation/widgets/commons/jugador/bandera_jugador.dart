import 'package:flutter/material.dart';

class BanderaJugador extends StatelessWidget {
  final String? codigoBandera;
  final double tamanio;
  final bool defaultNegro;

  const BanderaJugador(
      {super.key,
      required this.codigoBandera,
      this.tamanio = 40,
      this.defaultNegro = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: codigoBandera != null,
      replacement: Image.asset('assets/images/panel_${defaultNegro ? 'negro' : 'blanco'}.png',
          fit: BoxFit.fill, width: tamanio + 15, height: tamanio),
      child: ClipOval(
        child: Image.asset(
          'icons/flags/png/$codigoBandera.png',
          package: 'country_icons',
          fit: BoxFit.fill,
          width: tamanio,
          height: tamanio,
        ),
      ),
    );
  }
}
