import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_hit/presentation/views/informacion/informacion_data.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class PreguntasFrecuentesView extends StatelessWidget {
  static const nombre = 'informacion-screen';

  const PreguntasFrecuentesView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomNavigation(),
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(AppLocalizations.of(context)!.preguntas_frecuentes),
          ),
          body: const Contenido(),
        ),
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
              body: Container(padding: const EdgeInsets.symmetric(horizontal: 8), child: dato.expandedValue),
              isExpanded: dato.isExpanded,
            );
          }).toList()),
    );
  }
}
