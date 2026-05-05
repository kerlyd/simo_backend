import 'package:dio/dio.dart';
import '../models/dispositivo_model.dart';

abstract class DispositivoRemoteDataSource {
  Future<List<DispositivoModel>> getTiposDispositivo();
}

class DispositivoRemoteDataSourceImpl implements DispositivoRemoteDataSource {
  final Dio dio;

  DispositivoRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DispositivoModel>> getTiposDispositivo() async {
    try {
      final response = await dio.get('/api/dispositivos/tipos');
      if (response.statusCode == 200) {
        final List data = response.data['tipos'];
        return data.map((e) => DispositivoModel.fromJson(e)).toList();
      } else {
        throw Exception('Error al obtener tipos de dispositivo');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
