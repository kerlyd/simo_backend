import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'link_recuperacion_screen.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _correoController = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _correoController.dispose();
    super.dispose();
  }

  Future<void> _enviarEnlace() async {
    final email = _correoController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa tu correo electrónico')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000'));
      await dio.post('/api/auth/recuperar', data: {'email': email});

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LinkRecuperacionScreen(email: email!),
          ),
        );
      }
    } on DioException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.response?.data['message'] ?? 'Error al enviar'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
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
                  '¡ RECUPERA TU\nCONTRASEÑA !',
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
                  'Te enviaremos un enlace para restablecer\ntu contraseña y que puedas volver a\nentrar a tu cuenta.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFFdb007f),
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
                SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _correoController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFdb007f).withOpacity(0.50),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Center(
                  child: SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: _cargando ? null : _enviarEnlace,
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
                              'ENVIAR ENLACE',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
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
