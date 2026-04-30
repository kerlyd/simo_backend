import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/resumen_solicitud_top.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../widgets/widgetsopciones/simo_button.dart';
import '../../providers/auth_notifier.dart';
import '../../../injection_container.dart';
import 'confirmacion_final_screen.dart';

class ConfirmarSolicitudScreen extends ConsumerStatefulWidget {
  final String dispositivoLabel;
  final dynamic dispositivoIcon;
  final String destinoAliado;
  final String destinoDireccion;
  final String metodoEntrega;
  final int puntos;
  final dynamic dispositivoId;

  const ConfirmarSolicitudScreen({
    super.key,
    required this.dispositivoLabel,
    required this.dispositivoIcon,
    required this.destinoAliado,
    required this.destinoDireccion,
    required this.metodoEntrega,
    required this.puntos,
    required this.dispositivoId,
  });

  @override
  ConsumerState<ConfirmarSolicitudScreen> createState() =>
      _ConfirmarSolicitudScreenState();
}

class _ConfirmarSolicitudScreenState
    extends ConsumerState<ConfirmarSolicitudScreen> {
  bool _isSubmitting = false;

  Future<void> _confirmarReciclaje() async {
    setState(() => _isSubmitting = true);
    try {
      final dio = sl<Dio>();
      // Mapeo simple de aliados a IDs (en producción esto vendría de la API)
      final puntoId = widget.destinoAliado.contains('EcoTech')
          ? '9354c9aa-761c-430c-b1cc-faba30807afa'
          : '0ab74597-a2fb-4a69-bc51-62961d6b50d3';

      final response = await dio.post('/api/solicitudes', data: {
        'dispositivo_tipo_id': widget.dispositivoId,
        'punto_reciclaje_id': puntoId,
        'metodo_entrega': widget.metodoEntrega,
      });

      if (response.statusCode == 201) {
        // Refrescamos el usuario para ver los nuevos puntos
        await ref.read(authProvider.notifier).refreshUser();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmacionFinalScreen(
                dispositivoLabel: widget.dispositivoLabel,
                dispositivoIcon: widget.dispositivoIcon,
                destinoAliado: widget.destinoAliado,
                destinoDireccion: widget.destinoDireccion,
                metodoEntrega: widget.metodoEntrega,
                puntos: widget.puntos,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al procesar solicitud: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.simoAzul,
      appBar: SimoHeader(
        showBackButton: true,
        showLogo: false,
        puntos: ref.watch(authProvider).usuario?.puntosVerdes ?? 0,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                  actionText: '¿Confirmar?',
                  actionColor: const Color(0xFFD7D2CB),
                  compactAddress: true,
                  onActionPressed: null,
                ),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.simoCrudo,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        '¿Deseas confirmar esta\nsolicitud?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: Color(0xFF3F3F3F),
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: SimoButton(
                              text:
                                  _isSubmitting ? 'Procesando...' : 'Confirmar',
                              backgroundColor: const Color(0xFF32C68A),
                              height: 44,
                              fontSize: 13,
                              icon: _isSubmitting ? null : Icons.check,
                              onPressed: _isSubmitting
                                  ? null
                                  : () {
                                      _confirmarReciclaje();
                                    },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SimoButton(
                              text: 'Cancelar',
                              backgroundColor: const Color(0xFFED4A64),
                              height: 44,
                              fontSize: 13,
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        '¡Al confirmarse la entrega de tu dispositivo, el estado\ncambiará a "Completo"!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w700,
                          height: 1.25,
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
      bottomNavigationBar: SimoBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }
}
