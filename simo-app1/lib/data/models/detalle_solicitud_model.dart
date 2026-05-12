import '../../domain/entities/detalle_solicitud_entity.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../../domain/entities/historial_entity.dart';

class DetalleSolicitudModel extends DetalleSolicitudEntity {
  const DetalleSolicitudModel({
    required super.id,
    required super.cantidad,
    required super.tipoDispositivo,
    required super.destino,
    required super.direccionDestino,
    required super.electrodomestico,
    required super.fecha,
    required super.puntos,
    required super.puntosGanados,
    required super.estado,
    required super.metodoEntrega,
    required super.nit,
    required super.codigo,
    required super.fechaLimiteEntrega,
    required super.nota,
  });

  factory DetalleSolicitudModel.fromJson(Map<String, dynamic> json) {
      String metodoString = (json['metodo_entrega'] ?? '').toString().toLowerCase();
      MetodoEntrega metodoEntrega = metodoString.contains('lleva')
          ? MetodoEntrega.loLlevasTu
          : MetodoEntrega.loRecogemosNosotros;

      String fechaS = json['fecha_solicitud'] ?? json['fecha'] ?? '';
      String fechaLimite = '5 días hábiles';

      if (metodoEntrega == MetodoEntrega.loLlevasTu) {
        try {
          DateTime dt = DateTime.parse(fechaS);
          int added = 0;
          while (added < 2) {
            dt = dt.add(const Duration(days: 1));
            if (dt.weekday != DateTime.saturday && dt.weekday != DateTime.sunday) {
              added++;
            }
          }
          fechaLimite = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
        } catch (_) {
          fechaLimite = '2 días hábiles';
        }
      }

      return DetalleSolicitudModel(
        id: json['id'].toString(),
        cantidad: json['cantidad'] ?? 1,
        tipoDispositivo: _parseTipo(json['dispositivo_nombre']),
        destino: json['punto_nombre'] ?? 'Destino',
        direccionDestino: json['punto_direccion'] ?? 'Dirección',
        electrodomestico: json['dispositivo_nombre'] ?? 'Dispositivo',
        fecha: fechaS,
        puntos: json['puntos'] ?? 0,
        puntosGanados: json['puntos'] ?? 0,
        estado: EstadoSolicitud.values.firstWhere((e) => e.name == json['estado'],
            orElse: () => EstadoSolicitud.enProceso),
        metodoEntrega: metodoEntrega,
        nit: json['nit'] ?? '0129219',
        codigo: json['id'].toString().padLeft(4, '0'),
        fechaLimiteEntrega: fechaLimite,
        nota: 'Los puntos se otorgan por completar la solicitud.',
      );
    }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cantidad': cantidad,
        'tipoDispositivo': tipoDispositivo.name,
        'destino': destino,
        'direccionDestino': direccionDestino,
        'electrodomestico': electrodomestico,
        'fecha': fecha,
        'puntos': puntos,
        'puntosGanados': puntosGanados,
        'estado': estado.name,
        'metodoEntrega': metodoEntrega.name,
        'nit': nit,
        'codigo': codigo,
        'fechaLimiteEntrega': fechaLimiteEntrega,
        'nota': nota,
      };

  static TipoDispositivo _parseTipo(String? value) {
    if (value == null) return TipoDispositivo.celular;
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

  /// Mock para desarrollo mientras el backend no está listo
  static DetalleSolicitudModel mock() {
    var detalleSolicitudModel = const DetalleSolicitudModel(
      id: '1',
      cantidad: 21,
      tipoDispositivo: TipoDispositivo.celular,
      destino: 'Electro healt',
      direccionDestino: 'Calle 65 #15-93, Medellín',
      electrodomestico: 'Batería',
      fecha: '4 / marzo / 2026',
      puntos: 1100,
      puntosGanados: 1780,
      estado: EstadoSolicitud.enProceso,
      metodoEntrega: MetodoEntrega.loLlevasTu,
      nit: 'NIT-0129219',
      codigo: '6645',
      fechaLimiteEntrega: '10 / Marzo / 2026',
      nota:
          'Los puntos se otorgarán cuando el dispositivo sea recibido en el punto de reciclaje.',
    );
    return detalleSolicitudModel;
  }
}
