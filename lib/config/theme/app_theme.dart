import 'package:flutter/material.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';

class AppTheme {
  final bool esTemaClaro;
  late ColorScheme color = PaletaColores.temaClaro.getPaletaColor();

  AppTheme({this.esTemaClaro = true});

  ThemeData getTheme() {
    color = generarTema();

    return ThemeData(
        fontFamily: 'Nunito',
        colorScheme: color,
        progressIndicatorTheme: ProgressIndicatorThemeData(circularTrackColor: color.tertiary),
        useMaterial3: true,
        cardTheme: CardTheme(color: color.secondary),
        listTileTheme: ListTileThemeData(textColor: color.outline),
        appBarTheme: AppBarTheme(
          // backgroundColor: Colors.transparent,
          centerTitle: false,
          foregroundColor: color.tertiary,
          surfaceTintColor: color.tertiary,
        ),
        bottomSheetTheme: BottomSheetThemeData(backgroundColor: color.primary, showDragHandle: true),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: color.tertiary,
          foregroundColor: color.surfaceTint,
        ),
        scaffoldBackgroundColor: color.surface);
  }

  ColorScheme generarTema() {
    return esTemaClaro ? PaletaColores.temaClaro.getPaletaColor() : PaletaColores.temaOscuro.getPaletaColor();
  }

  AppTheme copyWith({bool? isDarkmode}) => AppTheme(
        esTemaClaro: isDarkmode ?? esTemaClaro,
      );
}
