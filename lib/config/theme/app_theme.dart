import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color base = Color(0XffE3D8C4);
  static const Color complemento = Color(0xFFFFFBF1);
  static const Color extra = Color(0xff282821);
  static const Color textoBase = Color(0xffF8D35B);
  static const Color textoComplemento = Color(0xff282821);

  //estilo general
  final ColorScheme _colorScheme = ColorScheme.fromSeed(
      seedColor: extra,
      background: base,
      primary: base,
      secondary: complemento,
      tertiary: extra,
      surfaceTint: textoBase);

  ThemeData getTheme() => ThemeData(
        fontFamily: GoogleFonts.raleway().fontFamily,
        colorScheme: _colorScheme,
        progressIndicatorTheme:
            const ProgressIndicatorThemeData(circularTrackColor: extra),
        useMaterial3: true,
        cardTheme: const CardTheme(color: complemento),
        listTileTheme: const ListTileThemeData(textColor: textoBase),
        tabBarTheme: TabBarTheme(
            labelColor: textoBase,
            indicator: BoxDecoration(
                color: extra, borderRadius: BorderRadius.circular(10))),
        appBarTheme: const AppBarTheme(
            backgroundColor: extra,
            centerTitle: true,
            //titleTextStyle: TextStyle(color: primario),
            foregroundColor: textoBase,
            surfaceTintColor: extra,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)))),
      );
}
