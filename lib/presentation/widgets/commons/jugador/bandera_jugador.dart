import 'package:flutter/material.dart';

class BanderaJugador extends StatelessWidget {
  final String? codigoBandera;

  const BanderaJugador({
    super.key,
    required this.codigoBandera,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: codigoBandera != null,
      replacement: Image.asset(
        'assets/images/panel_blanco.png',
        fit: BoxFit.fill,
        width: 40,
        height: 35,
      ),
      child: ClipOval(
        child: Image.asset(
          'icons/flags/png/$codigoBandera.png',
          package: 'country_icons',
          fit: BoxFit.fill,
          width: 40,
          height: 40,
        ),
      ),
    );
  }
}
