import 'package:go_router/go_router.dart';
import 'package:no_hit/infraestructure/enums/enums.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/inicio',
  routes: MenuItem.obtenerRutas(),
);
