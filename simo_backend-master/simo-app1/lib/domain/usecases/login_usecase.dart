import 'package:dartz/dartz.dart';
import '../entities/usuario_entity.dart';
import '../failures/failures.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repo;
  LoginUseCase(this._repo);

  Future<Either<Failure, UsuarioEntity>> call(String nombre, String password) {
    return _repo.login(nombre, password);
  }
}
