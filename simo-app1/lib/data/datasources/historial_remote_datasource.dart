import 'package:dio/dio.dart';
import '../../domain/entities/historial_entity.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../models/historial_model.dart';

abstract class HistorialRemoteDataSource {
  Future<List<HistorialModel>> getHistorial();
}

class HistorialRemoteDataSourceImpl implements HistorialRemoteDataSource {
  final Dio _dio;
  HistorialRemoteDataSourceImpl(this._dio);

  @override
  Future<List<HistorialModel>> getHistorial() async {
    final response = await _dio.get('/api/solicitudes');
    final List data = response.data['solicitudes'] ?? [];
    return data.map((json) => HistorialModel.fromJson(json)).toList();
  }
}
