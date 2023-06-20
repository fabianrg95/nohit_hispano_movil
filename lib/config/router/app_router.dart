import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/views/partidas/partidas_view.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/partidas',
  routes: [
    GoRoute(
      path: '/partidas',
      name: PartidasView.nombre,
      builder: (context, state) => const PartidasView(),
    ),

    // GoRoute(
    //   path: '/buttons',
    //   name: ButtonsScreen.name,
    //   builder: (context, state) => const ButtonsScreen(),
    // ),

    // GoRoute(
    //   path: '/cards',
    //   name: CardsScreen.name,
    //   builder: (context, state) => const CardsScreen(),
    // ),

    // GoRoute(
    //   path: '/progess',
    //   name: ProgressScreen.name,
    //   builder: (context, state) => const ProgressScreen(),
    // ),

    //  GoRoute(
    //   path: '/animated',
    //   name: AnimatedScreen.name,
    //   builder: (context, state) => const AnimatedScreen(),
    // ),

    //  GoRoute(
    //   path: '/tutorial',
    //   name: AppTutorialScreen.name,
    //   builder: (context, state) => const AppTutorialScreen(),
    // ),

    //  GoRoute(
    //   path: '/infinite-scroll',
    //   name: InfiniteScrollScreen.name,
    //   builder: (context, state) => const InfiniteScrollScreen(),
    // ),

    //  GoRoute(
    //   path: '/snackbar',
    //   name: SnackbarScreen.name,
    //   builder: (context, state) => const SnackbarScreen(),
    // ),

    //  GoRoute(
    //   path: '/ui-controls',
    //   name: UiControlsScreen.name,
    //   builder: (context, state) => const UiControlsScreen(),
    // ),
  ],
);
