import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/commons/nacionalidad_dto.dart';
import 'package:no_hit/infraestructure/mapper/commons/nacionaludad_mapper.dart';
import 'package:no_hit/infraestructure/providers/providers.dart';

final nacionalidadProvider = StateNotifierProvider<NacionalidadNotifier, List<NacionalidadDto>>((ref) {
  final hitlessRepository = ref.watch(hitlessRepositoryProvider);
  return NacionalidadNotifier(hitlessRepository.obtenerNacionalidades);
});

typedef GetnacionaludadCallback = Future<List<NacionalidadEntity>> Function();

class NacionalidadNotifier extends StateNotifier<List<NacionalidadDto>> {
  GetnacionaludadCallback obtenerNacionalidades;

  NacionalidadNotifier(this.obtenerNacionalidades) : super([]);

  Future<void> loadData() async {
    if (state.isEmpty) {
      final List<NacionalidadEntity> nacionalidades = await obtenerNacionalidades();
      for (var element in nacionalidades) {
        state = [...state, NacionalidadMapper.entityToDtoBasico(element)];
      }
    }
  }
}
