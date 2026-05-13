import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

class RecuperarPasswordScreen extends StatefulWidget {
  const RecuperarPasswordScreen({super.key});

  @override
  State<RecuperarPasswordScreen> createState() =>
      _RecuperarPasswordScreenState();
}

class _RecuperarPasswordScreenState extends State<RecuperarPasswordScreen> {
  final _correoController = TextEditingController();
  bool _cargando = false;
  bool _enviado = false;

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

    // Validación básica de formato de email
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un correo válido')),
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'https://simobackend-production.up.railway.app',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      await dio.post('/api/auth/recuperar', data: {'email': email});

      if (mounted) {
        setState(() {
          _cargando = false;
          _enviado = true;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        setState(() => _cargando = false);
        final msg =
            e.response?.data?['error'] ?? 'Error al enviar. Intenta de nuevo.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
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
            child: _enviado ? _buildSuccessView() : _buildFormView(),
          ),
        ),
      ),
    );
  }

  // ── Vista de éxito (después de enviar el correo) ──────────
  Widget _buildSuccessView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.mark_email_read_rounded,
          size: 80,
          color: Color(0xFFdb007f),
        ),
        const SizedBox(height: 24),
        Text(
          '¡CORREO ENVIADO!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: const Color(0xFFdb007f),
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Revisa tu bandeja de entrada en\n${_correoController.text.trim()}\n\nToca el enlace del correo para restablecer tu contraseña.\n\n(El enlace expira en 15 minutos)',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFdb007f),
          ),
        ),
        const SizedBox(height: 48),
        Center(
          child: SizedBox(
            width: 240,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFdb007f),
                side: const BorderSide(color: Color(0xFFdb007f), width: 2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'VOLVER AL LOGIN',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Vista del formulario ──────────────────────────────────
  Widget _buildFormView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '¡RECUPERA TU\nCONTRASEÑA!',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 38, 
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
                padding: const EdgeInsets.symmetric(vertical: 18),
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
    );
  }
}
