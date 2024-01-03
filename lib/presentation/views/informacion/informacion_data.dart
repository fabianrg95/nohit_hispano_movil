class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

class Informacion {
  List<Item> listaItems() {
    final List<Item> listaInformacion = [];

    listaInformacion.add(Item(
        expandedValue:
            '"No Hit" se le denomina al reto en el cual se logra completar un video juego sin recibir daño alguno por jefes, enemigos y/o trampas del mismo.',
        headerValue: 'Que es "No Hit"?'));

    // listaInformacion.add(Item(
    //     expandedValue:
    //         '"No Hit" se le denomina al reto en el cual se logra completar un video juego sin recibir daño alguno por jefes, enemigos y/o trampas del mismo.',
    //     headerValue: ''));
    return listaInformacion;
  }
}
