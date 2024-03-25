import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class GeneroMapper {
  static GeneroDto entityToDtoBasico(final PronombreEntity entity) => GeneroDto(id: entity.id, genero: '${entity.genero} - ${entity.pronombre}');
}
