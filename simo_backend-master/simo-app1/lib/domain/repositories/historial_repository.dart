import 'package:dartz/dartz.dart';
import '../entities/historial_entity.dart';
import '../failures/failures.dart';

abstract class HistorialRepository {
  Future<Either<Failure, List<HistorialEntity>>> getHistorial();
}
