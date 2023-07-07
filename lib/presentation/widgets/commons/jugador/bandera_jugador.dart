import 'package:flutter/material.dart';

class BanderaJugador extends StatelessWidget {
  final String? codigoBandera;
  final double width;
  final double height;
  final bool defaultNegro;

  const BanderaJugador(
      {super.key,
      required this.codigoBandera,
      this.width = 40,
      this.height = 40,
      this.defaultNegro = true});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: codigoBandera != null,
      replacement: Image.asset('assets/images/panel_${defaultNegro ? 'negro' : 'blanco'}.png',
          fit: BoxFit.fill, width: width + 15, height: height),
      child: ClipOval(
        child: Image.asset(
          'icons/flags/png/$codigoBandera.png',
          package: 'country_icons',
          fit: BoxFit.fill,
          width: width,
          height: height,
        ),
      ),
    );
  }
}
