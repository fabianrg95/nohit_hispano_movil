import 'dart:math';

import 'package:flutter/widgets.dart';

class AppInfo {
  static final AppInfo _instance = AppInfo._internal();

  factory AppInfo() => _instance;

  AppInfo._internal();

  late double ancho;
  late double alto;
  late double diagonal;

  void init(MediaQueryData mediaQuery) {
    ancho = mediaQuery.size.width;
    alto = mediaQuery.size.height;
    diagonal = sqrt(pow(ancho, 2) + pow(alto, 2));
  }

  double porcentajeAncho(double procentaje) {
    return ancho * procentaje;
  }

  double porcentajeAlto(double procentaje) {
    return alto * procentaje;
  }

  double porcentajeDiagonal(double procentaje) {
    return diagonal * procentaje;
  }
}
