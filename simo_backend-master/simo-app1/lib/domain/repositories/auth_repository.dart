import 'package:dartz/dartz.dart';
import '../entities/usuario_entity.dart';
import '../failures/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, UsuarioEntity>> login(String nombre, String password);
  Future<Either<Failure, void>> register({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  });
}
