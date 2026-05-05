import 'package:dartz/dartz.dart';
import '../entities/historial_entity.dart';
import '../failures/failures.dart';
import '../repositories/historial_repository.dart';

class GetHistorialUseCase {
  final HistorialRepository _repo;

  GetHistorialUseCase(this._repo);

  Future<Either<Failure, List<HistorialEntity>>> call() {
    return _repo.getHistorial();
  }
}
