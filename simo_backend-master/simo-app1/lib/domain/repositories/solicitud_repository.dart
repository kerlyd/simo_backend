import 'package:dartz/dartz.dart';
import '../entities/detalle_solicitud_entity.dart';
import '../failures/failures.dart';

abstract class SolicitudRepository {
  Future<Either<Failure, DetalleSolicitudEntity>> getDetalleSolicitud(String id);
}
