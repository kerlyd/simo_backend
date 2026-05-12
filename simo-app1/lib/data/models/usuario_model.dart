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
    required super.genero,
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
      genero: json['genero'] ?? 'hombre',
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
    'genero': genero,
  };

  UsuarioModel copyWith({
    String? id,
    String? nombre,
    String? email,
    String? cedula,
    String? telefono,
    String? direccion,
    int? puntosVerdes,
    String? genero,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      cedula: cedula ?? this.cedula,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      puntosVerdes: puntosVerdes ?? this.puntosVerdes,
      genero: genero ?? this.genero,
    );
  }
}
