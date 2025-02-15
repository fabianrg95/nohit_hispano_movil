import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:no_hit/infraestructure/dto/juego/juego_dto.dart';
import 'package:no_hit/infraestructure/dto/jugador/jugador_dto.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class FavoritosView extends ConsumerWidget {
  static const nombre = 'favoritos-screen';

  const FavoritosView({super.key});

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
            title: Text(AppLocalizations.of(context)!.favoritos),
            forceMaterialTransparency: true,
          ),
          drawer: const CustomNavigation(),
          body: const TapbarFavoritos(),
        ),
      ),
    );
  }
}

class TapbarFavoritos extends ConsumerStatefulWidget {
  const TapbarFavoritos({super.key});

  @override
  TapbarFavoritosState createState() => TapbarFavoritosState();
}

class TapbarFavoritosState extends ConsumerState<TapbarFavoritos> with SingleTickerProviderStateMixin {
  late TabController tabController;
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
      _tabBarFavoritos(),
      Expanded(
        child: TabBarView(controller: tabController, children: const [
          _ListaJugadoresFavoritos(),
          _ListaJuegosFavoritos(),
        ]),
      ),
    ]);
  }

  Container _tabBarFavoritos() {
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
            tabs: [Tab(text: AppLocalizations.of(context)!.jugadores('true')), Tab(text: AppLocalizations.of(context)!.juegos('true'))]));
  }
}

class _ListaJugadoresFavoritos extends ConsumerStatefulWidget {
  const _ListaJugadoresFavoritos();

  @override
  ListaJugadoresFavoritosState createState() => ListaJugadoresFavoritosState();
}

class ListaJugadoresFavoritosState extends ConsumerState<_ListaJugadoresFavoritos> {
  @override
  void initState() {
    super.initState();
    ref.read(jugadoresFavoritosProvider.notifier).loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> recargarJugadores() async {
    setState(() {
      ref.read(jugadoresFavoritosProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final List<JugadorDto>? jugadores = ref.watch(jugadoresFavoritosProvider);

    if (jugadores == null) {
      return const PantallaCargaBasica(
        texto: "Consultando jugadores Favoritos",
      );
    }

    return RefreshIndicator(
      onRefresh: () => recargarJugadores(),
      color: color.surfaceTint,
      backgroundColor: color.tertiary,
      child: SizedBox.expand(
        child: Visibility(
          visible: jugadores.isNotEmpty,
          replacement: Center(child: Text(AppLocalizations.of(context)!.jugadores_favoritos_vacio)),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                JugadorDto jugador = jugadores[index];
                return FadeIn(
                    child: ItemJugador(
                  jugador: jugador,
                  accion: () => navegarJugador(context, jugador.id!).then((value) => recargarJugadores()),
                ));
              }),
        ),
      ),
    );
  }
}

class _ListaJuegosFavoritos extends ConsumerStatefulWidget {
  const _ListaJuegosFavoritos();

  @override
  ListaJuegosFavoritosState createState() => ListaJuegosFavoritosState();
}

class ListaJuegosFavoritosState extends ConsumerState<_ListaJuegosFavoritos> {
  @override
  void initState() {
    super.initState();
    ref.read(juegosFavoritosProvider.notifier).loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> recargarJuegos() async {
    ref.read(juegosFavoritosProvider.notifier).loadData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    final List<JuegoDto>? juegos = ref.watch(juegosFavoritosProvider);

    if (juegos == null) {
      return const PantallaCargaBasica(
        texto: "Consultando juegos favoritos",
      );
    }

    return RefreshIndicator(
      onRefresh: () => recargarJuegos(),
      color: color.surfaceTint,
      backgroundColor: color.tertiary,
      child: SizedBox.expand(
        child: Visibility(
          visible: juegos.isNotEmpty,
          replacement: Center(child: Text(AppLocalizations.of(context)!.juegos_favoritos_vacio)),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisExtent: 260),
            itemCount: juegos.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final JuegoDto juego = juegos[index];
              return FadeIn(
                  child: CardJuego(
                      juego: juego,
                      accion: () {
                        navegarJuego(context, juego, ref).then((value) => recargarJuegos());
                      }));
            },
          ),
        ),
      ),
    );
  }
}
