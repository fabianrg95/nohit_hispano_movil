class Juego {
  final int id;
  final String nombre;
  final String? urlImagen;
  final bool oficialTeamHitles;

  Juego(
      {required this.id,
      required this.nombre,
      this.urlImagen,
      required this.oficialTeamHitles});
}
