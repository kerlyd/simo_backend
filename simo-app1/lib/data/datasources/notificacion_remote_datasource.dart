import 'package:dio/dio.dart';
import '../models/notificacion_model.dart';

// Única capa que habla con el backend (o datos mock durante desarrollo).
abstract class NotificacionRemoteDataSource {
  Future<List<NotificacionModel>> getNotificaciones();
}

class NotificacionRemoteDataSourceImpl implements NotificacionRemoteDataSource {
  final Dio _dio;
  NotificacionRemoteDataSourceImpl(this._dio);

  @override
  Future<List<NotificacionModel>> getNotificaciones() async {
    final response = await _dio.get('/api/notificaciones');
    final List data = response.data['notificaciones'] ?? [];
    return data.map((json) => NotificacionModel.fromJson(json)).toList();
  }
}
