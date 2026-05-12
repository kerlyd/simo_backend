import 'package:dio/dio.dart';
import '../models/usuario_model.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String nombre, String password);
  Future<void> register({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  });
  Future<UsuarioModel> updateUser(UsuarioModel usuario);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;
  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<Map<String, dynamic>> login(String nombre, String password) async {
    final response = await _dio.post(
      '/api/auth/login',
      data: {'nombre': nombre, 'password': password},
    );
    return {
      'token': response.data['token'],
      'usuario': UsuarioModel.fromJson(response.data['usuario']),
    };
  }

  @override
  Future<void> register({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  }) async {
    await _dio.post(
      '/api/auth/register',
      data: {
        'nombre': nombre,
        'cedula': cedula,
        'telefono': telefono,
        'direccion': direccion,
        'email': email,
        'password': password,
      },
    );
  }

  @override
  Future<UsuarioModel> updateUser(UsuarioModel usuario) async {
    final response = await _dio.put(
      '/api/usuario/me',
      data: usuario.toJson(),
    );
    return UsuarioModel.fromJson(response.data['usuario']);
  }
}
