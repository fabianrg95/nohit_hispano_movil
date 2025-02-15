import 'package:no_hit/domain/entities/entities.dart';
import 'package:no_hit/infraestructure/dto/dtos.dart';

class NacionalidadMapper {
  static NacionalidadDto entityToDtoBasico(final NacionalidadEntity entity) =>
      NacionalidadDto(id: entity.id, pais: entity.pais, codigoBandera: entity.codigoBandera);
}
