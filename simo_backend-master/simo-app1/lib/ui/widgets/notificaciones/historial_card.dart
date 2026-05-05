import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/historial_entity.dart';
import '../../../domain/entities/notificacion_entity.dart';

class HistorialCard extends StatelessWidget {
  final HistorialEntity item;
  final VoidCallback? onTap;

  const HistorialCard({super.key, required this.item, this.onTap});

  // ─── Colores SIMÖ ─────────────────────────────────────────────────────────────
  static const _amarillo = Color(0xFFFECD20);
  static const _azul = Color(0xFF2D4EA2);
  static const _textoDark = Color(0xFF1E272E);

  Color get _leftColor {
    switch (item.estado) {
      case EstadoSolicitud.completo:
      case EstadoSolicitud.enProceso:
        return _amarillo;
      case EstadoSolicitud.cancelado:
        return Colors.grey.shade400;
    }
  }

  Color get _leftTextColor {
    return _textoDark;
  }

  String get _iconPath {
    switch (item.tipoDispositivo) {
      case TipoDispositivo.celular:
        return 'assets/icons/celular_icono.jpeg';
      case TipoDispositivo.tablet:
        return 'assets/icons/tablet_icono.png';
      case TipoDispositivo.laptop:
        return 'assets/imagenes/opciones/laptop.png';
      case TipoDispositivo.bateria:
        return 'assets/icons/image 4 (2).png';
      default:
        return 'assets/icons/celular_icono.png';
    }
  }

  String get _label {
    switch (item.tipoDispositivo) {
      case TipoDispositivo.celular:
        return 'Celular';
      case TipoDispositivo.tablet:
        return 'Tablet';
      case TipoDispositivo.laptop:
        return 'Laptop';
      case TipoDispositivo.bateria:
        return 'Bateria';
      default:
        return 'Otro';
    }
  }

  String get _estadoLabel {
    switch (item.estado) {
      case EstadoSolicitud.completo:
        return 'Completado';
      case EstadoSolicitud.enProceso:
        return 'en proceso';
      case EstadoSolicitud.cancelado:
        return 'Cancelado';
    }
  }

  Color get _estadoColor {
    switch (item.estado) {
      case EstadoSolicitud.completo:
        return _azul;
      default:
        return _textoDark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBateria = item.tipoDispositivo == TipoDispositivo.bateria;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCE7),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ─── LEFT BLOCK ─────────────────────────────
            Container(
              width: 85,
              decoration: BoxDecoration(
                color: _leftColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Text(
                      '${item.cantidad}x',
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: _textoDark),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        Image.asset(
                          _iconPath,
                          width: isBateria ? 44 : 48,
                          height: isBateria ? 45 : 48,
                          errorBuilder: (ctx, err, stack) => const Icon(Icons.devices, size: 38),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _label,
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: _leftTextColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ─── RIGHT BLOCK ──────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Reciclaje',
                          style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: _textoDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Destino:${item.destino}',
                          style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w600, color: _textoDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Electrodomestico: ${item.electrodomestico}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: _textoDark.withValues(alpha: 0.85)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Fecha:${item.fecha}',
                          style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: _textoDark.withValues(alpha: 0.85)),
                        ),
                      ],
                    ),
                    // Points Badge Top Right
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/icons/flor.png', width: 20, height: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${item.puntos}',
                            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: _textoDark),
                          ),
                        ],
                      ),
                    ),
                    // Status Label Bottom Right
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Estado: ',
                              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: _textoDark),
                            ),
                            TextSpan(
                              text: _estadoLabel,
                              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: _estadoColor),
                            ),
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
      ),
    );
  }
}
