import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
}

class Informacion {
  List<Item> listaItems() {
    final List<Item> listaInformacion = [];

    listaInformacion.add(Item(
        expandedValue: const Text(
            '"No Hit" se le denomina al reto en el cual se logra completar un video juego sin recibir daño alguno por jefes, enemigos y/o trampas del mismo.'),
        headerValue: 'Que es "No Hit"?'));

    listaInformacion.add(Item(
        expandedValue: RichText(
            text: TextSpan(children: [
          const TextSpan(text: 'Solo los juegos que son abalados por la pagina '),
          TextSpan(text: 'teamhitless.com', recognizer: TapGestureRecognizer()..onTap = () => launchUrlString('https://www.teamhitless.com')),
          const TextSpan(
              text:
                  ' son los que se determinan como oficiales, cualquier otro juego que no se encuentre en dicha pagina se considera como un juego no oficial'),
        ])),
        headerValue: 'Por que hay juegos oficiales y no oficiales'));
    return listaInformacion;
  }
}
