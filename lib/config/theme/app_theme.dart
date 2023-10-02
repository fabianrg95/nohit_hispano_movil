import 'package:flutter/material.dart';

class AppTheme {
  static const Color base = Color(0XffEED6C5); //Color(0XffE3D8C4);
  static const Color complemento = Color(0xFFF5EcE9); //Color(0xFFFFFBF1);
  static const Color extra = Color(0xff282821);
  static const Color textoBase = Color(0xffF8D35B);
  static const Color textoComplemento = Color(0xff282821);
  static const Color textoResaltado = Color(0xff7EA89F);

  //estilo general
  final ColorScheme _colorScheme =
      ColorScheme.fromSeed(seedColor: extra, background: base, primary: base, secondary: complemento, tertiary: extra, surfaceTint: textoBase);

  ThemeData getTheme() => ThemeData(
        fontFamily: 'SharpGrotesk',
        colorScheme: _colorScheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData(circularTrackColor: extra),
        useMaterial3: true,
        cardTheme: const CardTheme(color: complemento),
        listTileTheme: const ListTileThemeData(textColor: textoBase),
        appBarTheme: const AppBarTheme(
            backgroundColor: extra,
            centerTitle: true,
            foregroundColor: textoBase,
            surfaceTintColor: extra,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)))),
      );

  static BoxDecoration decorationContainerBasic(
      {required bool topLeft, required bool bottomLeft, required bool bottomRight, required bool topRight}) {
    BorderRadius borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(bottomLeft ? 10 : 0),
        bottomRight: Radius.circular(bottomRight ? 10 : 0),
        topLeft: Radius.circular(topLeft ? 10 : 0),
        topRight: Radius.circular(topRight ? 10 : 0));

    return BoxDecoration(
      color: complemento,
      borderRadius: borderRadius,
      border: Border.all(color: extra, width: 2),
      //boxShadow: const [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 5, offset: Offset(0, 0))],
    );
  }
}
