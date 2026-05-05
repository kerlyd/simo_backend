import '../../domain/entities/usuario_entity.dart';

class UsuarioModel extends UsuarioEntity {
  const UsuarioModel({
    required super.id,
    required super.nombre,
    required super.email,
    required super.cedula,
    required super.telefono,
    required super.direccion,
    required super.puntosVerdes,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'].toString(),
      nombre: json['nombre'],
      email: json['email'],
      cedula: json['cedula'],
      telefono: json['telefono'] ?? '',
      direccion: json['direccion'] ?? '',
      puntosVerdes: json['puntos_verdes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'email': email,
    'cedula': cedula,
    'telefono': telefono,
    'direccion': direccion,
    'puntosVerdes': puntosVerdes,
  };
}
