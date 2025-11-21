import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:no_hit/presentation/views/informacion/informacion_data.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class PreguntasFrecuentesView extends StatelessWidget {
  static const nombre = 'informacion-screen';

  const PreguntasFrecuentesView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomNavigation(),
          appBar: AppBar(
            forceMaterialTransparency: true,
            title: Text(AppLocalizations.of(context)!.preguntas_frecuentes),
            centerTitle: true,
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
    return Column(
      children: [
        // FAQ List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: informacion.length,
            itemBuilder: (context, index) {
              final item = informacion[index];
              return _buildFaqItem(context, item, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem(BuildContext context, Item item, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: colorScheme.tertiary,
          width: 1,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          cardTheme: const CardThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            elevation: 0,
            margin: EdgeInsets.zero,
          ),
        ),
        child: ExpansionTile(
          key: PageStorageKey<int>(index),
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          title: Text(
            item.headerValue,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.outline,
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              item.isExpanded = expanded;
            });
          },
          trailing: AnimatedRotation(
            duration: const Duration(milliseconds: 200),
            turns: item.isExpanded ? 0.5 : 0,
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: colorScheme.outline,
              size: 28,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          collapsedBackgroundColor: colorScheme.surfaceContainerHighest,
          backgroundColor: colorScheme.surface,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: textTheme.bodyLarge!.copyWith(
                      color: colorScheme.outline,
                      height: 1.6,
                    ),
                    child: item.expandedValue,
                  ),
                  if (item.buttons.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.buttons.map((button) {
                        return ElevatedButton.icon(
                          onPressed: button.action,
                          icon: button.icon != null ? Icon(button.icon) : const SizedBox.shrink(),
                          label: Text(button.label),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.tertiary,
                            foregroundColor: colorScheme.onTertiary,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
