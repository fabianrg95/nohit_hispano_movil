enum BoxLocal {
  temaSeleccinado(nombreAlmacenamiento: 'TemaSeleccionadoBox', llaveAlmacenamiento: 'temaSeleccionadoKey');

  final String nombreAlmacenamiento;
  final String llaveAlmacenamiento;

  const BoxLocal({required this.nombreAlmacenamiento, required this.llaveAlmacenamiento});
}
