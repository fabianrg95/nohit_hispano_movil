class PronombreEntity {
  final int? id;
  final String? pronombre;
  final String? genero;

  PronombreEntity({
    this.id,
    this.pronombre,
    this.genero,
  });

  factory PronombreEntity.fromJson(Map<String, dynamic> json) => PronombreEntity(
        id: json['id'],
        pronombre: json['pronombre'],
        genero: json['genero'],
      );
}
