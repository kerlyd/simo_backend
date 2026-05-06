import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'login_screen.dart';

class LinkRecuperacionScreen extends StatefulWidget {
  /// Token JWT recibido desde el deep link del correo
  final String token;

  const LinkRecuperacionScreen({super.key, required this.token});

  @override
  State<LinkRecuperacionScreen> createState() => _LinkRecuperacionScreenState();
}

class _LinkRecuperacionScreenState extends State<LinkRecuperacionScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _ocultarPassword = true;
  bool _ocultarConfirm = true;
  bool _cargando = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _cambiarPassword() async {
    final newPassword = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    // Validaciones locales
    if (newPassword.isEmpty || confirm.isEmpty) {
      _mostrarError('Completa todos los campos');
      return;
    }

    if (newPassword.length < 6) {
      _mostrarError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (newPassword != confirm) {
      _mostrarError('Las contraseñas no coinciden');
      return;
    }

    setState(() => _cargando = true);

    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://192.168.1.4:3000',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      await dio.post('/api/auth/reset-password', data: {
        'token': widget.token,
        'newPassword': newPassword,
      });

      if (mounted) {
        // Mostrar mensaje de éxito y navegar al login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Contraseña actualizada. ¡Ya puedes iniciar sesión!',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 3),
          ),
        );

        // Limpia el stack y va al Login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        final msg = e.response?.data?['error'] ??
            'Error al cambiar la contraseña. Intenta de nuevo.';
        _mostrarError(msg);
      }
    }
  }

  void _mostrarError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '¡ NUEVA\nCONTRASEÑA !',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFdb007f),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ingresa y confirma tu nueva\ncontraseña para recuperar el acceso.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 48),

                // ── Campo Contraseña nueva ──────────────────
                Text(
                  'Contraseña nueva',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFdb007f).withOpacity(0.50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            setState(() => _ocultarPassword = !_ocultarPassword),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Campo Confirmar Contraseña ───────────────
                Text(
                  'Confirmar contraseña',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: _ocultarConfirm,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFdb007f).withOpacity(0.50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () =>
                            setState(() => _ocultarConfirm = !_ocultarConfirm),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                // ── Botón Cambiar contraseña ─────────────────
                Center(
                  child: SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _cambiarPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFdb007f),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _cargando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'CAMBIAR CONTRASEÑA',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
