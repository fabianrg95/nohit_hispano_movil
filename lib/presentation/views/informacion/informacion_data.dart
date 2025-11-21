import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
    this.buttons = const [],
  });

  Widget expandedValue;
  String headerValue;
  bool isExpanded;
  List<ItemButton> buttons;
}

class ItemButton {
  ItemButton({
    required this.label,
    required this.action,
    this.icon,
  });

  String label;
  VoidCallback action;
  IconData? icon;
}

class Informacion {
  List<Item> listaItems() {
    final List<Item> listaInformacion = [];

    listaInformacion.add(Item(
        expandedValue: const Text(
            '"No Hit" se le denomina al reto en el cual se logra completar un video juego sin recibir daño alguno por jefes, enemigos y/o trampas.'),
        headerValue: '¿Que es "No Hit"?'));

    listaInformacion.add(Item(
        expandedValue:
            const Text('Toda la información mostrada en la aplicación se obtiene del archivo excel de la comunidad no hit hispanohablante.'),
        headerValue: '¿De donde se obtiene esta información?'));

    listaInformacion.add(Item(
        expandedValue: const Text(
            'Solo los juegos que son avalados por la comunidad teamhitless son los que se determinan como oficiales, cualquier otro juego que no sea avalado por la comunidad se considera como un juego no oficial'),
        headerValue: '¿Por que hay juegos oficiales y no oficiales?',
        buttons: [
          ItemButton(
            label: 'Visitar TeamHitless',
            icon: Icons.open_in_browser,
            action: () => launchUrlString('https://www.teamhitless.com'),
          ),
        ]));
    return listaInformacion;
  }
}
