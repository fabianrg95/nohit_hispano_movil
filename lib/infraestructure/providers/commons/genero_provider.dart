import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';
import 'package:no_hit/infraestructure/mapper/commons/genero_mapper.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final generoProvider = StateNotifierProvider<GeneroNotifier, List<GeneroDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return GeneroNotifier(hitlessRepository.obtenerPronombres);
});

typedef GetGeneroCallback = Future<List<PronombreEntity>> Function();

class GeneroNotifier extends StateNotifier<List<GeneroDto>> {
  GetGeneroCallback obtenerGeneros;

  GeneroNotifier(this.obtenerGeneros) : super([]);

  Future<void> loadData() async {
    if (state.isEmpty) {
      final List<PronombreEntity> pronombres = await obtenerGeneros();
      for (var element in pronombres) {
        state = [...state, GeneroMapper.entityToDtoBasico(element)];
      }
    }
  }
}
