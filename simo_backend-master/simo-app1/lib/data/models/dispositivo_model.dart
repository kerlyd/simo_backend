class DispositivoModel {
  final dynamic id;
  final String nombre;
  final String? descripcion;
  final int puntos;

  DispositivoModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.puntos,
  });

  factory DispositivoModel.fromJson(Map<String, dynamic> json) {
    return DispositivoModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      puntos: (json['puntos'] is int)
          ? json['puntos']
          : int.tryParse(json['puntos']?.toString() ?? '0') ?? 0,
    );
  }
}
