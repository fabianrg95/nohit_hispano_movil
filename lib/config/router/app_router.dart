import 'package:go_router/go_router.dart';
import 'package:no_hit/presentation/screens/inicio_screen.dart';

final appRouter = GoRouter(initialLocation: '/inicio/1', routes: [
  GoRoute(
      path: '/inicio/:page',
      name: InicioScreen.nombre,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '1');

        return InicioScreen(pageIndex: pageIndex);
      }),
  GoRoute(
    path: '/',
    redirect: (_, __) => '/inicio/1',
  ),
]);
