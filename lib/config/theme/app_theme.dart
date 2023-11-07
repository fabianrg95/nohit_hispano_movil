import 'package:flutter/material.dart';

class AppTheme {
  final bool esTemaClaro;

  AppTheme({this.esTemaClaro = true});

  static ColorScheme temaClaro = ColorScheme.fromSeed(
      seedColor: const Color(0xff282821),
      background: const Color(0XffEED6C5),
      primary: const Color(0XffEED6C5),
      secondary: const Color(0xFFF5EcE9),
      tertiary: const Color(0xff282821),
      surfaceTint: const Color(0xFFF5EcE9),
      outline: const Color(0xff34566E),
      brightness: Brightness.light);

  static ColorScheme temaOscuro = ColorScheme.fromSeed(
      seedColor: const Color(0xffb99763),
      background: const Color(0Xff212121),
      primary: const Color(0Xff212121),
      secondary: const Color(0xFF444444),
      tertiary: const Color(0xffb99763),
      surfaceTint: const Color(0xFF444444),
      outline: const Color(0xffb99763),
      brightness: Brightness.dark);

  // late Color base = Color(0XffEED6C5);
  // late Color complemento = Color(0xFFF5EcE9);
  // late Color extra = Color(0xff282821);
  // late Color textoBase = Color(0xffF8D35B);
  // late Color textoResaltado = Color(0xff34566E);
  // late Brightness thema = Brightness.light;

  // static const Color base = Color(0Xff212121);
  // static const Color complemento = Color(0xFF444444);
  // static const Color extra = Color(0xffb99763);
  // static const Color textoBase = Color(0xffF8D35B);
  // static const Color textoResaltado = Color(0xffb99763);

  ThemeData getTheme() {
    final ColorScheme colorScheme = validarTema();

    return ThemeData(
      fontFamily: 'SharpGrotesk',
      colorScheme: colorScheme,
      progressIndicatorTheme: ProgressIndicatorThemeData(circularTrackColor: colorScheme.tertiary),
      useMaterial3: true,
      cardTheme: CardTheme(color: colorScheme.secondary),
      listTileTheme: ListTileThemeData(textColor: colorScheme.outline),
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        centerTitle: false,
        foregroundColor: colorScheme.tertiary,
        surfaceTintColor: colorScheme.tertiary,
      ),
    );
  }

  ColorScheme validarTema() {
    if (esTemaClaro) return temaClaro;

    return temaOscuro;
  }

  BoxDecoration decorationContainerBasic(
      {required bool topLeft,
      required bool bottomLeft,
      required bool bottomRight,
      required bool topRight,
      required Color background,
      required Color bordeColor}) {
    BorderRadius borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft ? 15 : 0),
        bottomRight: Radius.circular(bottomRight ? 15 : 0),
        topLeft: Radius.circular(topLeft ? 15 : 0),
        topRight: Radius.circular(topRight ? 15 : 0));

    return BoxDecoration(
      color: background,
      borderRadius: borderRadius,
      border: Border.all(color: bordeColor, width: 2),
      //boxShadow: const [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5, offset: Offset(0, 0))],
    );
  }

  AppTheme copyWith({bool? isDarkmode}) => AppTheme(
        esTemaClaro: isDarkmode ?? esTemaClaro,
      );
}
