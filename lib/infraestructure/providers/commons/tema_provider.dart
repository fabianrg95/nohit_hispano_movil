import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';
import 'package:no_hit/infraestructure/providers/hitless_repository_provider.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  return ThemeNotifier(localRepository);
});

typedef GetTemaClaroSeleccionadoCallback = Future<bool> Function();

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  LocalRepositoryImpl localStorage;

  ThemeNotifier(this.localStorage) : super(AppTheme());

  void cargarTemaSeleccionado() async {
    bool isDarkmode2 = await localStorage.obtenerEsTemaClaro();
    print('cargar tema seleccionado $isDarkmode2');
    state = AppTheme(esTemaClaro: isDarkmode2);
  }

  void toggleDarkmode() {
    bool temaClaroSeleccinado = !state.esTemaClaro;
    localStorage.guardarEsTemaClaro(temaClaroSeleccinado);
    state = state.copyWith(isDarkmode: temaClaroSeleccinado);
  }
}
