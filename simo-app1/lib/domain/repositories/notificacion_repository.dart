import 'package:dartz/dartz.dart';
import '../entities/notificacion_entity.dart';
import '../failures/failures.dart';

abstract class NotificacionRepository {
  Future<Either<Failure, List<NotificacionEntity>>> getNotificaciones();
}
