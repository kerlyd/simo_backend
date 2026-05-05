// notificacion_entity.dart
// Entidad pura — sin fromJson, sin dependencias de Flutter o Dio.

enum TipoDispositivo { celular, tablet, laptop, bateria, otro }

enum EstadoNotificacion { aceptada, enCamino, entregada, cancelada }

class NotificacionEntity {
  final int id;
  final String titulo;
  final String descripcion;
  final String fecha;
  final int cantidad;
  final TipoDispositivo tipoDispositivo;
  final EstadoNotificacion estado;

  const NotificacionEntity({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.fecha,
    required this.cantidad,
    required this.tipoDispositivo,
    required this.estado,
  });
}
