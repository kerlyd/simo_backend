import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'registro_screen.dart';
import '../../providers/auth_notifier.dart';
import 'rol_selection_screen.dart';
import 'recuperar_password_screen.dart';
import '../../utils/responsive.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String rol;
  const LoginScreen({super.key, this.rol = 'reciclador'});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _recordarDatos = false;
  final _nombreController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _verPassword = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final nombre = _nombreController.text.trim();
    final password = _passwordController.text.trim();

    if (nombre.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa todos los campos')),
      );
      return;
    }

    ref.read(authProvider.notifier).login(nombre, password);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final res = Responsive.of(context);

    // ← Escucha cambios de estado y navega al home cuando login es exitoso
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Bienvenido ${next.usuario.nombre}! 🌱')),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EC),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: res.maxFormWidth),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: res.wp(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '¡ HOLA !',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.outfit(
                      fontSize: res.sp(45),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFdb007f),
                      height: 1.1,
                    ),
                  ),
                  Text(
                    'BIENVENIDO',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.outfit(
                      fontSize: res.sp(45),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFdb007f),
                      height: 1.1,
                    ),
                  ),
                  SizedBox(height: res.hp(4)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inicia tu sesión',
                        style: GoogleFonts.outfit(
                          fontSize: res.sp(26),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFFdb007f),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RolSelectionScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFdb007f),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: res.wp(5),
                              vertical: res.hp(2),
                            ),
                          ),
                          child: Text(
                            'Tu eres..?',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: res.sp(14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(3)),
                  Text(
                    'Usuario',
                    style: GoogleFonts.outfit(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFdb007f),
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  SizedBox(
                    height: res.hp(6.5),
                    child: TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFdb007f).withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  Text(
                    'Contraseña',
                    style: GoogleFonts.outfit(
                      fontSize: res.sp(16),
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFdb007f),
                    ),
                  ),
                  SizedBox(height: res.hp(1)),
                  SizedBox(
                    height: res.hp(6.5),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_verPassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFdb007f).withOpacity(0.15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _verPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFFdb007f),
                          ),
                          onPressed: () =>
                              setState(() => _verPassword = !_verPassword),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(1.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _recordarDatos = !_recordarDatos),
                          child: Row(
                            children: [
                              Icon(
                                _recordarDatos
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                size: res.sp(16),
                                color: const Color(0xFFdb007f),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Recordar mis datos',
                                style: GoogleFonts.outfit(
                                  color: const Color(0xFFdb007f),
                                  fontSize: res.sp(13),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegistroScreen(),
                              ),
                            );
                          },
                          child: Text(
                            '¿No tienes cuenta?',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFdb007f),
                              fontSize: res.sp(13),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: res.hp(5)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: authState is AuthLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFdb007f),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: res.hp(2.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: authState is AuthLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'INICIAR SESIÓN',
                              style: GoogleFonts.outfit(
                                fontSize: res.sp(20),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
                  Center(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RecuperarPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          '¿Olvidaste tu contraseña?',
                          style: GoogleFonts.outfit(
                            color: const Color(0xFFdb007f),
                            fontSize: res.sp(13),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(4)),
                  Image.asset(
                    'assets/images/cabeza.png',
                    height: res.hp(12),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
