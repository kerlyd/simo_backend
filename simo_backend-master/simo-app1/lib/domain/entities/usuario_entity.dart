class UsuarioEntity {
  final String id;
  final String nombre;
  final String email;
  final String cedula;
  final String telefono;
  final String direccion;
  final int puntosVerdes;

  const UsuarioEntity({
    required this.id,
    required this.nombre,
    required this.email,
    required this.cedula,
    required this.telefono,
    required this.direccion,
    required this.puntosVerdes,
  });
}
