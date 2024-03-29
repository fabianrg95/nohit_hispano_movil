import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';
import 'package:no_hit/main.dart';
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
  List<NacionalidadDto> nacionalidades = [];
  List<GeneroDto> generos = [];

  List<int> nacionalidadesSeleccionadas = [];
  List<int> generosSeleccionados = [];

  late PersistentBottomSheetController bottomSheetController;

  late ColorScheme color;
  late TextTheme styleTexto;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    consultarJugadores();
    ref.read(ultimosJugadoresProvider.notifier).loadData(false);

    scrollController.addListener(() {
      if (nacionalidadesSeleccionadas.isEmpty && generosSeleccionados.isEmpty) {
        if ((scrollController.position.pixels + 1000) > scrollController.position.maxScrollExtent) {
          consultarJugadores();
        }
      }
    });
  }

  void consultarJugadores() {
    ref.read(jugadorProvider.notifier).loadData(null);
  }

  void filtrarJugadores() {
    FiltroJugadoresDto? filtroJugadoresDto = FiltroJugadoresDto(listaNacionalidades: nacionalidadesSeleccionadas, listaGeneros: generosSeleccionados);
    if (nacionalidadesSeleccionadas.isEmpty && generosSeleccionados.isEmpty) {
      ref.read(jugadorProvider.notifier).reloadData();
    } else {
      ref.read(jugadorProvider.notifier).loadData(filtroJugadoresDto);
    }
  }

  void recargarJugadores() {
    ref.read(jugadorProvider.notifier).reloadData();
  }

  @override
  Widget build(BuildContext context) {
    listaJugadores = ref.watch(jugadorProvider);
    ultimosJugadores = ref.watch(ultimosJugadoresProvider);
    nacionalidades = ref.watch(nacionalidadProvider);
    generos = ref.watch(generoProvider);

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
          endDrawer: _filtroJugadores(),
          floatingActionButton: Builder(builder: (context) {
            return TextButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              style: TextButton.styleFrom(backgroundColor: color.tertiary),
              child: const Icon(
                Icons.filter_alt_outlined,
                size: 25,
                weight: 0.1,
              ),
            );
          }),
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
                      fade: 0.1,
                      outer: true,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Divider(),
          ),
          Text(AppLocalizations.of(context)!.lista_completa, style: styleTexto.titleMedium),
          Visibility(
            visible: listaJugadores.isNotEmpty,
            replacement: Text(AppLocalizations.of(context)!.jugadores_vacio),
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listaJugadores.length,
                itemBuilder: (context, index) {
                  return ItemJugador(jugador: listaJugadores[index]);
                }),
          ),
        ],
      ),
    );
  }

  Widget _filtroJugadores() {
    final ColorScheme color = Theme.of(context).colorScheme;
    final TextTheme styleTexto = Theme.of(context).textTheme;

    return Drawer(
      width: size.width * 0.9,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(child: Text(AppLocalizations.of(context)!.filtros, style: styleTexto.titleLarge)),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Divider(color: color.tertiary.withOpacity(0.5), thickness: 2, height: 1),
          ),
          const SizedBox(height: 20),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Text(
                    AppLocalizations.of(context)!.nacionalidad,
                    style: styleTexto.titleMedium,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nacionalidades.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(nacionalidades[index].pais!),
                      dense: true,
                      onTap: () => seleccionarNacionalidad(null, nacionalidades, index),
                      trailing: Checkbox(
                        value: nacionalidadesSeleccionadas.contains(nacionalidades[index].id!),
                        activeColor: color.tertiary,
                        onChanged: (value) {
                          seleccionarNacionalidad(value, nacionalidades, index);
                        },
                      ),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.generos,
                    style: styleTexto.titleMedium,
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: generos.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(generos[index].genero!),
                      dense: true,
                      onTap: () => seleccionarGenero(null, generos, index),
                      trailing: Checkbox(
                        value: generosSeleccionados.contains(generos[index].id!),
                        activeColor: color.tertiary,
                        onChanged: (value) {
                          seleccionarGenero(value, generos, index);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: color.tertiary),
                    onPressed: () {
                      limpiarFiltros();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.limpiar_filtros),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextButton(
                    style: TextButton.styleFrom(backgroundColor: color.tertiary),
                    onPressed: () {
                      aplicarFiltros();
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.aplicar_filtros),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void seleccionarNacionalidad(bool? value, List<NacionalidadDto> nacionalidades, int index) {
    setState(() {
      if (value == null) {
        if (nacionalidadesSeleccionadas.contains(nacionalidades[index].id!)) {
          value == false;
        } else {
          value = true;
        }
      }

      if (value == true) {
        nacionalidadesSeleccionadas.add(nacionalidades[index].id!);
      } else {
        nacionalidadesSeleccionadas.remove(nacionalidades[index].id!);
      }
    });
  }

  void seleccionarGenero(bool? value, List<GeneroDto> generos, int index) {
    setState(() {
      if (value == null) {
        if (generosSeleccionados.contains(generos[index].id!)) {
          value == false;
        } else {
          value = true;
        }
      }

      if (value == true) {
        generosSeleccionados.add(generos[index].id!);
      } else {
        generosSeleccionados.remove(generos[index].id!);
      }
    });
  }

  void aplicarFiltros() {
    setState(() {
      filtrarJugadores();
    });
  }

  void limpiarFiltros() {
    setState(() {
      nacionalidadesSeleccionadas = [];
      generosSeleccionados = [];
      filtrarJugadores();
    });
  }
}
