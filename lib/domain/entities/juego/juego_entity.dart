class JuegoEntity {
  final int id;
  final String nombre;
  final String? subtitulo;
  final String? urlImagen;
  final bool? oficialTeamHitless;

  JuegoEntity({required this.id, required this.nombre, this.subtitulo, this.urlImagen, this.oficialTeamHitless});

  factory JuegoEntity.fromJson(Map<String, dynamic> json) => JuegoEntity(
      id: json['id'],
      nombre: json['nombre'],
      oficialTeamHitless: json['oficial_team_hitless'],
      subtitulo: json['subtitulo'],
      urlImagen: json['url_imagen']);
}
