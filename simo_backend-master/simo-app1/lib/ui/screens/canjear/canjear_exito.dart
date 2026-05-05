import 'package:flutter/material.dart';

class CanjearExitoScreen extends StatefulWidget {
  const CanjearExitoScreen({super.key});

  @override
  State<CanjearExitoScreen> createState() => _CanjearExitoScreenState();
}

class _CanjearExitoScreenState extends State<CanjearExitoScreen> {
  static const Color simoMagenta = Color(0xFFD8006B);
  static const Color simoCrudo = Color(0xFFFFFCE7);
  static const Color textoOscuro = Color(0xFF333333);
  static const Color simoAmarillo = Color(0xFFF5B800);

  int _selectedNavIndex = 2;

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }

  void _onNavTap(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/busqueda');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/opciones');
        break;
      case 2:
        _showMessage('Ya estás en Canjear.');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/usuario');
        break;
    }
  }

  Widget _buildNavItem(String iconName, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onNavTap(index),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/imagenes/canjear/$iconName',
                width: 24,
                height: 24,
                color: isSelected ? simoMagenta : textoOscuro,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? simoMagenta : textoOscuro,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: simoMagenta,
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            _buildNavItem('Inicio_icono.png', 'Inicio', 0),
            _buildNavItem('opciones_icono.png', 'Opciones', 1),
            _buildNavItem('Canjear_icono.png', 'Canjear', 2),
            _buildNavItem('usuario_icono.png', 'Usuario', 3),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: simoCrudo,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.arrow_back_ios_new, size: 36, color: textoOscuro),
                  ),
                ),
                const Spacer(),
                Image.asset('assets/imagenes/canjear/simo.png', height: 48),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/notificaciones'),
                    child: Image.asset(
                      'assets/imagenes/canjear/notificacion.png',
                      width: 42,
                      height: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFCE7),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0xFF2D4EA2),
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              '¡Listo! Canjeaste tus puntos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textoOscuro,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Gracias por ayudar al planeta. Ya puedes disfrutar tu recompensa.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textoOscuro,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Revisa tu correo electrónico y disfruta tu recompensa.\nAllí encontrarás cómo usar tu beneficio.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: textoOscuro,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Aprovecha tus puntos y gracias por ser parte del cambio',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              _buildRewardCard('falabella.png', '1200'),
                              const SizedBox(height: 10),
                              _buildRewardCard('puntos_colombia.png', '900'),
                              const SizedBox(height: 10),
                              _buildRewardCard('bettys.png', '1200'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildRewardCard(String logoName, String points) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                child: Image.asset(
                  'assets/imagenes/canjear/$logoName',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              width: 96,
              decoration: const BoxDecoration(
                color: simoAmarillo,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/canjear/flor_negro.png',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    points,
                    style: const TextStyle(
                      color: textoOscuro,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Canjear',
                    style: TextStyle(
                      color: textoOscuro,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
