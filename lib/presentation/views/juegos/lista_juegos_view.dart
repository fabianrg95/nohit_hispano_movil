import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJuegosView extends StatelessWidget {
  static const nombre = 'lista-juegos-screen';

  const ListaJuegosView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer: const CustomDraw(),
        appBar: AppBar(title: const Text('Juegos'), actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => showModalBottomSheet(
                      context: context,
                      backgroundColor: color.primary,
                      showDragHandle: true,
                      useSafeArea: true,
                      builder: (context) => Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lista de Juegos', style: styleTexto.titleLarge),
                                const Text(
                                    'Aca encontraras los juegos en los cuales por lo menos una persona de habla hispana logro sacar un reto No-Hit, los juegos se encuentran separados en 2 listas, una lista oficial del Team Hitless y una lista con los juegos que no son oficiales en el Team Hitless.'),
                                const Text('Puedes seleccionar cualquier juego en las listas para poder ver a detalle las partidas de dicho juego.')
                              ],
                            )),
                      ),
                    ),
                child: const Icon(
                  Icons.question_mark_outlined,
                )),
          )
        ]),
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

class TapbarJuegosState extends State<TapbarJuegos> with SingleTickerProviderStateMixin {
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
    return Column(children: [
      const SizedBox(height: 5),
      _tabBarJuegos(),
      Expanded(
        child: TabBarView(controller: tabController, children: const [
          _ListaJuegos(juegosOficiales: true),
          _ListaJuegos(juegosOficiales: false),
        ]),
      ),
    ]);
  }

  Container _tabBarJuegos() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: AppTheme.decorationContainerBasic(topLeft: true, bottomLeft: true, bottomRight: true, topRight: true),
        child: TabBar(
            controller: tabController,
            labelStyle: styleTexto.titleMedium,
            labelColor: AppTheme.textoBase,
            unselectedLabelStyle: styleTexto.bodySmall,
            indicator: BoxDecoration(color: AppTheme.extra, borderRadius: BorderRadius.circular(9.5)),
            indicatorSize: TabBarIndicatorSize.tab,
            padding: const EdgeInsets.all(2),
            tabs: const [Tab(text: 'Oficiales'), Tab(text: 'No oficiales')]));
  }
}

class _ListaJuegos extends ConsumerStatefulWidget {
  final bool juegosOficiales;

  const _ListaJuegos({required this.juegosOficiales});

  @override
  TabViewJuegosState createState() => TabViewJuegosState();
}

class TabViewJuegosState extends ConsumerState<_ListaJuegos> {
  @override
  void initState() {
    super.initState();
    ref.read(juegosProvider.notifier).loadData(oficialTeamHitless: widget.juegosOficiales);
  }

  @override
  Widget build(BuildContext context) {
    final List<JuegoDto>? juegos = ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica(
        texto: "Consultando Juegos",
      );
    }

    return ListView.builder(
      itemCount: juegos.length,
      itemBuilder: (BuildContext context, int index) {
        final JuegoDto juego = juegos[index];
        return CardJuego(
            juego: juego,
            accion: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (context, animation, __) {
                    return FadeTransition(opacity: animation, child: DetalleJuego(juego: juego));
                  },
                )), posicionInversa: index.isOdd);
      },
    );

    // return GridView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 2,
    //     //mainAxisExtent: 300 //tamaño alto de cada item
    //   ),
    //   itemCount: juegos.length,
    //   shrinkWrap: true,
    //   itemBuilder: (BuildContext context, int index) {
    //     final JuegoDto juego = juegos[index];
    //     return CardJuego(
    //         juego: juego,
    //         accion: () => Navigator.of(context).push(PageRouteBuilder(
    //               pageBuilder: (context, animation, __) {
    //                 return FadeTransition(opacity: animation, child: DetalleJuego(juego: juego));
    //               },
    //             )));
    //   },
    // );
  }
}
