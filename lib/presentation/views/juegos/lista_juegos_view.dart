import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJuegosView extends ConsumerWidget {
  static const nombre = 'lista-juegos-screen';

  const ListaJuegosView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final bool visualizarEnLista = ref.watch(visualListaJuegosNotifierProvider);
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        drawer: const CustomNavigation(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => ref.read(visualListaJuegosNotifierProvider.notifier).cambiarVisualizacionListaJuegos(),
          child: Icon(visualizarEnLista ? Icons.grid_view_outlined : Icons.format_list_bulleted_outlined),
        ),
        appBar: AppBar(forceMaterialTransparency: true, title: const Text('Juegos'), actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () => showModalBottomSheet(
                      context: context,
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

class TapbarJuegos extends ConsumerStatefulWidget {
  const TapbarJuegos({super.key});

  @override
  TapbarJuegosState createState() => TapbarJuegosState();
}

class TapbarJuegosState extends ConsumerState<TapbarJuegos> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool visualizarEnLista = true;
  late ColorScheme color;

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
    visualizarEnLista = ref.watch(visualListaJuegosNotifierProvider);
    color = Theme.of(context).colorScheme;

    return Column(children: [
      const SizedBox(height: 5),
      _tabBarJuegos(Theme.of(context).textTheme),
      Expanded(
        child: TabBarView(controller: tabController, children: [
          _ListaJuegos(juegosOficiales: true, verEnLista: visualizarEnLista),
          _ListaJuegos(juegosOficiales: false, verEnLista: visualizarEnLista),
        ]),
      ),
    ]);
  }

  Container _tabBarJuegos(TextTheme styleTexto) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: ViewData().decorationContainerBasic(color: color),
        child: TabBar(
            controller: tabController,
            labelStyle: styleTexto.titleMedium,
            labelColor: color.surfaceTint,
            unselectedLabelStyle: styleTexto.bodySmall,
            indicator: BoxDecoration(color: color.tertiary, borderRadius: BorderRadius.circular(9.5)),
            indicatorSize: TabBarIndicatorSize.tab,
            padding: const EdgeInsets.all(2),
            tabs: const [Tab(text: 'Oficiales'), Tab(text: 'No oficiales')]));
  }
}

class _ListaJuegos extends ConsumerStatefulWidget {
  final bool juegosOficiales;
  final bool verEnLista;

  const _ListaJuegos({required this.juegosOficiales, required this.verEnLista});

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

    if (widget.verEnLista) {
      return ListView.builder(
        itemCount: juegos.length,
        itemBuilder: (BuildContext context, int index) {
          final JuegoDto juego = juegos[index];
          return CardJuego(
            juego: juego,
            accion: () => Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, __) {
                return FadeTransition(
                    opacity: animation,
                    child: DetalleJuego(
                      juego: juego,
                      heroTag: juego.id.toString(),
                    ));
              },
            )),
            posicionInversa: index.isOdd,
            visualizacionMinima: !widget.verEnLista,
          );
        },
      );
    } else {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          //mainAxisExtent: 300 //tamaño alto de cada item
        ),
        itemCount: juegos.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final JuegoDto juego = juegos[index];
          return CardJuego(
            juego: juego,
            accion: () => Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, __) {
                return FadeTransition(
                    opacity: animation,
                    child: DetalleJuego(
                      juego: juego,
                      heroTag: juego.nombre + (juego.subtitulo == null ? juego.subtitulo.toString() : juego.id.toString()),
                    ));
              },
            )),
            visualizacionMinima: !widget.verEnLista,
          );
        },
      );
    }
  }
}
