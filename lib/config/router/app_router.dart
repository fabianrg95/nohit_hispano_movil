import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/screens/inicio_screen.dart';
import 'package:no_hit/presentation/views/contacto/contacto_view.dart';
import 'package:no_hit/presentation/views/views.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/inicio',
  routes: [
    GoRoute(
      path: '/inicio',
      name: InicioScreen.nombre,
      builder: (context, state) => const InicioScreen(),
    ),
    GoRoute(
      path: '/partidas',
      name: PartidasView.nombre,
      builder: (context, state) => const PartidasView(),
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
    GoRoute(
      path: '/informacion',
      name: InformacionView.nombre,
      builder: (context, state) => const InformacionView(),
    ),
    GoRoute(
      path: '/contacto',
      name: ContactoView.nombre,
      builder: (context, state) => const ContactoView(),
    ),
  ],
);
