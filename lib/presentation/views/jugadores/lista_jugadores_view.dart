import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/presentation/delegates/jugadores/buscar_jugadores_delegate.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(jugadorProvider.notifier).loadData(false);
    ref.read(ultimosJugadoresProvider.notifier).loadData(false);
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
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        context.go(MenuItem.inicio.link);
      },
      child: SafeArea(
        child: Scaffold(
          drawer: const CustomNavigation(),
          appBar: AppBar(
            actions: [_accionBuscar(context)],
            title: const Text('Jugadores'),
            forceMaterialTransparency: true,
          ),
          body: RefreshIndicator(
              onRefresh: () => _actualizarPartidas(), color: color.surfaceTint, backgroundColor: color.tertiary, child: _contenidoPagina()),
        ),
      ),
    );
  }

  Future<void> _actualizarPartidas() async {
    setState(() {
      ref.read(jugadorProvider.notifier).loadData(true);
      ref.read(ultimosJugadoresProvider.notifier).loadData(true);
    });
  }

  Widget _accionBuscar(BuildContext context) {
    return IconButton(
        onPressed: () {
          showSearch(
              context: context,
              delegate: BuscarJugadoresDelegate(
                listaInicial: ref.watch(jugadorProvider),
              ));
        },
        icon: const Icon(Icons.search));
  }

  Widget _contenidoPagina() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            decoration: ViewData().decorationContainerBasic(color: color),
            margin: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text('Jugadores nuevos', style: styleTexto.titleLarge),
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
