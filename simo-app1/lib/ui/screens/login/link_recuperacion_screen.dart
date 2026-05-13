import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'login_screen.dart';

class LinkRecuperacionScreen extends StatefulWidget {
  final String token;
  const LinkRecuperacionScreen({super.key, required this.token});

  @override
  State<LinkRecuperacionScreen> createState() => _LinkRecuperacionScreenState();
}

class _LinkRecuperacionScreenState extends State<LinkRecuperacionScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _emailUsuario = '';
  bool _ocultarPassword = true;
  bool _ocultarConfirm = true;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _extraerEmail();
  }

  void _extraerEmail() {
    try {
      final parts = widget.token.split('.');
      if (parts.length >= 2) {
        final payload = parts[1];
        // Normalizar base64 para evitar errores de padding
        String normalized = base64.normalize(payload);
        String decoded = utf8.decode(base64.decode(normalized));
        final Map<String, dynamic> data = json.decode(decoded);
        setState(() {
          _emailUsuario = data['email'] ?? 'Usuario SIMÖ';
        });
      }
    } catch (e) {
      debugPrint('Error al decodificar email: $e');
      setState(() {
        _emailUsuario = 'Usuario verificado';
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _cambiarPassword() async {
    final newPassword = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

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
        baseUrl: 'https://simobackend-production.up.railway.app',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      await dio.post('/api/auth/reset-password', data: {
        'token': widget.token,
        'newPassword': newPassword,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Contraseña actualizada correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        _mostrarError(e.response?.data?['error'] ?? 'Error al actualizar');
      }
    }
  }

  void _mostrarError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
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
                  '¡RECUPERA TU\nCONTRASEÑA!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 30, // Ajustado para que no se corte
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFdb007f),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 48),
                
                Text(
                  'Correo electrónico',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: _emailUsuario,
                    hintStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    filled: true,
                    fillColor: const Color(0xFFdb007f).withOpacity(0.50),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Contraseña nueva',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
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
                        _ocultarPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _ocultarPassword = !_ocultarPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Confirmar contraseña',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFdb007f),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
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
                        _ocultarConfirm ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white,
                      ),
                      onPressed: () => setState(() => _ocultarConfirm = !_ocultarConfirm),
                    ),
                  ),
                ),
                const SizedBox(height: 48),

                Center(
                  child: SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _cambiarPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFdb007f),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _cargando 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : Text(
                            'ACEPTAR',
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
