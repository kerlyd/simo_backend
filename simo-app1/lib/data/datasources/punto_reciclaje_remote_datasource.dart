import 'package:dio/dio.dart';
import '../models/punto_reciclaje_model.dart';

abstract class PuntoReciclajeRemoteDataSource {
  Future<List<PuntoReciclajeModel>> getPuntosReciclaje();
}

class PuntoReciclajeRemoteDataSourceImpl implements PuntoReciclajeRemoteDataSource {
  final Dio dio;

  PuntoReciclajeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PuntoReciclajeModel>> getPuntosReciclaje() async {
    try {
      final response = await dio.get('/api/puntos-reciclaje');
      if (response.statusCode == 200) {
        final List data = response.data['puntos'];
        return data.map((e) => PuntoReciclajeModel.fromJson(e)).toList();
      } else {
        throw Exception('Error al obtener puntos de reciclaje');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
