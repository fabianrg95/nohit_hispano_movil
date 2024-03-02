import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:no_hit/presentation/delegates/jugadores/buscar_jugadores_delegate.dart';
import 'package:no_hit/presentation/views/inicio/inicio_view.dart';
import 'package:no_hit/presentation/views/jugadores/jugador_view.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

class ListaJugadoresView extends ConsumerStatefulWidget {
  static const nombre = 'lista-jugadores-screen';
  const ListaJugadoresView({super.key});

  @override
  JugadoresViewState createState() => JugadoresViewState();
}

class JugadoresViewState extends ConsumerState<ListaJugadoresView> {
  List<JugadorDto> listaJugadores = [];
  List<JugadorDto> ultimosJugadores = [];
  late ColorScheme color;
  late TextTheme styleTexto;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    consultarJugadores();
    ref.read(ultimosJugadoresProvider.notifier).loadData(false);

    scrollController.addListener(() {
      if ((scrollController.position.pixels + 1000) > scrollController.position.maxScrollExtent) {
        consultarJugadores();
      }
    });
  }

  void consultarJugadores() {
    ref.read(jugadorProvider.notifier).loadData();
  }

  void recargarJugadores() {
    ref.read(jugadorProvider.notifier).reloadData();
  }

  @override
  Widget build(BuildContext context) {
    listaJugadores = ref.watch(jugadorProvider);
    ultimosJugadores = ref.watch(ultimosJugadoresProvider);
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    if (listaJugadores.isEmpty && ultimosJugadores.isEmpty) {
      return const PantallaCargaBasica(texto: 'Consultando Jugadores');
    }

    return PopScope(
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, __, ___) => const InicioView()));
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomNavigation(),
          appBar: AppBar(
            actions: [_accionBuscar(context)],
            title: Text(AppLocalizations.of(context)!.jugadores(true.toString())),
            forceMaterialTransparency: true,
          ),
          body: RefreshIndicator(
            onRefresh: () => _actualizarJugadores(),
            color: color.surfaceTint,
            backgroundColor: color.tertiary,
            child: _contenidoPagina(context),
          ),
        ),
      ),
    );
  }

  Future<void> _actualizarJugadores() async {
    setState(() {
      recargarJugadores();
      ref.read(ultimosJugadoresProvider.notifier).loadData(true);
    });
  }

  Widget _accionBuscar(BuildContext context) {
    final noHitRepository = ref.read(hitlessRepositoryProvider);

    return IconButton(
        onPressed: () {
          showSearch(
              context: context,
              delegate: BuscarJugadoresDelegate(
                buscarJugadoresCallback: noHitRepository.buscarJugadores,
                context: context,
              ));
        },
        icon: const Icon(Icons.search));
  }

  Widget _contenidoPagina(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      controller: scrollController,
      child: Column(
        children: [
          Container(
            decoration: ViewData().decorationContainerBasic(color: color),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.jugadores_nuevos, style: styleTexto.titleLarge),
                const SizedBox(height: 10),
                Divider(color: color.tertiary, thickness: 2, height: 1),
                SizedBox(
                    height: 120,
                    child: Swiper(
                      viewportFraction: 1,
                      scale: 1,
                      autoplayDelay: 5000,
                      autoplay: true,
                      pagination: SwiperPagination(
                        builder: DotSwiperPaginationBuilder(activeColor: color.tertiary, color: color.primary),
                      ),
                      itemCount: ultimosJugadores.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, __) {
                            return FadeTransition(opacity: animation, child: DetalleJugadorView(idJugador: ultimosJugadores[index].id!));
                          })),
                          child: Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  BanderaJugador(codigoBandera: ultimosJugadores[index].codigoBandera),
                                  Text(ultimosJugadores[index].nombre!, style: styleTexto.titleLarge, maxLines: 2)
                                ],
                              )),
                        );
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: listaJugadores.length,
              itemBuilder: (context, index) {
                return ItemJugador(jugador: listaJugadores[index]);
              }),
        ],
      ),
    );
  }
}
