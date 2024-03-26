enum BoxLocal {
  temaSeleccinado(nombreAlmacenamiento: 'TemaSeleccionadoBox', llaveAlmacenamiento: 'temaSeleccionadoKey'),
  introduccionFinalizada(nombreAlmacenamiento: 'IntroduccionFinalizadaBox', llaveAlmacenamiento: 'IntroduccionFinalizadaKey'),
  jugadoresFavoritos(nombreAlmacenamiento: 'JugadoresFavoritosBox', llaveAlmacenamiento: 'JugadoresFavoritosKey');

  final String nombreAlmacenamiento;
  final String llaveAlmacenamiento;

  const BoxLocal({required this.nombreAlmacenamiento, required this.llaveAlmacenamiento});
}
