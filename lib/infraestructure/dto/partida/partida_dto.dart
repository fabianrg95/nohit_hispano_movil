class PartidaDto {
  final int id;
  final int idJuego;
  final int idJugador;
  final String? tituloJuego;
  final String? subtituloJuego;
  final String? nombre;
  final String? fecha;
  final String? nombreJugador;
  bool? primeraPartidaJugador;
  bool? primeraPartidaHispano;
  bool? primeraPartidaMundo;
  String? urlImagenJuego;
  List<String> listaVideosCompletos = [];
  List<String> listaVideosClips = [];

  PartidaDto(
      {required this.id,
      required this.idJuego,
      required this.idJugador,
      this.tituloJuego,
      this.subtituloJuego,
      this.nombre,
      this.fecha,
      this.nombreJugador,
      this.primeraPartidaHispano = false,
      this.primeraPartidaJugador = false,
      this.primeraPartidaMundo = false,
      this.urlImagenJuego});
}
