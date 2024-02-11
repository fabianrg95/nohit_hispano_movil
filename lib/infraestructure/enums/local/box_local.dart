enum BoxLocal {
  temaSeleccinado(nombreAlmacenamiento: 'TemaSeleccionadoBox', llaveAlmacenamiento: 'temaSeleccionadoKey'),
  introduccionFinalizada(nombreAlmacenamiento: 'IntroduccionFinalizadaBox', llaveAlmacenamiento: 'IntroduccionFinalizadaKey');

  final String nombreAlmacenamiento;
  final String llaveAlmacenamiento;

  const BoxLocal({required this.nombreAlmacenamiento, required this.llaveAlmacenamiento});
}
