import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../theme/app_colors.dart';
import '../../widgets/widgetsopciones/resumen_solicitud_top.dart';
import '../../widgets/widgetsopciones/simo_bottom_nav.dart';
import '../../widgets/widgetsopciones/simo_button.dart';
import '../../widgets/widgetsopciones/simo_header.dart';
import '../../providers/auth_notifier.dart';
import 'confirmar_solicitud_screen.dart';
import 'opciones_screen.dart';

class DetalleSolicitudScreen extends ConsumerStatefulWidget {
  final String dispositivoLabel;
  final dynamic dispositivoIcon;
  final String destinoAliado;
  final String destinoDireccion;
  final String metodoEntrega;
  final int puntos;
  final dynamic dispositivoId;
  final dynamic puntoId;

  const DetalleSolicitudScreen({
    super.key,
    required this.dispositivoLabel,
    required this.dispositivoId,
    required this.dispositivoIcon,
    required this.destinoAliado,
    required this.destinoDireccion,
    required this.metodoEntrega,
    required this.puntos,
    required this.puntoId,
  });

  @override
  ConsumerState<DetalleSolicitudScreen> createState() => _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState extends ConsumerState<DetalleSolicitudScreen> {
  bool _imageUploaded = false;
  final ImagePicker _picker = ImagePicker();

  void _showImageError() {
    showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 3200), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
        return AlertDialog(
          backgroundColor: AppColors.simoCrudo,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Imagen necesaria',
            style: TextStyle(
              color: AppColors.simoMagenta,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: const Text(
            'Por favor, adjunta una imagen de tu dispositivo para continuar con la solicitud.',
            style: TextStyle(
              color: Color(0xFF424242),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: const [],
        );
      },
    );
  }

  Future<void> _showCancelDialog() async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.simoCrudo,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        title: const Text(
          '¿Deseas cancelar la solicitud?',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.simoMagenta,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        content: const Text(
          'Si sales ahora, se perderán los datos actuales de tu solicitud.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF424242),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SimoButton(
                  text: 'No, continuar',
                  backgroundColor: const Color(0xFFD7D2CB),
                  textColor: const Color(0xFF4A4A4A),
                  height: 38,
                  fontSize: 11,
                  onPressed: () => Navigator.pop(context, false),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SimoButton(
                  text: 'Sí, cancelar',
                  backgroundColor: AppColors.simoMagenta,
                  height: 38,
                  fontSize: 11,
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _imageUploaded = true;
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        _showCancelDialog();
      },
      child: Scaffold(
        backgroundColor: AppColors.simoAzul,
        appBar: SimoHeader(
          showBackButton: true,
          showLogo: false,
          puntos: ref.watch(authProvider).usuario?.puntosVerdes ?? 0,
          onBackPressed: _showCancelDialog,
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
                    onActionPressed: null,
                  ),
                  const SizedBox(height: 14),
                  _buildCard(context),
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
              _showCancelDialog();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Esperando Confirmacion...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF3F3F3F),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Adjunta una imagen de tu objeto ya que esto nos ayudará a revisarlo y determinar qué proceso de reciclaje o reutilización puede realizarse según su condición.',
            style: TextStyle(
              fontSize: 10,
              height: 1.4,
              color: Color(0xFF6B6B6B),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              SimoButton(
                text: _imageUploaded ? 'Imagen Subida' : 'Subir Imagen',
                backgroundColor: const Color(0xFFD7D2CB),
                textColor: const Color(0xFF3F3F3F),
                height: 36,
                icon: Icons.image_outlined,
                iconOnRight: true,
                horizontalPadding: 14,
                fontSize: 10,
                onPressed: _pickImage,
              ),
              const Spacer(),
              SimoButton(
                text: 'Siguiente',
                backgroundColor: const Color(0xFF4CD88B),
                height: 38,
                horizontalPadding: 32,
                fontSize: 11,
                onPressed: () {
                  if (!_imageUploaded) {
                    _showImageError();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ConfirmarSolicitudScreen(
                          dispositivoLabel: widget.dispositivoLabel,
                          dispositivoIcon: widget.dispositivoIcon,
                          destinoAliado: widget.destinoAliado,
                          destinoDireccion: widget.destinoDireccion,
                          metodoEntrega: widget.metodoEntrega,
                          puntos: widget.puntos,
                          dispositivoId: widget.dispositivoId,
                          puntoId: widget.puntoId,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
