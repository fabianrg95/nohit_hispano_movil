class ContinenteEntity {
  final int id;
  final String nombre;

  ContinenteEntity({required this.id, required this.nombre});

  factory ContinenteEntity.fromJson(Map<String, dynamic> json) =>
      ContinenteEntity(id: json['id'], nombre: json['nombre']);
}
