import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'canjear_confirmacion.dart';
import '../../providers/auth_notifier.dart';
import '../../../injection_container.dart';
import '../../../data/datasources/recompensa_remote_datasource.dart';
import '../../../data/models/recompensa_model.dart';

class CanjearPrincipal extends ConsumerStatefulWidget {
  const CanjearPrincipal({super.key});

  @override
  ConsumerState<CanjearPrincipal> createState() => _CanjearPrincipalState();
}

class _CanjearPrincipalState extends ConsumerState<CanjearPrincipal> {
  static const Color simoMagenta = Color(0xFFD8006B);
  static const Color simoAmarillo = Color(0xFFF5B800);
  static const Color simoCrudo = Color(0xFFF7F4EC);
  static const Color textoOscuro = Color(0xFF333333);

  int _selectedNavIndex = 2;
  int _selectedRewardIndex = -1;

  List<RecompensaModel> _rewards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecompensas();
  }

  Future<void> _fetchRecompensas() async {
    try {
      final data = await sl<RecompensaRemoteDataSource>().getRecompensas();
      if (mounted) {
        setState(() {
          _rewards = data;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        _showMessage('Error al cargar recompensas: $e');
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == _selectedNavIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/opciones');
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/usuario');
        break;
    }
  }

  void _onRewardTap(int index) {
    setState(() {
      _selectedRewardIndex = index;
    });
  }

  void _onCanjearTap(int index) {
    final reward = _rewards[index];
    final userPoints = ref.read(authProvider).usuario?.puntosVerdes ?? 0;

    if (userPoints < reward.puntosRequeridos) {
      _showMessage('Puntos insuficientes para canjear esta recompensa');
      return;
    }

    _showConfirmationDialog(reward);
  }

  void _showConfirmationDialog(RecompensaModel reward) {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return CanjearConfirmacionDialog(
          onCancel: () {
            _showMessage('Canje cancelado.');
          },
        );
      },
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        _realizarCanje(reward);
      }
    });
  }

  Future<void> _realizarCanje(RecompensaModel reward) async {
    try {
      _showMessage('Procesando canje...');
      await sl<RecompensaRemoteDataSource>().canjearRecompensa(reward.id);

      // Actualizar puntos del usuario
      await ref.read(authProvider.notifier).refreshUser();

      if (mounted) {
        Navigator.pushNamed(context, '/canjear/exito');
      }
    } catch (e) {
      _showMessage('Error al canjear: $e');
    }
  }

  Widget _buildNavItem(String iconName, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
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
      ),
    );
  }

  Widget _buildRewardCard(int index) {
    final reward = _rewards[index];
    final isSelected = _selectedRewardIndex == index;

    String logoPath = 'falabella.png';
    final searchString = '${reward.nombre} ${reward.descripcion}'.toLowerCase();
    
    final Map<String, String> localMapping = {
      'falabella': 'falabella.png',
      'puntos': 'puntos_colombia.png',
      'colombia': 'puntos_colombia.png',
      'betty': 'bettys.png',
      'h&m': 'hym.png',
      'sodexo': 'sodexo.png',
      'civica': 'civica.png',
      'cívica': 'civica.png',
      'cine': 'cine.png',
      'jumbo': 'jumbo.png',
      'sabor': 'sabor_bosque.png',
      'bosque': 'sabor_bosque.png',
      'acampar': 'acampar.png',
      'nómada': 'acampar.png',
      'nómade': 'acampar.png',
      'raiz': 'acampar.png',
      'raíz': 'acampar.png',
      'camping': 'acampar.png',
      'senderismo': 'acampar.png',
      'alkatronic': 'alkatronic.png',
      'koaj': 'koaj.png',
      'verdeo': 'verdeo.png',
    };

    for (var key in localMapping.keys) {
      if (searchString.contains(key)) {
        logoPath = localMapping[key]!;
        break;
      }
    }

    return Material(
      color: Colors.transparent,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _onRewardTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border:
                  isSelected ? Border.all(color: simoMagenta, width: 2) : null,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 18,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reward.nombre,
                            style: const TextStyle(
                              color: simoMagenta,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Image.asset(
                            'assets/imagenes/canjear/$logoPath',
                            width: 110,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            reward.descripcion,
                            style: const TextStyle(
                              color: Color(0xFF7B7B7B),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                      onTap: () => _onCanjearTap(index),
                      child: Container(
                        width: 110,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          color: simoAmarillo,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
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
                                  '${reward.puntosRequeridos}',
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
                    ),
                  ),
                ],
              ),
            ),
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
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, '/home'),
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
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E6),
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/imagenes/canjear/flor.png',
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${ref.watch(authProvider).usuario?.puntosVerdes ?? 0}',
                          style: const TextStyle(
                            color: textoOscuro,
                            fontWeight: FontWeight.w800,
                            fontSize: 80,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '¡Tu aporte al planeta está registrado!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textoOscuro,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
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
            const SizedBox(height: 18),
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.white))
                  : SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Column(
                        children: List.generate(_rewards.length, (index) {
                          final card = _buildRewardCard(index);
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == _rewards.length - 1 ? 20 : 14,
                            ),
                            child: card,
                          );
                        }),
                      ),
                    ),
            ),
