import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/helpers/app_info.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

import 'package:no_hit/presentation/views/introduccion/introduccion_view.dart';
import 'package:no_hit/presentation/views/views.dart';
import 'package:no_hit/presentation/widgets/widgets.dart';

import '../../../l10n/app_localizations.dart';

class InicioView extends ConsumerStatefulWidget {
  static const nombre = 'inicio_view';

  const InicioView({super.key});

  @override
  InicioViewState createState() => InicioViewState();
}

class InicioViewState extends ConsumerState<InicioView> with SingleTickerProviderStateMixin {
  int totalJugadores = 0;
  int totalPartidas = 0;
  int totalJuegos = 0;
  late bool esTemaClaro;
  late bool introduccionFinalizada;

  late ColorScheme color;
  late TextTheme styleTexto;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward(from: 0.0);

    _actualizarConteos();
  }

  Future<void> _actualizarConteos({bool reload = false}) async {
    setState(() {
      ref.read(totalJugadoresProvider.notifier).loadData(reload);
      ref.read(totalPartidasProvider.notifier).loadData(reload);
      ref.read(totalJuegosProvider.notifier).loadData(reload);
      _controller.reset();
      _controller.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    styleTexto = Theme.of(context).textTheme;

    totalJugadores = ref.watch(totalJugadoresProvider);
    totalPartidas = ref.watch(totalPartidasProvider);
    totalJuegos = ref.watch(totalJuegosProvider);
    esTemaClaro = ref.watch(themeNotifierProvider).esTemaClaro;
    introduccionFinalizada = ref.watch(introduccionProvider);

    if (totalJugadores != 0 && totalPartidas != 0 && totalJuegos != 0) {
      FlutterNativeSplash.remove();
    }

    if (introduccionFinalizada == false) {
      return const IntroduccionView();
    } else {
      return PopScope(
        canPop: false,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
            ),
            extendBodyBehindAppBar: true,
            drawer: const CustomNavigation(),
            body: RefreshIndicator(
                onRefresh: () => _actualizarConteos(reload: true),
                color: color.surfaceTint,
                backgroundColor: color.tertiary,
                child: contenido(totalJugadores, totalPartidas, context)),
          ),
        ),
      );
    }
  }

  Widget contenido(final int cantidadTotalJugadores, final int cantidadTotalPartidas, BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: AppInfo().alto - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
        child: Column(
          children: [
            const Expanded(flex: 2, child: SizedBox(height: 1)),
            Hero(
                tag: "headerNoHit",
                child: Image.asset('assets/images/panel_${color.brightness == Brightness.dark ? 'blanco' : 'negro'}.png',
                    height: AppInfo().porcentajeAncho(0.6))),
            const Expanded(flex: 3, child: SizedBox(height: 1)),
            _informacionHispano(context),
          ],
        ),
      ),
    );
  }

  Widget _informacionHispano(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // First row - Partidas (full width)
            _buildActionCard(
              context: context,
              count: totalPartidas,
              label: AppLocalizations.of(context)!.partidas('true').toUpperCase(),
              icon: Icons.workspace_premium_rounded,
              color: color.tertiary,
              onTap: () => _navigateTo(const PartidasView()),
            ),
            const SizedBox(height: 16),

            // Second row - Jugadores and Juegos
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    count: totalJugadores,
                    label: AppLocalizations.of(context)!.jugadores('true').toUpperCase(),
                    icon: Icons.people_alt_rounded,
                    color: color.tertiary,
                    onTap: () => _navigateTo(const ListaJugadoresView()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context: context,
                    count: totalJuegos,
                    label: AppLocalizations.of(context)!.juegos('true').toUpperCase(),
                    icon: Icons.sports_esports_rounded,
                    color: color.tertiary,
                    onTap: () => _navigateTo(const ListaJuegosView()),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Third row - Preguntas Frecuentes and Tema
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: _buildActionCard(
                    context: context,
                    label: AppLocalizations.of(context)!.preguntas_frecuentes.toUpperCase(),
                    icon: Icons.help_outline_rounded,
                    color: color.tertiary,
                    textColor: color.tertiary,
                    onTap: () => _navigateTo(const PreguntasFrecuentesView()),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildThemeToggle(context, isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    int? count,
    required String label,
    required IconData icon,
    required Color color,
    Color? textColor,
    required VoidCallback onTap,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final isSmall = MediaQuery.of(context).size.width < 350;

    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: isSmall ? 20 : 24),
                  ),
                  if (count != null) ...[
                    const Spacer(),
                    Column(
                      children: [
                        AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) => Text((count * _controller.value).toInt().toString(),
                                style: TextStyle(color: color, fontSize: AppInfo().porcentajeAncho(0.08)))),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: textTheme.labelLarge?.copyWith(
                      color: textColor ?? color,
                      letterSpacing: 0.5,
                      fontSize: isSmall ? 10 : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (count != null) Icon(Icons.arrow_forward_ios, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, bool isDark) {
    final color = Theme.of(context).colorScheme;

    return Material(
      color: color.tertiary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ref.read(themeNotifierProvider.notifier).toggleDarkmode();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.outline.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                color: color.onTertiary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                isDark ? 'Claro' : 'Oscuro',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color.onTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: page,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  GestureDetector contenedorInformativoLink(BuildContext context, int cantidad, String dato, Widget destino) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, animation, ___) => FadeTransition(opacity: animation, child: destino))),
      child: contenedorInformativo(context, totalPartidas, dato),
    );
  }

  Container contenedorInformativo(BuildContext context, int cantidad, String dato) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      width: AppInfo().porcentajeAncho(0.45),
      decoration: ViewData().decorationContainerBasic(color: color),
      child: Column(
        children: [
          AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => Text((cantidad * _controller.value).toInt().toString(),
                  style: TextStyle(color: color.outline, fontSize: AppInfo().porcentajeAncho(0.08)))),
          Text(dato, style: styleTexto.titleMedium),
        ],
      ),
    );
  }
}
