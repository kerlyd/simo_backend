import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'registro_screen.dart';
import '../../providers/auth_notifier.dart';
import '../../utils/responsive.dart';

class UsuarioRecicladorScreen extends ConsumerStatefulWidget {
  const UsuarioRecicladorScreen({super.key});

  @override
  ConsumerState<UsuarioRecicladorScreen> createState() =>
      _UsuarioRecicladorScreenState();
}

class _UsuarioRecicladorScreenState
    extends ConsumerState<UsuarioRecicladorScreen> {
  bool _recordarDatos = true;
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
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bienvenido ${next.usuario.nombre}')),
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
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Align(
                alignment: const Alignment(0, 0.65),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: res.maxFormWidth),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: res.wp(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '¡ HOLA !',
                            style: GoogleFonts.outfit(
                              fontSize: res.sp(44),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFdb007f),
                              height: 1.1,
                            ),
                          ),
                        ),
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'BIENVENIDO',
                            style: GoogleFonts.outfit(
                              fontSize: res.sp(44),
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFFdb007f),
                              height: 1.1,
                            ),
                          ),
                        ),
                        SizedBox(height: res.hp(4)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Inicia tu sesión',
                              style: GoogleFonts.outfit(
                                fontSize: res.sp(22),
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFFdb007f),
                              ),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: () => Navigator.pop(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFdb007f),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: res.wp(8),
                                    vertical: res.hp(1),
                                  ),
                                ),
                                child: Text(
                                  'Usuario\nReciclador',
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
                            fontSize: res.sp(15),
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
                              fillColor:
                                  const Color(0xFFdb007f).withOpacity(0.15),
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
                            fontSize: res.sp(15),
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
                              fillColor:
                                  const Color(0xFFdb007f).withOpacity(0.15),
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
                                onPressed: () => setState(
                                    () => _verPassword = !_verPassword),
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
                                onTap: () => setState(
                                    () => _recordarDatos = !_recordarDatos),
                                child: Row(
                                  children: [
                                    Icon(
                                      _recordarDatos
                                          ? Icons.circle
                                          : Icons.radio_button_unchecked,
                                      size: res.sp(14),
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
                                        builder: (_) => const RegistroScreen()),
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
                        Center(
                          child: SizedBox(
                            width: res.wp(60),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed:
                                    authState is AuthLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFdb007f),
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  padding: EdgeInsets.symmetric(
                                      vertical: res.hp(2.5)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: authState is AuthLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : Text(
                                        'INICIAR SESIÓN',
                                        style: GoogleFonts.outfit(
                                          fontSize: res.sp(20),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: res.hp(1.5)),
                        Center(
                          child: Text(
                            '¿Tienes problemas al iniciar sesión? Te ayudamos.',
                            style: GoogleFonts.outfit(
                              color: const Color(0xFFdb007f),
                              fontSize: res.sp(12),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: res.hp(4)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (!isKeyboardOpen)
              Image.asset(
                'assets/images/cabeza.png',
                height: res.hp(12),
                alignment: Alignment.bottomCenter,
              ),
          ],
        ),
      ),
    );
  }
}
