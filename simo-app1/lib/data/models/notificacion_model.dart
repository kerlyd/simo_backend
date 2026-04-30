import '../../domain/entities/notificacion_entity.dart';

class NotificacionModel extends NotificacionEntity {
  const NotificacionModel({
    required super.id,
    required super.titulo,
    required super.descripcion,
    required super.fecha,
    required super.cantidad,
    required super.tipoDispositivo,
    required super.estado,
  });

  factory NotificacionModel.fromJson(Map<String, dynamic> json) {
    return NotificacionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      titulo: json['titulo'] ?? '',
      descripcion: json['mensaje'] ?? json['descripcion'] ?? '',
      fecha: json['fecha_envio'] ?? json['fecha'] ?? '',
      cantidad: json['cantidad'] ?? 1,
      tipoDispositivo: _parseTipoDispositivo(json['tipoDispositivo'] ?? 'otro'),
      estado: _parseEstado(json['estado'] ?? 'aceptada'),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titulo': titulo,
        'descripcion': descripcion,
        'fecha': fecha,
        'cantidad': cantidad,
        'tipoDispositivo': tipoDispositivo.name,
        'estado': estado.name,
      };

  static TipoDispositivo _parseTipoDispositivo(String? value) {
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

  static EstadoNotificacion _parseEstado(String value) {
    return EstadoNotificacion.values.firstWhere(
      (e) => e.name == value,
      orElse: () => EstadoNotificacion.aceptada,
    );
  }
}
