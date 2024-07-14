import 'package:flutter/material.dart';

enum PaletaColores {
  temaClaro(
      principal: Color(0XffEED6C5),
      secundario: Color(0xFFF5EcE9),
      terciario: Color(0xff282821),
      textoResaltado: Color(0xff34566E),
      textoSecundario: Color(0xFFF5EcE9),
      tema: Brightness.light),
  temaOscuro(
      principal: Color(0Xff212121),
      secundario: Color(0xFF444444),
      terciario: Color(0xffb99763),
      textoResaltado: Color(0xffb99763),
      textoSecundario: Color(0xFF444444),
      tema: Brightness.dark);

  final Color principal;
  final Color secundario;
  final Color terciario;
  final Color textoResaltado;
  final Color textoSecundario;
  final Brightness tema;

  const PaletaColores(
      {required this.principal,
      required this.secundario,
      required this.terciario,
      required this.textoResaltado,
      required this.textoSecundario,
      required this.tema});

  ColorScheme getPaletaColor() {
    return ColorScheme.fromSeed(
        seedColor: principal,
        surface: principal,
        primary: principal,
        secondary: secundario,
        tertiary: terciario,
        surfaceTint: textoSecundario,
        outline: textoResaltado,
        brightness: tema);
  }
}
