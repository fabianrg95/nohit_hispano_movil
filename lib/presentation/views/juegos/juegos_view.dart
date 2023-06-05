import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/presentation/providers/providers.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/commons/pantalla_carga_basica.dart';

class JuegosView extends StatefulWidget {
  static const nombre = 'juegos-screen';

  const JuegosView({super.key});

  @override
  State<JuegosView> createState() => _JuegosViewState();
}

class _JuegosViewState extends State<JuegosView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return const Scaffold(
      body: SafeArea(
        child: TapbarJuegos(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: Text(
          'Juegos',
          style: tema.textTheme.titleLarge
              ?.copyWith(color: tema.colorScheme.primary),
        ),centerTitle: true,),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 112,
              child: Column(children: [
                const SizedBox(height: 5),
                Container(
                    width: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: tema.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(children: [
                      Padding(
                          padding: const EdgeInsets.all(0),
                          child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelColor: tema.colorScheme.inversePrimary,
                              indicator: BoxDecoration(
                                  color: tema.indicatorColor,
                                  borderRadius: BorderRadius.circular(10)),
                              controller: tabController,
                              tabs: const [
                                Tab(text: 'Oficiales'),
                                Tab(text: 'No oficiales')
                              ]))
                    ])),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(controller: tabController, children: const [
                    TabViewJuegos(juegosOficiales: true),
                    TabViewJuegos(juegosOficiales: false)
                  ]),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

class TabViewJuegos extends ConsumerStatefulWidget {
  final bool juegosOficiales;

  const TabViewJuegos({super.key, required this.juegosOficiales});

  @override
  TabViewJuegosState createState() => TabViewJuegosState();
}

class TabViewJuegosState extends ConsumerState<TabViewJuegos> {
  @override
  void initState() {
    super.initState();
    ref
        .read(juegosProvider.notifier)
        .loadData(oficialTeamHitless: widget.juegosOficiales);
  }

  @override
  Widget build(BuildContext context) {
    final List<Juego>? juegos =
        ref.watch(juegosProvider)[widget.juegosOficiales];

    if (juegos == null) {
      return const PantallaCargaBasica();
    }

    return MasonryGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemCount: juegos.length,
      itemBuilder: (BuildContext context, int index) {
        final juego = juegos[index];
        return _CardJuego(
          juego: juego,
          accion: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetalleJuego(juego: juego))),
        );
      },
    );
  }
}

class _CardJuego extends StatelessWidget {
  final Juego juego;
  final Function accion;

  const _CardJuego({
    required this.juego,
    required this.accion,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return GestureDetector(
      onTap: () => accion(),
      child: Container(
        decoration: BoxDecoration(
            color: tema.cardColor, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            _ImagenJuego(juego: juego, existeUrl: juego.urlImagen != null),
          ],
        ),
      ),
    );
  }
}

class _ImagenJuego extends StatelessWidget {
  final Juego juego;
  final bool existeUrl;

  const _ImagenJuego({
    required this.juego,
    this.existeUrl = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: existeUrl
            ? Image.network(
                juego.urlImagen!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress != null) {
                    return SizedBox(
                      width: (size.width * 0.3) - 40,
                      height: 120,
                      child: Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            Text(juego.nombre)
                          ],
                        ),
                      ),
                    );
                  }

                  return child;
                },
              )
            : Image.asset('assets/images/no-game-image.webp',
                fit: BoxFit.cover),
      ),
    );
  }
}
