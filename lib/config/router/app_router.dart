import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/screens/inicio_screen.dart';
import 'package:no_hit/presentation/views/juegos/juegos_view.dart';
import 'package:no_hit/presentation/views/jugadores/jugadores_view.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/partidas',
  routes: [
    GoRoute(
      path: '/partidas',
      name: InicioScreen.nombre,
      builder: (context, state) => const InicioScreen(),
    ),
    GoRoute(
      path: '/juegos',
      name: JuegosView.nombre,
      builder: (context, state) => const JuegosView(),
    ),
    GoRoute(
      path: '/jugadores',
      name: JugadoresView.nombre,
      builder: (context, state) => const JugadoresView(),
    ),
  ],
);
