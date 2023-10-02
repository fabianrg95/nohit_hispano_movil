import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/screens/inicio_screen.dart';
import 'package:no_hit/presentation/views/juegos/lista_juegos_view.dart';
// import 'package:no_hit/presentation/screens/inicio_screen.dart';
// import 'package:no_hit/presentation/views/juegos/juegos_view.dart';
import 'package:no_hit/presentation/views/jugadores/lista_jugadores_view.dart';

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
      name: ListaJuegosView.nombre,
      builder: (context, state) => const ListaJuegosView(),
    ),
    GoRoute(
      path: '/jugadores',
      name: ListaJugadoresView.nombre,
      builder: (context, state) => const ListaJugadoresView(),
    ),
  ],
);
