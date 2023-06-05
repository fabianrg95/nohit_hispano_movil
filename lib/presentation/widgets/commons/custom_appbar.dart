import 'package:flutter/material.dart';

AppBar customAppbar(String titulo, Color color) {
  return AppBar(
      title: Text(titulo),
      centerTitle: true,
      backgroundColor: color,
      elevation: 0);
}
