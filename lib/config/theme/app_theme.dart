import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primario = Color(0Xff253745);
  static const Color secundario = Color(0xffEDDDC4);
  static const Color terciario = Color(0xffEDDDC4);
  static const Color texto = Color(0xffEDDDC4);

  ThemeData getTheme() => ThemeData(
      fontFamily: GoogleFonts.poppins().fontFamily,
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(circularTrackColor: terciario),
      useMaterial3: true,
      cardTheme: const CardTheme(color: secundario),
      listTileTheme: const ListTileThemeData(textColor: texto),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: terciario,
          selectedItemColor: Color(0xff353052),
          unselectedLabelStyle: TextStyle(color: Color(0xff353052)),
          unselectedItemColor: Color(0xFF353052)),
      colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: primario,
          background: primario,
          primary: primario,
          secondary: secundario,
          tertiary: terciario,
          surface: texto),
      tabBarTheme: TabBarTheme(
          indicator: BoxDecoration(
              color: terciario, borderRadius: BorderRadius.circular(10))),
      appBarTheme: const AppBarTheme(
          backgroundColor: terciario,
          centerTitle: true,
          //titleTextStyle: TextStyle(color: primario),
          foregroundColor: primario,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)))));
}
