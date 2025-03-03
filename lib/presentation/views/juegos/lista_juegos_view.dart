import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/delegates/juegos/buscar_juego_delegate.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class ListaJuegosView extends ConsumerWidget {
  static const nombre = 'lista-juegos-screen';

  const ListaJuegosView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [accionBuscar(context, ref)],
            title: Text(AppLocalizations.of(context)!.juegos(true.toString())),
            forceMaterialTransparency: true,
          ),
          drawer: const CustomNavigation(),
          body: const TapbarJuegos(),
        ),
      ),
    );
  }

  Widget accionBuscar(BuildContext context, ref) {
    final noHitRepository = ref.read(hitlessRepositoryProvider);

    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: BuscarJuegoDelegate(buscarJuegosCallback: noHitRepository.buscarJuegos, context: context, ref: ref));
        },
        icon: const Icon(Icons.search));
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
  late TextTheme styleTexto;

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
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

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

  void recargarJugadores() {
    ref.read(juegosProvider.notifier).reloadData(oficialTeamHitless: widget.juegosOficiales);
  }

  Future<void> _actualizarJuegos(bool juegosOficiales) async {
    setState(() {
      recargarJugadores();
      ref.read(juegosProvider.notifier).loadData(oficialTeamHitless: juegosOficiales);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final List<JuegoDto>? juegos = ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica(
        texto: "Consultando Juegos",
      );
    }

    return RefreshIndicator(
      onRefresh: () => _actualizarJuegos(widget.juegosOficiales),
      color: color.surfaceTint,
      backgroundColor: color.tertiary,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260),
        itemCount: juegos.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final JuegoDto juego = juegos[index];
          return CardJuego(juego: juego, accion: () => navegarJuego(context, juego, ref));
        },
      ),
    );
  }
}

Future<dynamic> navegarJuego(final BuildContext context, final JuegoDto juego, WidgetRef ref) {
  const duration = Duration(milliseconds: 500);

  ref.read(informacionJuegoProvider.notifier).saveData(juegoDto: juego);

  return Navigator.of(context).push(PageRouteBuilder(
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    pageBuilder: (context, __, ___) => DetalleJuego(idJuego: juego.id, heroTag: 'Juego-${juego.id}'),
    transitionsBuilder: (_, animation, ___, child) => FadeTransition(opacity: animation, child: child),
  ));
}
