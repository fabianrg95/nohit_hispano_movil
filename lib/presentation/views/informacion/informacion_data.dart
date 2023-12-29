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

    listaInformacion.add(Item(expandedValue: 'prueba', headerValue: 'data'));

    return listaInformacion;
  }
}
