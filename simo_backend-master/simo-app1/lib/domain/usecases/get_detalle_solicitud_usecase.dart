import 'package:dartz/dartz.dart';
import '../entities/detalle_solicitud_entity.dart';
import '../failures/failures.dart';
import '../repositories/solicitud_repository.dart';

class GetDetalleSolicitudUseCase {
  final SolicitudRepository _repo;

  GetDetalleSolicitudUseCase(this._repo);

  Future<Either<Failure, DetalleSolicitudEntity>> call(String id) {
    return _repo.getDetalleSolicitud(id);
  }
}
