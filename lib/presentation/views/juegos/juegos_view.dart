import 'package:flutter/material.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class JuegosView extends StatefulWidget {
  static const nombre = 'juegos-screen';

  const JuegosView({super.key});

  @override
  State<JuegosView> createState() => _JuegosViewState();
}

class _JuegosViewState extends State<JuegosView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Juegos'),
        ),
        drawer: const CustomDraw(),
        body: const TapbarJuegos(),
      ),
    );
  }
}

class TapbarJuegos extends StatefulWidget {
  const TapbarJuegos({super.key});

  @override
  TapbarJuegosState createState() => TapbarJuegosState();
}

class TapbarJuegosState extends State<TapbarJuegos>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SizedBox(
          height: MediaQuery.of(context).size.height-80,
          child: Column(children: [
            const SizedBox(height: 5),
            Container(
                width: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    color: tema.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(children: [
                  TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      controller: tabController,
                      labelStyle: tema.textTheme.titleMedium,
                      unselectedLabelStyle: tema.textTheme.bodySmall,
                      tabs: const [
                        Tab(text: 'Oficiales'),
                        Tab(text: 'No oficiales')
                      ])
                ])),
            Expanded(
              child: TabBarView(controller: tabController, children: const [
                ListaJuegos(juegosOficiales: true),
                ListaJuegos(juegosOficiales: false)
              ]),
            )
          ]),
        ),
      ),
    );
  }
}
