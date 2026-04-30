import 'package:dartz/dartz.dart';
import '../../domain/entities/historial_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/historial_repository.dart';
import '../datasources/historial_remote_datasource.dart';

class HistorialRepositoryImpl implements HistorialRepository {
  final HistorialRemoteDataSource _dataSource;

  HistorialRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<HistorialEntity>>> getHistorial() async {
    try {
      final result = await _dataSource.getHistorial();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
