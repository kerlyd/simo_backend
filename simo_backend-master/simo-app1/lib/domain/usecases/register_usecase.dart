import 'package:dartz/dartz.dart';
import '../failures/failures.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repo;
  RegisterUseCase(this._repo);

  Future<Either<Failure, void>> call({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  }) {
    return _repo.register(
      nombre: nombre,
      cedula: cedula,
      telefono: telefono,
      direccion: direccion,
      email: email,
      password: password,
    );
  }
}
