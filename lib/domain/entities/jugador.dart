class Jugador {
  final int id;
  final String nombre;
  final String pronombre;
  final String pais;
  final String? codigoBandera;
  final String? continente;
  final int cantidadPartidas;

  Jugador(
      {required this.id,
      required this.nombre,
      required this.pronombre,
      required this.pais,
      this.continente,
      required this.cantidadPartidas,
      this.codigoBandera});
}
