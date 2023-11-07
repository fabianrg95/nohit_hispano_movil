import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/config/theme/app_theme.dart';

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>(
  (ref) => ThemeNotifier(),
);

// Controller o Notifier
class ThemeNotifier extends StateNotifier<AppTheme> {
  // STATE = Estado = new AppTheme();
  ThemeNotifier() : super(AppTheme());

  void toggleDarkmode() {
    state = state.copyWith(isDarkmode: !state.esTemaClaro);
  }
}
