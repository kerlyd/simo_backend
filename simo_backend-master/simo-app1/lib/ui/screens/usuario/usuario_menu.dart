import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_notifier.dart';

const Color simoMagenta = Color(0xFFD8006B);
const Color simoAmarillo = Color(0xFFF5B800);
const Color simoAzul = Color(0xFF2D4EA2);
const Color simoCrudo = Color(0xFFF7F4EC);
const Color simoVerde = Color(0xFF3AAA35);
const Color simoRojo = Color(0xFFE8003D);
const Color textoOscuro = Color(0xFF333333);

class UsuarioMenuScreen extends ConsumerStatefulWidget {
  const UsuarioMenuScreen({super.key});

  @override
  ConsumerState<UsuarioMenuScreen> createState() => _UsuarioMenuScreenState();
}

class _UsuarioMenuScreenState extends ConsumerState<UsuarioMenuScreen> {
  @override
  Widget build(BuildContext context) {
    final usuario = ref.watch(authProvider).usuario;
    final puntos = usuario?.puntosVerdes ?? 0;

    return Scaffold(
      backgroundColor: simoMagenta,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
              decoration: const BoxDecoration(
                color: simoCrudo,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/imagenes/usuario/simo.png', height: 45),
                  Row(
                    children: [
                      Image.asset(
                        'assets/imagenes/usuario/icono_moneda.png',
                        height: 35,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$puntos',
                        style: const TextStyle(
                          color: simoAzul,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(width: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, '/notificaciones'),
                          child: Image.asset(
                            'assets/imagenes/usuario/campana.png',
                            height: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Column Izquierda
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: InkWell(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      '/editar_usuario',
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: simoAmarillo,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Editar\ninformación',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: simoAzul,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: simoAmarillo,
                                          width: 4,
                                        ),
                                      ),
                                      child: const CircleAvatar(
                                        radius: 45,
                                        backgroundColor: simoCrudo,
                                        backgroundImage: AssetImage(
                                          'assets/imagenes/usuario/usuario.png',
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -15,
                                      child: Container(
                                        width: 80,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: simoAmarillo,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          usuario?.nombre ?? "Nombre",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: textoOscuro,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            height: 1.1,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () {
                                      ref.read(authProvider.notifier).logout();
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        '/login',
                                        (route) => false,
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFD4D4D4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'Cerrar sesión',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: textoOscuro,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 15),
                          // Column Derecha: Info Card
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 18,
                              ),
                              decoration: BoxDecoration(
                                color: simoCrudo,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Center(
                                    child: Text(
                                      '¡Mi información!',
                                      style: TextStyle(
                                        color: simoMagenta,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildInfoItem(
                                    'Nombre',
                                    '${usuario?.nombre ?? "Usuario"} (${usuario?.cedula ?? ""})',
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoItem(
                                    'Teléfono',
                                    usuario?.telefono ?? "",
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoItem(
                                    'Dirección',
                                    usuario?.direccion ?? "",
                                  ),
                                  const SizedBox(height: 10),
                                  _buildInfoItem(
                                    'Correo electrónico',
                                    usuario?.email ?? "",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/notificaciones',
                            arguments: 1,
                          ),
                          child: _buildFullWidthButton('Historial'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/notificaciones'),
                          child: _buildFullWidthButton('Notificaciones'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        decoration: BoxDecoration(
                          color: simoCrudo,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '¡Impacto con SIMÖ!',
                              style: TextStyle(
                                color: simoMagenta,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 65,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Has reciclado 3 dispositivos\n',
                                              style: TextStyle(
                                                color: textoOscuro,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w500,
                                                height: 1.4,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'Evitaste 12 kg de residuos\nelectrónicos',
                                              style: TextStyle(
                                                color: textoOscuro,
                                                fontSize: 12.5,
                                                fontWeight: FontWeight.w800,
                                                height: 1.4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Gracias por ayudar a reducir la\ncontaminación y construir una\nMedellín más sostenible.',
                                        style: TextStyle(
                                          color: textoOscuro,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w500,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 35,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 4.0,
                                    ),
                                    child: Image.asset(
                                      'assets/imagenes/usuario/reciclaje.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            const Center(
                              child: Text(
                                '¡Muchas gracias por ser parte del cambio!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: textoOscuro,
                                  fontSize: 12.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 20),
        decoration: const BoxDecoration(
          color: simoCrudo,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildBottomNavItem(
              'Inicio',
              'assets/imagenes/usuario/icono_inicio.png',
              false,
              onTap: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            _buildBottomNavItem(
              'Opciones',
              'assets/imagenes/usuario/icono_opciones.png',
              false,
              onTap: () => Navigator.pushReplacementNamed(context, '/opciones'),
            ),
            _buildBottomNavItem(
              'Canjear',
              'assets/imagenes/usuario/icono_canjear.png',
              false,
              onTap: () => Navigator.pushReplacementNamed(context, '/canjear'),
            ),
            _buildBottomNavItem(
              'Usuario',
              'assets/imagenes/usuario/icono_usuario.png',
              true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0, right: 8.0),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: simoMagenta,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: simoMagenta,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: textoOscuro,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullWidthButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: simoCrudo,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: textoOscuro,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    String label,
    String iconPath,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(iconPath, height: 32),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: textoOscuro,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 3,
              width: 40,
              color: isSelected ? simoMagenta : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
