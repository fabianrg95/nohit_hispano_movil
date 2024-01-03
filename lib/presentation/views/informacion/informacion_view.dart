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
    final TextTheme styleTexto = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              informacion[index].isExpanded = isExpanded;
            });
          },
          children: informacion.map<ExpansionPanel>((Item dato) {
            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (context, isExpanded) {
                return ListTile(
                    title: Text(
                  dato.headerValue,
                  style: styleTexto.titleMedium,
                ));
              },
              body: ListTile(
                  title: Text(
                dato.expandedValue,
                style: styleTexto.bodyLarge,
              )),
              isExpanded: dato.isExpanded,
            );
          }).toList()),
    );
  }
}
