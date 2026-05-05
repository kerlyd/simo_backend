import 'historial_entity.dart';
import 'notificacion_entity.dart';

enum MetodoEntrega { loLlevasTu, loRecogemosNosotros }

class DetalleSolicitudEntity {
  final String id;
  final int cantidad;
  final TipoDispositivo tipoDispositivo;
  final String destino;
  final String direccionDestino;       // e.g. "Calle 65 #15-93, Medellín"
  final String electrodomestico;
  final String fecha;                  // fecha de la solicitud
  final int puntos;                    // puntos que muestra el badge
  final int puntosGanados;             // puntos verdes ganados al completar
  final EstadoSolicitud estado;
  final MetodoEntrega metodoEntrega;
  final String nit;                    // NIT del punto de reciclaje
  final String codigo;                 // código de la solicitud, e.g. "6645"
  final String fechaLimiteEntrega;     // e.g. "10 / Marzo / 2026"
  final String nota;

  const DetalleSolicitudEntity({
    required this.id,
    required this.cantidad,
    required this.tipoDispositivo,
    required this.destino,
    required this.direccionDestino,
    required this.electrodomestico,
    required this.fecha,
    required this.puntos,
    required this.puntosGanados,
    required this.estado,
    required this.metodoEntrega,
    required this.nit,
    required this.codigo,
    required this.fechaLimiteEntrega,
    required this.nota,
  });
}
