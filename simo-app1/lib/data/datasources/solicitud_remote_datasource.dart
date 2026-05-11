import 'package:dio/dio.dart';
import '../models/detalle_solicitud_model.dart';

abstract class SolicitudRemoteDataSource {
  Future<DetalleSolicitudModel> getDetalleSolicitud(String id);
  Future<void> completarSolicitud(String id);
}

class SolicitudRemoteDataSourceImpl implements SolicitudRemoteDataSource {
  final Dio _dio;
  SolicitudRemoteDataSourceImpl(this._dio);

  @override
  Future<DetalleSolicitudModel> getDetalleSolicitud(String id) async {
    final response = await _dio.get('/api/solicitudes/$id');
    return DetalleSolicitudModel.fromJson(response.data['solicitud']);
  }

  @override
  Future<void> completarSolicitud(String id) async {
    await _dio.put('/api/solicitudes/$id/completar');
  }
}
