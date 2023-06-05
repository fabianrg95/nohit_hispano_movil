import 'package:no_hit/domain/entities/entities.dart';

class JuegoMapper {
  static List<Juego> supabaseToEntity(List<Map<String, dynamic>> respuesta) {
    final List<Juego> juegos = [];
    for (var element in respuesta) {
      juegos.add(Juego(
          id: element['id'],
          nombre: element['nombre'],
          oficialTeamHitles: element['oficial_team_hitless'],
          urlImagen: element['url_imagen']));
    }
    return juegos;
  }
}
