import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'opciones_screen.dart';
import '../home/home_screen.dart';

import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/resumen_solicitud_top.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../widgets/widgetsopciones/simo_button.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../providers/auth_notifier.dart';

class ConfirmacionFinalScreen extends ConsumerStatefulWidget {
  final String dispositivoLabel;
  final dynamic dispositivoIcon;
  final String destinoAliado;
  final String destinoDireccion;
  final String metodoEntrega;
  final int puntos;

  const ConfirmacionFinalScreen({
    super.key,
    required this.dispositivoLabel,
    required this.dispositivoIcon,
    required this.destinoAliado,
    required this.destinoDireccion,
    required this.metodoEntrega,
    required this.puntos,
  });

  @override
  ConsumerState<ConfirmacionFinalScreen> createState() => _ConfirmacionFinalScreenState();
}

class _ConfirmacionFinalScreenState extends ConsumerState<ConfirmacionFinalScreen> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.simoAzul,
      appBar: SimoHeader(
        showBackButton: true,
        showLogo: false,
        puntos: ref.watch(authProvider).usuario?.puntosVerdes ?? 0,
        onBackPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const OpcionesScreen()),
            (route) => false,
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ResumenSolicitudTop(
                dispositivoLabel: widget.dispositivoLabel,
                dispositivoIcon: widget.dispositivoIcon,
                destinoAliado: widget.destinoAliado,
                destinoDireccion: widget.destinoDireccion,
                metodoEntrega: widget.metodoEntrega,
                puntos: widget.puntos,
                actionText: 'Confirmado',
                actionColor: const Color(0xFF38C878),
                actionTextColor: Colors.white,
                actionIcon: Icons.check,
                compactAddress: true,
                onActionPressed: null,
              ),
              const SizedBox(height: 12),
              const Text(
                'Confirmación',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.simoCrudo,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Icon(
                            _isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right, 
                            color: AppColors.simoAzul, 
                            size: 24
                          ),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '4 / marzo / 2026 - NIT:0129219',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Detalles de la solicitud',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (_isExpanded) ...[
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '¡Solicitud aceptada!',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF303030),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.simoAzul,
                                fontWeight: FontWeight.w900,
                              ),
                              children: [
                                TextSpan(text: 'CODE: '),
                                TextSpan(
                                  text: '2345',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _infoRow('Dispositivo:', widget.dispositivoLabel),
                      const SizedBox(height: 2),
                      _infoRow('Fecha límite de entrega:', '10 / Marzo / 2026'),
                      const SizedBox(height: 2),
                      _infoRow('Puntos verdes ganados:', '${widget.puntos} puntos'),
                      const SizedBox(height: 10),
                      const Text(
                        'NOTA: Los puntos se otorgarán cuando el\ndispositivo sea recibido en el punto de reciclaje\ny la empresa registre el Codigo.',
                        style: TextStyle(
                          fontSize: 8.5,
                          color: Color(0xFF6E6E6E),
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SimoButton(
                          text: 'Regresar',
                          backgroundColor: const Color(0xFF4CD88B),
                          height: 30,
                          horizontalPadding: 14,
                          fontSize: 10,
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const OpcionesScreen()),
                              (route) => false,
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SimoBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  static Widget _infoRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF3F3F3F),
          fontWeight: FontWeight.w800,
          height: 1.2,
        ),
        children: [
          TextSpan(text: '$label '),
          TextSpan(
            text: value,
            style: const TextStyle(
              color: AppColors.simoAzul,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
