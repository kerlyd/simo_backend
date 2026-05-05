import 'package:dartz/dartz.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../../domain/failures/failures.dart';
import '../../domain/repositories/notificacion_repository.dart';
import '../datasources/notificacion_remote_datasource.dart';

class NotificacionRepositoryImpl implements NotificacionRepository {
  final NotificacionRemoteDataSource _dataSource;

  NotificacionRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<NotificacionEntity>>> getNotificaciones() async {
    try {
      final result = await _dataSource.getNotificaciones();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
