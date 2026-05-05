import '../../domain/entities/historial_entity.dart';
import '../../domain/entities/notificacion_entity.dart';

class HistorialModel extends HistorialEntity {
  const HistorialModel({
    required super.id,
    required super.cantidad,
    required super.tipoDispositivo,
    required super.destino,
    required super.electrodomestico,
    required super.fecha,
    required super.puntos,
    required super.estado,
  });

  factory HistorialModel.fromJson(Map<String, dynamic> json) {
    return HistorialModel(
      id: json['id'].toString(),
      cantidad: json['cantidad'] ?? 1,
      tipoDispositivo: _parseTipo(json['dispositivo_nombre'] ?? 'otro'),
      destino: json['punto_nombre'] ?? 'Desconocido',
      electrodomestico: json['dispositivo_nombre'] ?? 'Dispositivo',
      fecha: json['fecha_solicitud'] ?? json['fecha'] ?? '',
      puntos: json['puntos'] ?? 0,
      estado: _parseEstado(json['estado'] ?? 'enProceso'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cantidad': cantidad,
        'tipoDispositivo': tipoDispositivo.name,
        'destino': destino,
        'electrodomestico': electrodomestico,
        'fecha': fecha,
        'puntos': puntos,
        'estado': estado.name,
      };

  static TipoDispositivo _parseTipo(String? value) {
    if (value == null) return TipoDispositivo.otro;
    final normalized = value.toLowerCase().replaceAll('í', 'i').replaceAll('á', 'a').replaceAll('é', 'e').replaceAll('ó', 'o').replaceAll('ú', 'u');
    return TipoDispositivo.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () {
        if (normalized.contains('bateria')) return TipoDispositivo.bateria;
        if (normalized.contains('celular') || normalized.contains('movil')) return TipoDispositivo.celular;
        if (normalized.contains('tablet')) return TipoDispositivo.tablet;
        if (normalized.contains('laptop') || normalized.contains('portatil') || normalized.contains('computador')) return TipoDispositivo.laptop;
        return TipoDispositivo.otro;
      },
    );
  }

  static EstadoSolicitud _parseEstado(String value) {
    if (value == 'completo' || value == 'completado') return EstadoSolicitud.completo;
    if (value == 'cancelado') return EstadoSolicitud.cancelado;
    return EstadoSolicitud.enProceso;
  }
}
