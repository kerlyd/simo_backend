import 'package:flutter/material.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: simoMagenta,
      bottomNavigationBar: SimoBottomNav(
        currentIndex: 2,
        onTap: (index) => _onNavTap(index),
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
            padding: EdgeInsets.fromLTRB(
                16, MediaQuery.of(context).padding.top + 16, 16, 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.arrow_back_ios_new,
                        size: 36, color: textoOscuro),
                  ),
                ),
                const Spacer(),
                Image.asset('assets/imagenes/canjear/simo.png', height: 48),
                const Spacer(),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, '/notificaciones'),
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
                          _buildRewardCard('falabella.png', '1200', '50% Descuento en Productos'),
                          const SizedBox(height: 10),
                          _buildRewardCard('puntos_colombia.png', '900', '200 Puntos Colombia'),
                          const SizedBox(height: 10),
                          _buildRewardCard('bettys.png', '1200', '45% Descuento en comida'),
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

  Widget _buildRewardCard(String logoName, String points, String title) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: simoMagenta,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      'assets/imagenes/canjear/$logoName',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 110,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/imagenes/canjear/flor_negro.png',
                        width: 28,
                        height: 28,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        points,
                        style: const TextStyle(
                          color: textoOscuro,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Canjear',
                    style: TextStyle(
                      color: textoOscuro,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
