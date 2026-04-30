import 'package:dartz/dartz.dart';
import '../../domain/entities/detalle_solicitud_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/solicitud_repository.dart';
import '../datasources/solicitud_remote_datasource.dart';

class SolicitudRepositoryImpl implements SolicitudRepository {
  final SolicitudRemoteDataSource _dataSource;

  SolicitudRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, DetalleSolicitudEntity>> getDetalleSolicitud(
      String id) async {
    try {
      final result = await _dataSource.getDetalleSolicitud(id);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
