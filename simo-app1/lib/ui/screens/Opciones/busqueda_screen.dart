import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../providers/auth_notifier.dart';
import '../../../data/models/dispositivo_model.dart';
import '../../../data/datasources/dispositivo_remote_datasource.dart';
import '../../../injection_container.dart';
import 'detalle_solicitud_screen.dart';
import 'opciones_screen.dart';

class BusquedaScreen extends ConsumerStatefulWidget {
  const BusquedaScreen({super.key});

  @override
  ConsumerState<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends ConsumerState<BusquedaScreen> {
  String? selectedDispositivo;
  dynamic selectedIcon;
  dynamic selectedDispositivoId;
  int? selectedPuntos;
  final TextEditingController _searchController = TextEditingController();

  List<DispositivoModel> _allDispositivos = [];
  List<DispositivoModel> _filteredDispositivos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchDispositivos();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _fetchDispositivos() async {
    try {
      final data = await sl<DispositivoRemoteDataSource>().getTiposDispositivo();
      if (mounted) {
        setState(() {
          _allDispositivos = data;
          _filteredDispositivos = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar dispositivos: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    final text = _searchController.text.toLowerCase().trim();
    setState(() {
      if (text.isEmpty) {
        _filteredDispositivos = List.from(_allDispositivos);
      } else {
        final matches = _allDispositivos
            .where((d) => d.nombre.toLowerCase().contains(text))
            .toList();
        matches.sort((a, b) {
          final aStarts = a.nombre.toLowerCase().startsWith(text);
          final bStarts = b.nombre.toLowerCase().startsWith(text);
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          return a.nombre.compareTo(b.nombre);
        });
        _filteredDispositivos = matches;
      }
    });
  }

  String _getIconPath(String nombre) {
    final n = nombre.toLowerCase();
    if (n.contains('celular') || n.contains('telefon') || n.contains('smartphone')) {
      return 'assets/imagenes/opciones/celular.png';
    } else if (n.contains('laptop') || n.contains('computador') || n.contains('portatil') || n.contains('portátil')) {
      return 'assets/imagenes/opciones/laptop.png';
    } else if (n.contains('tv') || n.contains('televisor') || n.contains('pantalla') || n.contains('monitor')) {
      return 'assets/imagenes/opciones/tv.png';
    } else if (n.contains('refrig') || n.contains('nevera')) {
      return 'assets/imagenes/opciones/refrigerador.png';
    } else if (n.contains('cable') || n.contains('cargador')) {
      return 'assets/imagenes/opciones/cables.png';
    } else if (n.contains('batería') || n.contains('bateria')) {
      return 'assets/imagenes/opciones/bateria.png';
    } else if (n.contains('tablet') || n.contains('tableta') || n.contains('ipad')) {
      return 'assets/imagenes/opciones/tablet_icono.png';
    } else if (n.contains('consola') || n.contains('juego') || n.contains('gaming')) {
      return 'assets/imagenes/opciones/consolasdejuegos.png';
    } else if (n.contains('mouse') || n.contains('teclado') || n.contains('ratón') || n.contains('raton')) {
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final puntos = ref.watch(authProvider).usuario?.puntosVerdes ?? 0;

    return Scaffold(
      backgroundColor: AppColors.simoAzul,
      appBar: SimoHeader(
        showBackButton: true,
        showLogo: false,
        puntos: puntos,
        onBackPressed: () => _showConfirmarCancelacion(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.simoCrudo,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF424242),
                        size: 20,
                      ),
                      border: InputBorder.none,
                      hintText: 'Busca tu dispositivo...',
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                    style: const TextStyle(
                      color: AppColors.simoAzul,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                _buildContent(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SimoBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const OpcionesScreen()),
              (route) => false,
            );
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    if (selectedDispositivo != null) {
      return Column(
        children: [
          const Text(
            'Elige el destino de tu dispositivo:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          _buildDestinoCard(
            aliado: 'EcoTech',
            direccion: 'Calle 50 #45-23, Medellín',
            metodo: 'Lo llevas tú',
            puntos: selectedPuntos ?? 0,
            colorBoton: const Color(0xFFD3CFCF),
          ),
          const SizedBox(height: 8),
          _buildDestinoCard(
            aliado: 'Monterray',
            direccion: 'Carrera 48 # 10-45',
            metodo: 'Lo recogemos',
            puntos: selectedPuntos ?? 0,
            colorBoton: AppColors.simoAmarillo,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                selectedDispositivo = null;
                selectedIcon = null;
                selectedDispositivoId = null;
                selectedPuntos = null;
              });
            },
            child: const Text(
              'Cambiar dispositivo',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    }

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(40),
        child: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: _filteredDispositivos.isEmpty
          ? const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'No se encontraron dispositivos',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF888888)),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 2),
              itemCount: _filteredDispositivos.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.black.withAlpha(51),
                indent: 10,
                endIndent: 10,
              ),
              itemBuilder: (context, index) {
                final d = _filteredDispositivos[index];
                final iconPath = _getIconPath(d.nombre);
                return _buildItem(d.nombre, iconPath, d.id, d.puntos);
              },
            ),
    );
  }

  void _showConfirmarCancelacion(BuildContext context) {
    if (selectedDispositivo == null) {
      Navigator.pop(context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.simoCrudo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          '¿Deseas cancelar la solicitud?',
          style: TextStyle(
            color: AppColors.simoMagenta,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'Si sales ahora, se perderán los datos de selección actuales.',
          style: TextStyle(color: Color(0xFF424242)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(
                color: Color(0xFF6E6E6E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Aceptar',
              style: TextStyle(
                color: AppColors.simoMagenta,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String name, String iconPath, dynamic id, int puntos) {
    final bool isSelected = selectedDispositivo == name;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDispositivo = name;
            selectedIcon = iconPath;
            selectedDispositivoId = id;
            selectedPuntos = puntos;
          });
        },
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.simoAmarillo.withAlpha(51)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Image.asset(iconPath, height: 15, width: 15, fit: BoxFit.contain),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF424242),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Image.asset(
                    'assets/imagenes/canjear/flor.png',
                    height: 14,
                    width: 14,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$puntos',
                    style: const TextStyle(
                      color: Color(0xFF424242),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              if (isSelected) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.check_circle,
                  color: AppColors.simoAmarillo,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestinoCard({
    required String aliado,
    required String direccion,
    required String metodo,
    required int puntos,
    required Color colorBoton,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetalleSolicitudScreen(
                dispositivoLabel: selectedDispositivo!,
                dispositivoId: selectedDispositivoId,
                dispositivoIcon: selectedIcon!,
                destinoAliado: aliado,
                destinoDireccion: direccion,
                metodoEntrega: metodo,
                puntos: selectedPuntos ?? puntos,
              ),
            ),
          );
        },
        child: Container(
          height: 72,
          margin: const EdgeInsets.only(bottom: 6),
          decoration: BoxDecoration(
            color: AppColors.simoCrudo,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.simoAmarillo,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: 6,
                      right: 8,
                      child: Text(
                        '1x',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 10,
                          color: Color(0xFF424242),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (selectedIcon != null)
                            Image.asset(
                              selectedIcon!,
                              height: 28,
                              width: 28,
                              fit: BoxFit.contain,
                            ),
                          const SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                              selectedDispositivo ?? '',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF424242),
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
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
                                fontSize: 11,
                                color: Color(0xFF424242),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              direccion,
                              style: const TextStyle(
                                fontSize: 8,
                                color: Color(0xFF6E6E6E),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: colorBoton,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                metodo,
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF424242),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/imagenes/canjear/flor.png',
                            height: 22,
                            width: 22,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '$puntos',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
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
}
