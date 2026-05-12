import 'package:dartz/dartz.dart';
import '../entities/usuario_entity.dart';
import '../failures/failures.dart';
import '../repositories/auth_repository.dart';

class UpdateUserUseCase {
  final AuthRepository repository;
  UpdateUserUseCase(this.repository);

  Future<Either<Failure, UsuarioEntity>> call(UsuarioEntity usuario) {
    return repository.updateUser(usuario);
  }
}
