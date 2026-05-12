import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../widgets/widgetsopciones/dispositivo_icon_card.dart';
import '../../providers/auth_notifier.dart';
import 'busqueda_screen.dart';
import 'detalle_solicitud_screen.dart';
import '../../../data/models/dispositivo_model.dart';
import '../../../data/models/punto_reciclaje_model.dart';
import '../../../data/datasources/dispositivo_remote_datasource.dart';
import '../../../data/datasources/punto_reciclaje_remote_datasource.dart';
import '../../../injection_container.dart';

class OpcionesScreen extends ConsumerStatefulWidget {
  const OpcionesScreen({super.key});

  @override
  ConsumerState<OpcionesScreen> createState() => _OpcionesScreenState();
}

class _OpcionesScreenState extends ConsumerState<OpcionesScreen>
    with TickerProviderStateMixin {
  String? selectedDispositivo;
  String? selectedIconPath;
  int? selectedPuntos;
  dynamic selectedDispositivoId;
  late AnimationController _controller;

  List<DispositivoModel> _apiDispositivos = [];
  List<PuntoReciclajeModel> _apiPuntos = [];
  bool _loading = true;

  final Map<String, String> iconMapping = {
    'Celular': 'assets/imagenes/opciones/celular.png',
    'Laptop': 'assets/imagenes/opciones/laptop.png',
    'Pantallas o TV': 'assets/imagenes/opciones/tv.png',
    'Refrigerador': 'assets/imagenes/opciones/refrigerador.png',
    'Cables': 'assets/imagenes/opciones/cables.png',
    'Otros Dispositivos': 'assets/imagenes/opciones/otrosdispositivos.png',
  };

  // Búsqueda flexible por palabras clave (ignora mayúsculas, tildes, etc.)
  String _getIconPath(String nombre) {
    final n = nombre.toLowerCase();
    if (n.contains('celular') ||
        n.contains('telefon') ||
        n.contains('smartphone')) {
      return 'assets/imagenes/opciones/celular.png';
    } else if (n.contains('laptop') ||
        n.contains('computador') ||
        n.contains('portátil') ||
        n.contains('portatil')) {
      return 'assets/imagenes/opciones/laptop.png';
    } else if (n.contains('tv') ||
        n.contains('televisor') ||
        n.contains('pantalla') ||
        n.contains('monitor')) {
      return 'assets/imagenes/opciones/tv.png';
    } else if (n.contains('refrig') || n.contains('nevera')) {
      return 'assets/imagenes/opciones/refrigerador.png';
    } else if (n.contains('cable') || n.contains('cargador')) {
      return 'assets/imagenes/opciones/cables.png';
    } else if (n.contains('batería') || n.contains('bateria')) {
      return 'assets/imagenes/opciones/bateria.png';
    } else if (n.contains('tablet') ||
        n.contains('tableta') ||
        n.contains('ipad')) {
      return 'assets/imagenes/opciones/tablet_icono.png';
    } else if (n.contains('consola') ||
        n.contains('juego') ||
        n.contains('gaming')) {
      return 'assets/imagenes/opciones/consolasdejuegos.png';
    } else if (n.contains('mouse') ||
        n.contains('teclado') ||
        n.contains('ratón')) {
      return 'assets/imagenes/opciones/mouse.png';
    } else if (n.contains('microondas')) {
      return 'assets/imagenes/opciones/microondas.png';
    } else if (n.contains('ventilador') || n.contains('abanico')) {
      return 'assets/imagenes/opciones/ventilador.png';
    } else if (n.contains('plancha')) {
      return 'assets/imagenes/opciones/plancha.png';
    } else if (n.contains('licuadora') || n.contains('blender')) {
      return 'assets/imagenes/opciones/licuadora.png';
    } else {
      return 'assets/imagenes/opciones/otrosdispositivos.png';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _fetchDispositivos();
  }

  Future<void> _fetchDispositivos() async {
    try {
      final dispositivoDS = sl<DispositivoRemoteDataSource>();
      final puntoDS = sl<PuntoReciclajeRemoteDataSource>();

      final results = await Future.wait([
        dispositivoDS.getTiposDispositivo(),
        puntoDS.getPuntosReciclaje(),
      ]);

      setState(() {
        _apiDispositivos = results[0] as List<DispositivoModel>;
        _apiPuntos = results[1] as List<PuntoReciclajeModel>;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puntos = ref.watch(authProvider).usuario?.puntosVerdes ?? 0;

    return Scaffold(
      backgroundColor: AppColors.simoAzul,
      appBar: SimoHeader(
        puntos: puntos,
        onNotificationTap: () =>
            Navigator.pushNamed(context, '/notificaciones'),
        onLogoTap: () => Navigator.pushReplacementNamed(context, '/home'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Barra de búsqueda ────────────────────────────────
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.simoCrudo,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  alignment: Alignment.center,
                  child: TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BusquedaScreen()),
                      );
                    },
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 36,
                        minHeight: 18,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                        size: 20,
                      ),
                      hintText: 'Busca tu dispositivo...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ── Grid de dispositivos ───────────────────────────
              Expanded(
                flex: selectedDispositivo == null ? 5 : 3,
                child: _loading
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.simoAmarillo))
                    : Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _buildGridItem(0)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildGridItem(1)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildGridItem(2)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(child: _buildGridItem(3)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildGridItem(4)),
                                const SizedBox(width: 8),
                                Expanded(child: _buildGridItem(5)),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 8),

              // ── Texto de instrucción ─────────────────────────────
              const Text(
                '¡Elige el destino de tu dispositivo Y comunicate!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 8),

              // ── Área inferior: Destinos o Espera ─────────────────
              Expanded(
                flex: selectedDispositivo == null ? 5 : 6,
                child: selectedDispositivo == null
                    ? _buildWaitingCard()
                    : _buildDestinationsList(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SimoBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) return;
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/canjear');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/usuario');
              break;
          }
        },
      ),
    );
  }

  Widget _buildWaitingCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedDot(controller: _controller, delay: 0),
              const SizedBox(width: 14),
              _AnimatedDot(controller: _controller, delay: 0.2),
              const SizedBox(width: 14),
              _AnimatedDot(controller: _controller, delay: 0.4),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Esperando elección...',
            style: TextStyle(
              color: Color(0xFF424242),
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsList() {
    if (_apiPuntos.isEmpty) {
      return const Center(
        child: Text(
          'No hay puntos de reciclaje disponibles',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: _apiPuntos.length,
      itemBuilder: (context, index) {
        final punto = _apiPuntos[index];
        // Alternamos colores y métodos para simular variedad (esto podría venir de la DB)
        final isEven = index % 2 == 0;
        return _buildDestinationItem(
          id: punto.id,
          aliado: punto.nombre,
          direccion: punto.direccion,
          metodo: isEven ? 'Lo llevas tú' : 'Lo recogemos',
          puntos: selectedPuntos ?? 0,
          colorBoton: isEven ? const Color(0xFFD3CFCF) : AppColors.simoAmarillo,
          textColorBoton: const Color(0xFF424242),
        );
      },
    );
  }

  Widget _buildDestinationItem({
    required dynamic id,
    required String aliado,
    required String direccion,
    required String metodo,
    required int puntos,
    required Color colorBoton,
    required Color textColorBoton,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _navigateToConfirm(id, aliado, direccion, metodo),
        child: Container(
          height: 108,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.simoCrudo,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              // Sección Amarilla (Izquierda)
              Container(
                width: 108,
                height: 108,
                decoration: const BoxDecoration(
                  color: AppColors.simoAmarillo,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(22),
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 10,
                      right: 14,
                      child: Text(
                        '1x',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (selectedIconPath != null)
                            Image.asset(
                              selectedIconPath!,
                              height: 44,
                              width: 44,
                              fit: BoxFit.contain,
                            ),
                          const SizedBox(height: 6),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              selectedDispositivo ?? '',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF424242),
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Sección Cruda (Derecha)
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text(
                              'Destino: $aliado',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 13, // Ajustado para que quepa mejor
                                color: Color(0xFF333333),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              direccion,
                              style: const TextStyle(
                                fontSize: 10, // Más pequeño como en la referencia
                                color: Color(0xFF6E6E6E),
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: colorBoton,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                metodo,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF424242),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Puntos
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/imagenes/canjear/flor.png',
                            height: 36,
                            width: 36,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$puntos',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Color(0xFF424242),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToConfirm(
      dynamic puntoId, String destino, String direccion, String metodo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleSolicitudScreen(
          dispositivoLabel: selectedDispositivo!,
          dispositivoId: selectedDispositivoId!,
          dispositivoIcon: selectedIconPath!,
          destinoAliado: destino,
          destinoDireccion: direccion,
          metodoEntrega: metodo,
          puntos: selectedPuntos ?? 0,
          puntoId: puntoId,
        ),
      ),
    );
  }

  Widget _buildGridItem(int index) {
    if (index >= _apiDispositivos.length) return const SizedBox();
    final disp = _apiDispositivos[index];
    final label = disp.nombre;
    final iconPath = _getIconPath(label);

    return DispositivoIconCard(
      label: label,
      imagePath: iconPath,
      isSelected: selectedDispositivo == label,
      onTap: () {
        if (label == 'Otros Dispositivos') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const BusquedaScreen()),
          );
        } else {
          setState(() {
            if (selectedDispositivo == label) {
              selectedDispositivo = null;
              selectedIconPath = null;
              selectedPuntos = null;
              selectedDispositivoId = null;
            } else {
              selectedDispositivo = label;
              selectedIconPath = iconPath;
              selectedPuntos = disp.puntos;
              selectedDispositivoId = disp.id;
            }
          });
        }
      },
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  final AnimationController controller;
  final double delay;

  const _AnimatedDot({required this.controller, required this.delay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double value = (controller.value - delay).clamp(0.0, 1.0);
        final double scale = 1.0 +
            (0.3 *
                Curves.easeInOut.transform(
                  value == 0 || value == 1
                      ? 0
                      : (value < 0.5 ? value * 2 : (1 - value) * 2),
                ));
        final double opacity = 0.4 +
            (0.6 *
                Curves.easeInOut.transform(
                  value == 0 || value == 1
                      ? 0
                      : (value < 0.5 ? value * 2 : (1 - value) * 2),
                ));

        return Opacity(
          opacity: opacity,
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Color(0xFF4E4E4E),
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
