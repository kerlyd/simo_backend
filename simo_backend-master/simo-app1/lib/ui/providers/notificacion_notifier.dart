import 'package:flutter/foundation.dart';
import '../../domain/entities/notificacion_entity.dart';
import '../../domain/usecases/get_notificaciones_usecase.dart';

// Estado inmutable del notifier
@immutable
class NotificacionState {
  final bool isLoading;
  final List<NotificacionEntity> notificaciones;
  final String? errorMessage;

  const NotificacionState({
    this.isLoading = false,
    this.notificaciones = const [],
    this.errorMessage,
  });

  NotificacionState copyWith({
    bool? isLoading,
    List<NotificacionEntity>? notificaciones,
    String? errorMessage,
  }) {
    return NotificacionState(
      isLoading: isLoading ?? this.isLoading,
      notificaciones: notificaciones ?? this.notificaciones,
      errorMessage: errorMessage,
    );
  }
}

// ChangeNotifier para conectar UI con el use case.
class NotificacionNotifier extends ChangeNotifier {
  final GetNotificacionesUseCase _getNotificacionesUseCase;

  NotificacionNotifier(this._getNotificacionesUseCase);

  NotificacionState _state = const NotificacionState();
  NotificacionState get state => _state;

  Future<void> cargarNotificaciones() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _getNotificacionesUseCase();

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (notificaciones) {
        _state = _state.copyWith(
          isLoading: false,
          notificaciones: notificaciones,
        );
      },
    );
    notifyListeners();
  }
}
