class PuntoReciclajeModel {
  final dynamic id;
  final String nombre;
  final String direccion;
  final double? latitud;
  final double? longitud;
  final bool activo;

  PuntoReciclajeModel({
    required this.id,
    required this.nombre,
    required this.direccion,
    this.latitud,
    this.longitud,
    required this.activo,
  });

  factory PuntoReciclajeModel.fromJson(Map<String, dynamic> json) {
    return PuntoReciclajeModel(
      id: json['id'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      latitud: json['latitud'] != null ? double.tryParse(json['latitud'].toString()) : null,
      longitud: json['longitud'] != null ? double.tryParse(json['longitud'].toString()) : null,
      activo: json['activo'] ?? true,
    );
  }
}
