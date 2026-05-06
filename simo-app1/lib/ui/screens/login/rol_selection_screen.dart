import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'usuario_reciclador_screen.dart';
import '../../utils/responsive.dart';

class RolSelectionScreen extends StatefulWidget {
  const RolSelectionScreen({super.key});

  @override
  State<RolSelectionScreen> createState() => _RolSelectionScreenState();
}

class _RolSelectionScreenState extends State<RolSelectionScreen> {
  String _rolSeleccionado = 'reciclador';
  bool _mostrarProximamente = false;

  @override
  Widget build(BuildContext context) {
    final res = Responsive.of(context);
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

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
                  Text(
                    'Inicia tu sesión',
                    style: GoogleFonts.outfit(
                      fontSize: res.sp(28),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFFdb007f),
                    ),
                  ),
                  SizedBox(height: res.hp(3)),
                  Container(
                    padding: EdgeInsets.all(res.wp(5)),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '¿Qué rol tienes\nen SIMÖ?',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: res.sp(16),
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: res.hp(2)),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(
                                  () => _rolSeleccionado = 'reciclador',
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: res.hp(1.8),
                                    horizontal: res.wp(2),
                                  ),
                                  decoration: BoxDecoration(
                                    color: _rolSeleccionado == 'reciclador'
                                        ? const Color(0xFFdb007f)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Usuario\nReciclador',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: res.sp(13),
                                      fontWeight: FontWeight.w700,
                                      color: _rolSeleccionado == 'reciclador'
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: res.wp(3)),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _mostrarProximamente = true;
                                  });
                                  Future.delayed(const Duration(seconds: 2), () {
                                    if (mounted) {
                                      setState(
                                          () => _mostrarProximamente = false);
                                    }
                                  });
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        vertical: res.hp(1.8),
                                        horizontal: res.wp(2),
                                      ),
                                      decoration: BoxDecoration(
                                        color: _rolSeleccionado == 'aliado'
                                            ? const Color(0xFFdb007f)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Aliado\nRecolector',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.outfit(
                                          fontSize: res.sp(13),
                                          fontWeight: FontWeight.w700,
                                          color: _rolSeleccionado == 'aliado'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                    if (_mostrarProximamente)
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Próximamente',
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: res.sp(12),
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
                          ],
                        ),
                        SizedBox(height: res.hp(1.5)),
                        Text(
                          'Elige si reciclas o recibes dispositivos.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: res.sp(12),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: res.hp(5)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_rolSeleccionado == 'reciclador') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UsuarioRecicladorScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFdb007f),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: res.hp(2.5)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'CONTINUAR',
                        style: GoogleFonts.outfit(
                          fontSize: res.sp(20),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: res.hp(2)),
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
