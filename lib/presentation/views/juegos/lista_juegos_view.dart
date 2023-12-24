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
    return SafeArea(
      child: Scaffold(
        drawer: const CustomNavigation(),
        appBar: AppBar(forceMaterialTransparency: true, title: const Text('Juegos')),
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
        child: TabBarView(controller: tabController, children: const [
          _ListaJuegos(juegosOficiales: true),
          _ListaJuegos(juegosOficiales: false),
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
            indicator: BoxDecoration(color: color.tertiary, borderRadius: BorderRadius.circular(15.5)),
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<JuegoDto>? juegos = ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica(
        texto: "Consultando Juegos",
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260 //tamaño alto de cada item
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
        );
      },
    );
  }
}
