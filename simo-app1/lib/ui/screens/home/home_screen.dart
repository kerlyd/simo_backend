import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../providers/auth_notifier.dart';
import '../../../data/models/dispositivo_model.dart';
import '../../../data/datasources/dispositivo_remote_datasource.dart';
import '../../../injection_container.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  List<DispositivoModel> _articulosActivos = [];
  bool _loadingArticulos = true;

  @override
  void initState() {
    super.initState();
    _fetchArticulos();
  }

  Future<void> _fetchArticulos() async {
    try {
      final data = await sl<DispositivoRemoteDataSource>().getTiposDispositivo();
      if (mounted) {
        // Filtrar para mostrar Refrigerador y TV
        final articulos = data.where((d) {
          final n = d.nombre.toLowerCase();
          return n.contains('refrig') || n.contains('nevera') ||
                 n.contains('tv') || n.contains('televisor') ||
                 n.contains('pantalla') || n.contains('monitor');
        }).take(2).toList();
        setState(() {
          _articulosActivos = articulos;
          _loadingArticulos = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loadingArticulos = false);
    }
  }

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    switch (index) {
      case 0:
        // Already here
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/opciones');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/canjear');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/usuario');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final puntos = authState.usuario?.puntosVerdes ?? 0;

    return Scaffold(
      backgroundColor: AppColors.simoAzul,
      body: Column(
        children: [
          SimoHeader(
            puntos: puntos,
            onNotificationTap: () =>
                Navigator.pushNamed(context, '/notificaciones'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sabias que banner
                  _buildInfographicCard(),

                  const SizedBox(height: 24),

                  // Que quieres hacer hoy
                  const Center(
                    child: Text(
                      '¿Que quieres hacer hoy?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botones de accion principal
                  _buildActionGrid(),

                  const SizedBox(height: 32),

                  // Artículos activos
                  const Text(
                    '¡Artículos activos!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  _buildArticulosSection(),

                  const SizedBox(height: 32),

                  // Impacto con SIMO
                  _buildImpactCard(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SimoBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildInfographicCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola soy SIMÖ ¿Sabías que...?',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Un celular reciclado correctamente puede recuperar materiales reutilizables como oro, cobre y aluminio.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.simoAmarillo,
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Cuentame mas...',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/imagenes/opciones/robotinicio.png',
                  height: 110,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionGrid() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildSquareButton(
                imagePath: 'assets/imagenes/opciones/regaloinicio.png',
                iconColor: const Color(0xFFE88A96),
                title: 'Recompensas',
                onTap: () => Navigator.pushNamed(context, '/canjear'),
              ),
              const SizedBox(height: 16),
              _buildSquareButton(
                icon: Icons.person,
                iconColor: const Color(0xFF4A4A4A),
                title: 'Mi info',
                onTap: () => Navigator.pushNamed(context, '/usuario'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/opciones'),
              child: Container(
              height: 236,
              decoration: BoxDecoration(
                color: AppColors.simoCrudo,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/usuario/reciclaje.png',
                    height: 130,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '¡Reciclar!',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.simoAzul,
                    ),
                  ),
                ],
              ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSquareButton({
    IconData? icon,
    String? imagePath,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 110,
          decoration: BoxDecoration(
            color: AppColors.simoCrudo,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imagePath != null)
                Image.asset(imagePath, height: 50, fit: BoxFit.contain)
              else if (icon != null)
                Icon(icon, size: 48, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getIconPath(String nombre) {
    final n = nombre.toLowerCase();
    if (n.contains('celular') || n.contains('telefon')) return 'assets/imagenes/opciones/celular.png';
    if (n.contains('laptop') || n.contains('computador') || n.contains('portatil')) return 'assets/imagenes/opciones/laptop.png';
    if (n.contains('tv') || n.contains('televisor') || n.contains('pantalla') || n.contains('monitor')) return 'assets/imagenes/opciones/tv.png';
    if (n.contains('refrig') || n.contains('nevera')) return 'assets/imagenes/opciones/refrigerador.png';
    if (n.contains('cable') || n.contains('cargador')) return 'assets/imagenes/opciones/cables.png';
    if (n.contains('bateria') || n.contains('batería')) return 'assets/imagenes/opciones/bateria.png';
    if (n.contains('tablet') || n.contains('tableta')) return 'assets/imagenes/opciones/tablet_icono.png';
    if (n.contains('consola') || n.contains('juego')) return 'assets/imagenes/opciones/consolasdejuegos.png';
    if (n.contains('mouse') || n.contains('teclado')) return 'assets/imagenes/opciones/mouse.png';
    if (n.contains('microondas')) return 'assets/imagenes/opciones/microondas.png';
    if (n.contains('ventilador')) return 'assets/imagenes/opciones/ventilador.png';
    if (n.contains('plancha')) return 'assets/imagenes/opciones/plancha.png';
    if (n.contains('licuadora')) return 'assets/imagenes/opciones/licuadora.png';
    return 'assets/imagenes/opciones/otrosdispositivos.png';
  }

  Widget _buildArticulosSection() {
    if (_loadingArticulos) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
    if (_articulosActivos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.simoCrudo,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'No hay artículos disponibles',
            style: TextStyle(color: Color(0xFF888888)),
          ),
        ),
      );
    }
    return Column(
      children: [
        for (int i = 0; i < _articulosActivos.length; i++) ...[
          _buildArticuloCard(_articulosActivos[i]),
          if (i < _articulosActivos.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildArticuloCard(DispositivoModel disp) {
    final iconPath = _getIconPath(disp.nombre);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icono del dispositivo
            Container(
              width: 100,
              decoration: const BoxDecoration(
                color: AppColors.simoAmarillo,
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(iconPath, height: 56, fit: BoxFit.contain),
                  const SizedBox(height: 4),
                  Text(
                    disp.nombre,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF424242),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      disp.nombre,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      disp.descripcion ?? 'Artículo disponible para reciclar',
                      style: const TextStyle(fontSize: 11, color: Colors.black54),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.simoAzul.withAlpha(30),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Disponible',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.simoAzul,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/canjear/flor.png',
                    height: 22,
                    width: 22,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${disp.puntos}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const Text(
                    'pts',
                    style: TextStyle(
                      fontSize: 9,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w600,
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

  Widget _buildImpactCard() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.simoCrudo,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Impacto con SIMÖ!',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.simoAzul,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Has reciclado 3 dispositivos\nEvitaste 12 kg de residuos electrónicos',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Dale click a SIMÖ y descubre más en nuestro sitio web.',
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '¡Muchas gracias, Por tu ayudar!',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3), // Menos espacio para evitar que el bloque se alargue
            ],
          ),
        ),
        Positioned(
          right: -100,
          top: 0,
          bottom: 0,
          child: Align(
            alignment: Alignment.center,
            child: Transform.rotate(
              angle: -1.45, // Rotado 5 grados más
              child: Image.asset(
                'assets/images/robot.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
