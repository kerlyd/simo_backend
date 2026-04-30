import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class LinkRecuperacionScreen extends StatefulWidget {
  final String email;

  const LinkRecuperacionScreen({super.key, required this.email});

  @override
  State<LinkRecuperacionScreen> createState() => _LinkRecuperacionScreenState();
}

class _LinkRecuperacionScreenState extends State<LinkRecuperacionScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _recordarDatos = true;
  late final TextEditingController _correoController;

  @override
  void initState() {
    super.initState();
    _correoController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _correoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                const SizedBox(height: 48),

                // Campo Correo electrónico
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
                const SizedBox(height: 16),

                // Campo Contraseña nueva
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
                    obscureText: true,
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
                const SizedBox(height: 16),

                // Campo Confirmar Contraseña
                Text(
                  'Confirmar Contraseña',
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
                    obscureText: true,
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
                const SizedBox(height: 12),

                // Checkbox Recordar mis datos
                GestureDetector(
                  onTap: () => setState(() => _recordarDatos = !_recordarDatos),
                  child: Row(
                    children: [
                      Icon(
                        _recordarDatos
                            ? Icons.circle
                            : Icons.radio_button_unchecked,
                        size: 16,
                        color: const Color(0xFFdb007f),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Recordar mis datos',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFFdb007f),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),

                // Botón enviar enlace
                Center(
                  child: SizedBox(
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () {
                        // Limpia el stack y redirige al Login
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFdb007f),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
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
