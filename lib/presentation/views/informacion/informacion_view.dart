import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:no_hit/presentation/views/informacion/informacion_data.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class InformacionView extends StatelessWidget {
  static const nombre = 'informacion-screen';

  const InformacionView({super.key});

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();

    return SafeArea(
      child: Scaffold(
        drawer: const CustomNavigation(),
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("Información"),
        ),
        body: const Contenido(),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  ContenidoState createState() => ContenidoState();
}

class ContenidoState extends State<Contenido> {
  List<Item> informacion = [];
  @override
  void initState() {
    super.initState();
    informacion = Informacion().listaItems();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              informacion[index].isExpanded = isExpanded;
            });
          },
          children: informacion.map<ExpansionPanel>((Item dato) {
            return ExpansionPanel(
              headerBuilder: (context, isExpanded) {
                return ListTile(title: Text(dato.headerValue));
              },
              body: ListTile(title: Text(dato.expandedValue)),
              isExpanded: dato.isExpanded,
            );
          }).toList()),
    );
  }
}
