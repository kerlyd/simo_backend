import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/detalle_solicitud_entity.dart';
import '../../domain/usecases/get_detalle_solicitud_usecase.dart';
import '../../injection_container.dart';

// ─── State ────────────────────────────────────────────────────────────────────

@immutable
class DetalleSolicitudState {
  final bool isLoading;
  final bool isSubmitting;          // para el botón "Completo" mientras procesa
  final DetalleSolicitudEntity? detalle;
  final String? errorMessage;
  final bool confirmacionExpanded;  // sección colapsable

  const DetalleSolicitudState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.detalle,
    this.errorMessage,
    this.confirmacionExpanded = true,
  });

  DetalleSolicitudState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    DetalleSolicitudEntity? detalle,
    String? Function()? errorMessage, // nullable wrapper para poder pasar null explícito
    bool? confirmacionExpanded,
  }) {
    return DetalleSolicitudState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      detalle: detalle ?? this.detalle,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      confirmacionExpanded: confirmacionExpanded ?? this.confirmacionExpanded,
    );
  }
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class DetalleSolicitudNotifier extends ChangeNotifier {
  final GetDetalleSolicitudUseCase _getDetalle;

  DetalleSolicitudNotifier(this._getDetalle);

  DetalleSolicitudState _state = const DetalleSolicitudState();
  DetalleSolicitudState get state => _state;

  /// Carga el detalle de la solicitud por ID
  Future<void> cargar(String id) async {
    _state = _state.copyWith(
      isLoading: true,
      errorMessage: () => null,
    );
    notifyListeners();

    final result = await _getDetalle(id);

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: () => failure.message,
        );
      },
      (detalle) {
        _state = _state.copyWith(isLoading: false, detalle: detalle);
      },
    );
    notifyListeners();
  }

  /// Alterna la sección "Confirmación" expandida/colapsada
  void toggleConfirmacion() {
    _state = _state.copyWith(
      confirmacionExpanded: !_state.confirmacionExpanded,
    );
    notifyListeners();
  }

  /// Marca la solicitud como completada (se conectará al backend)
  Future<void> marcarCompleto() async {
    if (_state.detalle == null) return;

    _state = _state.copyWith(isSubmitting: true);
    notifyListeners();

    try {
      await sl<Dio>().put('/api/solicitudes/${_state.detalle!.id}/completar');
      await cargar(_state.detalle!.id); 
    } catch (e) {
      if (kDebugMode) print('Error completando: $e');
    }

    _state = _state.copyWith(isSubmitting: false);
    notifyListeners();
  }
}
