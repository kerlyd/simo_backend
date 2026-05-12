import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/usuario_model.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UsuarioEntity>> login(
    String nombre,
    String password,
  ) async {
    try {
      final result = await _dataSource.login(nombre, password);
      final token = result['token'] as String;
      final usuario = result['usuario'] as UsuarioEntity;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      return Right(usuario);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return Left(
          UnauthorizedFailure(
            e.response?.data['message'] ?? 'Credenciales incorrectas',
          ),
        );
      }
      return Left(ServerFailure(e.message ?? 'Error del servidor'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  }) async {
    try {
      await _dataSource.register(
        nombre: nombre,
        cedula: cedula,
        telefono: telefono,
        direccion: direccion,
        email: email,
        password: password,
      );
      return const Right(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(
          ServerFailure(
            e.response?.data['message'] ?? 'Error en el registro',
          ),
        );
      }
      return Left(ServerFailure(e.message ?? 'Error del servidor'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UsuarioEntity>> updateUser(UsuarioEntity usuario) async {
    try {
      final result = await _dataSource.updateUser(usuario as UsuarioModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Error al actualizar usuario'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
