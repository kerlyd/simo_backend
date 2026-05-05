import 'package:dartz/dartz.dart';
import '../entities/notificacion_entity.dart';
import '../failures/failures.dart';
import '../repositories/notificacion_repository.dart';

class GetNotificacionesUseCase {
  final NotificacionRepository _repo;

  GetNotificacionesUseCase(this._repo);

  Future<Either<Failure, List<NotificacionEntity>>> call() {
    return _repo.getNotificaciones();
  }
}
