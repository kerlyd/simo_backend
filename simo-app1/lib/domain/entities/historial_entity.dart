import 'notificacion_entity.dart'; // reutilizamos TipoDispositivo

enum EstadoSolicitud { enProceso, completo, cancelado }

class HistorialEntity {
  final String id;
  final int cantidad;
  final TipoDispositivo tipoDispositivo;
  final String destino;
  final String electrodomestico;
  final String fecha;
  final int puntos;
  final EstadoSolicitud estado;

  const HistorialEntity({
    required this.id,
    required this.cantidad,
    required this.tipoDispositivo,
    required this.destino,
    required this.electrodomestico,
    required this.fecha,
    required this.puntos,
    required this.estado,
  });
}
