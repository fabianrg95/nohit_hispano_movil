import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/infraestructure/providers/hitless_repository_provider.dart';
import 'package:no_hit/infraestructure/repositories/local_repository_impl.dart';

final introduccionProvider = StateNotifierProvider<IntroduccionNotifier, bool>((ref) {
  final localRepository = ref.watch(localRepositoryProvider);
  return IntroduccionNotifier(localRepository);
});

typedef GetIntroduccionFinalizadaCallback = Future<bool> Function();

// Controller o Notifier
class IntroduccionNotifier extends StateNotifier<bool> {
  LocalRepositoryImpl localStorage;

  IntroduccionNotifier(this.localStorage) : super(false);

  void cargarIntroduccionFinalizada() async {
    bool introduccionFinalizada = await localStorage.obtenerIntroduccionFinalizada();
    state = introduccionFinalizada;
  }

  void introduccionFinalizada() {
    localStorage.guardarIntroduccionFinalizada(true);
    state = true;
  }
}
