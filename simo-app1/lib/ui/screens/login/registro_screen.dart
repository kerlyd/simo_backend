import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_notifier.dart';
import 'login_screen.dart';

class RegistroScreen extends ConsumerStatefulWidget {
  const RegistroScreen({super.key});

  @override
  ConsumerState<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends ConsumerState<RegistroScreen> {
  final _nombreController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmarPasswordController = TextEditingController();
  bool _verPassword = false;
  bool _verConfirmarPassword = false;
  String _genero = 'femenino';

  @override
  void dispose() {
    _nombreController.dispose();
    _cedulaController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmarPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    final nombre = _nombreController.text.trim();
    final cedula = _cedulaController.text.trim();
    final telefono = _telefonoController.text.trim();
    final direccion = _direccionController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmar = _confirmarPasswordController.text.trim();

    if (nombre.isEmpty ||
        cedula.isEmpty ||
        telefono.isEmpty ||
        direccion.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    if (password != confirmar) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ref
        .read(authProvider.notifier)
        .register(
          nombre: nombre,
          cedula: cedula,
          telefono: telefono,
          direccion: direccion,
          email: email,
          password: password,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthRegistered) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 80, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: -50,
                      top: 90,
                      child: Transform.rotate(
                        angle: math.pi / 2,
                        child: Image.asset(
                          'assets/images/robot.png',
                          height: 130,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 15,
                      top: -10,
                      child: Text(
                        'Únete a',
                        style: GoogleFonts.outfit(
                          fontSize: 80,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFFdb007f),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 100,
                      top: 90,
                      child: Text(
                        'SIMÖ',
                        style: GoogleFonts.outfit(
                          fontSize: 100,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFdb007f),
                          height: 0.9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildCampo(
                controller: _nombreController,
                hint: 'Nombre',
                icon: Icons.person_outline,
                sufijo: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _genero = 'femenino'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _genero == 'femenino'
                              ? const Color(0xFFdb007f).withOpacity(0.7)
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.female,
                          size: 18,
                          color: _genero == 'femenino'
                              ? Colors.white
                              : const Color(0xFFdb007f),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => setState(() => _genero = 'masculino'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _genero == 'masculino'
                              ? const Color(0xFFdb007f).withOpacity(0.7)
                              : Colors.white,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Icon(
                          Icons.male,
                          size: 18,
                          color: _genero == 'masculino'
                              ? Colors.white
                              : const Color(0xFFdb007f),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildCampo(
                controller: _cedulaController,
                hint: 'Cédula',
                icon: Icons.badge_outlined,
                teclado: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _buildCampo(
                controller: _telefonoController,
                hint: 'Teléfono',
                icon: Icons.phone_outlined,
                teclado: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _buildCampo(
                controller: _direccionController,
                hint: 'Dirección',
                icon: Icons.home_outlined,
              ),
              const SizedBox(height: 12),
              _buildCampo(
                controller: _emailController,
                hint: 'Correo electrónico',
                icon: Icons.mail_outline,
                teclado: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _buildCampoPassword(
                controller: _passwordController,
                hint: 'Contraseña Nueva',
                ver: _verPassword,
                onVerTap: () => setState(() => _verPassword = !_verPassword),
              ),
              const SizedBox(height: 24),
              _buildCampoPassword(
                controller: _confirmarPasswordController,
                hint: 'Confirmar Contraseña',
                ver: _verConfirmarPassword,
                onVerTap: () => setState(
                  () => _verConfirmarPassword = !_verConfirmarPassword,
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: SizedBox(
                  width: 320,
                  child: ElevatedButton(
                    onPressed: authState is AuthLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFdb007f),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: authState is AuthLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'CREAR CUENTA',
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
    );
  }

  Widget _buildCampo({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType teclado = TextInputType.text,
    Widget? sufijo,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFdb007f).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: teclado,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.outfit(color: Colors.white70),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          if (sufijo != null) ...[sufijo, const SizedBox(width: 8)],
        ],
      ),
    );
  }

  Widget _buildCampoPassword({
    required TextEditingController controller,
    required String hint,
    required bool ver,
    required VoidCallback onVerTap,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFdb007f).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.lock_outline, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !ver,
              style: GoogleFonts.outfit(color: Colors.white),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.outfit(color: Colors.white70),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              ver ? Icons.visibility : Icons.visibility_off,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onVerTap,
          ),
        ],
      ),
    );
  }
}
