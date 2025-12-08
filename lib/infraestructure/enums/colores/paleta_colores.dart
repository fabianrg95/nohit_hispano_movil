import 'package:flutter/material.dart';

enum PaletaColores {
  temaClaro(
    principal: Color(0XffEED6C5),
    secundario: Color(0xFFF0EBE5),
    terciario: Color(0xff282821),
    textoResaltado: Color.fromARGB(255, 0, 0, 0),
    textoSecundario: Color.fromARGB(255, 120, 120, 120),
    fondo: Color(0XffEED6C5),
    superficieVariante: Color(0xFFF5EcE9),
    error: Color(0xFFB3261E),
    exito: Color(0xFF2E7D32),
    advertencia: Color(0xFFF57C00),
    tema: Brightness.light,
    textoEnTerciario: Color(0xFFF0EBE5),
    textoEnSurfaceVariant: Color(0xff282821),
  ),
  temaOscuro(
      principal: Color(0Xff212121),
      secundario: Color(0xFFD4A574),
      terciario: Color.fromARGB(255, 158, 130, 87),
      textoResaltado: Color.fromARGB(255, 255, 255, 255),
      textoSecundario: Color.fromARGB(255, 200, 200, 200),
      fondo: Color(0Xff212121),
      superficieVariante: Color(0xFF444444),
      error: Color(0xFFF2B8B5),
      exito: Color(0xFFA8E6C1),
      advertencia: Color(0xFFFFB74D),
      tema: Brightness.dark,
      textoEnTerciario: Color(0Xff212121),
      textoEnSurfaceVariant: Color.fromARGB(255, 255, 255, 255));

  final Color principal;
  final Color secundario;
  final Color terciario;
  final Color textoResaltado;
  final Color textoSecundario;
  final Color fondo;
  final Color superficieVariante;
  final Color error;
  final Color exito;
  final Color advertencia;
  final Brightness tema;
  final Color textoEnTerciario;
  final Color textoEnSurfaceVariant;

  const PaletaColores({
    required this.principal,
    required this.secundario,
    required this.terciario,
    required this.textoResaltado,
    required this.textoSecundario,
    required this.fondo,
    required this.superficieVariante,
    required this.error,
    required this.exito,
    required this.advertencia,
    required this.tema,
    required this.textoEnTerciario,
    required this.textoEnSurfaceVariant,
  });

  ColorScheme getPaletaColor() {
    return ColorScheme.fromSeed(
      seedColor: principal,
      surface: fondo,
      primary: principal,
      secondary: secundario,
      tertiary: terciario,
      surfaceContainerHighest: superficieVariante,
      error: error,
      onError: Color(0xFFFFFFFF),
      outline: textoResaltado,
      outlineVariant: textoSecundario,
      brightness: tema,
      onTertiary: textoEnTerciario,
      onSurfaceVariant: textoEnSurfaceVariant,
      surfaceBright: exito,
    );
  }
}
