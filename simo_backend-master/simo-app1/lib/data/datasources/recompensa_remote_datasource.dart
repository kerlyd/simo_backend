import 'package:dio/dio.dart';
import '../models/recompensa_model.dart';

abstract class RecompensaRemoteDataSource {
  Future<List<RecompensaModel>> getRecompensas();
  Future<void> canjearRecompensa(dynamic id);
}

class RecompensaRemoteDataSourceImpl implements RecompensaRemoteDataSource {
  final Dio _dio;
  RecompensaRemoteDataSourceImpl(this._dio);

  @override
  Future<List<RecompensaModel>> getRecompensas() async {
    final response = await _dio.get('/api/recompensas');
    final List data = response.data['recompensas'];
    return data.map((json) => RecompensaModel.fromJson(json)).toList();
  }

  @override
  Future<void> canjearRecompensa(dynamic id) async {
    await _dio.post('/api/recompensas/$id/canjear');
  }
}
