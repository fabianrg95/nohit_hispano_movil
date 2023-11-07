import 'package:flutter_riverpod/flutter_riverpod.dart';

final visualListaJuegosNotifierProvider = StateNotifierProvider<VisualizacionListaJuegos, bool>(
  (ref) => VisualizacionListaJuegos(),
);

// Controller o Notifier
class VisualizacionListaJuegos extends StateNotifier<bool> {
  // STATE = Estado = new AppTheme();
  VisualizacionListaJuegos() : super(true);

  void cambiarVisualizacionListaJuegos() {
    state = !state;
  }
}
