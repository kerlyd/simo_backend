import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../data/models/usuario_model.dart';
import '../../domain/entities/usuario_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../injection_container.dart';

// Estado
abstract class AuthState {
  UsuarioEntity? get usuario => null;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  @override
  final UsuarioEntity usuario;
  AuthAuthenticated(this.usuario);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthRegistered extends AuthState {}

// Notifier
class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => AuthInitial();

  Future<void> login(String nombre, String password) async {
    state = AuthLoading();
    final result = await sl<LoginUseCase>().call(nombre, password);
    result.fold(
      (failure) => state = AuthError(failure.message),
      (usuario) => state = AuthAuthenticated(usuario),
    );
  }

  Future<void> register({
    required String nombre,
    required String cedula,
    required String telefono,
    required String direccion,
    required String email,
    required String password,
  }) async {
    state = AuthLoading();
    final result = await sl<RegisterUseCase>().call(
      nombre: nombre,
      cedula: cedula,
      telefono: telefono,
      direccion: direccion,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => state = AuthError(failure.message),
      (_) => state = AuthRegistered(),
    );
  }

  void logout() {
    state = AuthInitial();
  }

  Future<void> refreshUser() async {
    try {
      final response = await sl<Dio>().get('/api/usuario/me');
      if (response.statusCode == 200) {
        final usuario = UsuarioModel.fromJson(response.data['usuario']);
        state = AuthAuthenticated(usuario);
      }
    } catch (e) {
      // Si falla el refresh, no cambiamos el estado para no desloguear al usuario por error de red
      print('Error refreshing user: $e');
    }
  }
}

// Provider
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});
