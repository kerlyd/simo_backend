class RecompensaModel {
  final dynamic id;
  final String nombre;
  final String descripcion;
  final int puntosRequeridos;
  final bool activo;

  RecompensaModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.puntosRequeridos,
    required this.activo,
  });

  factory RecompensaModel.fromJson(Map<String, dynamic> json) {
    return RecompensaModel(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'] ?? '',
      puntosRequeridos: (json['puntos_requeridos'] is int)
          ? json['puntos_requeridos']
          : int.tryParse(json['puntos_requeridos']?.toString() ?? '0') ?? 0,
      activo: json['activo'] ?? true,
    );
  }
}
