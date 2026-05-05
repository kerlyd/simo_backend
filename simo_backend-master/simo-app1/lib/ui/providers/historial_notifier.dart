import 'package:flutter/foundation.dart';
import '../../domain/entities/historial_entity.dart';
import '../../domain/usecases/get_historial_usecase.dart';

@immutable
class HistorialState {
  final bool isLoading;
  final List<HistorialEntity> historial;
  final String? errorMessage;

  const HistorialState({
    this.isLoading = false,
    this.historial = const [],
    this.errorMessage,
  });

  HistorialState copyWith({
    bool? isLoading,
    List<HistorialEntity>? historial,
    String? errorMessage,
  }) {
    return HistorialState(
      isLoading: isLoading ?? this.isLoading,
      historial: historial ?? this.historial,
      errorMessage: errorMessage,
    );
  }
}

class HistorialNotifier extends ChangeNotifier {
  final GetHistorialUseCase _getHistorialUseCase;

  HistorialNotifier(this._getHistorialUseCase);

  HistorialState _state = const HistorialState();
  HistorialState get state => _state;

  Future<void> cargarHistorial() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _getHistorialUseCase();

    result.fold(
      (failure) {
        _state = _state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (historial) {
        _state = _state.copyWith(
          isLoading: false,
          historial: historial,
        );
      },
    );
    notifyListeners();
  }
}
