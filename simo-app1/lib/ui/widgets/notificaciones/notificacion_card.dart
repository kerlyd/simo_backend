import 'package:flutter/material.dart';
import '../../../domain/entities/notificacion_entity.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificacionCard extends StatelessWidget {
  final NotificacionEntity notificacion;

  const NotificacionCard({super.key, required this.notificacion});

  // ─── Colores SIMÖ ─────────────────────────────────────────────────────────────
  static const _amarillo = Color(0xFFFECD20);
  static const _rojo = Color(0xFFE63956);
  static const _textoDark = Color(0xFF1E272E);

  Color get _leftColor {
    return notificacion.estado == EstadoNotificacion.cancelada ? _rojo : _amarillo;
  }

  Color get _leftTextColor {
    return notificacion.estado == EstadoNotificacion.cancelada ? Colors.white : _textoDark;
  }

  String get _iconPath {
    final titulo = notificacion.titulo.toLowerCase();
    final desc = notificacion.descripcion.toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    if (titulo.contains('canje')) {
      return 'assets/icons/flor.png'; // Icono para canje
    }

    if (titulo.contains('reciclaje')) {
      if (desc.contains('celular') || desc.contains('movil')) return 'assets/icons/celular_icono.jpeg';
      if (desc.contains('tablet')) return 'assets/icons/tablet_icono.png';
      if (desc.contains('laptop') || desc.contains('portatil') || desc.contains('computador')) return 'assets/imagenes/opciones/laptop.png';
      if (desc.contains('bateria') || desc.contains('pilas')) return 'assets/icons/image 4 (2).png';
    }

    switch (notificacion.tipoDispositivo) {
      case TipoDispositivo.celular:
        return 'assets/icons/celular_icono.jpeg';
      case TipoDispositivo.tablet:
        return 'assets/icons/tablet_icono.png';
      case TipoDispositivo.laptop:
        return 'assets/imagenes/opciones/laptop.png';
      case TipoDispositivo.bateria:
        return 'assets/icons/image 4 (2).png';
      default:
        return 'assets/icons/celular_icono.jpeg';
    }
  }

  String get _label {
    final titulo = notificacion.titulo.toLowerCase();
    final desc = notificacion.descripcion.toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u');

    if (titulo.contains('canje')) {
      return 'Recompensa';
    }

    if (titulo.contains('reciclaje')) {
      if (desc.contains('celular') || desc.contains('movil')) return 'Celular';
      if (desc.contains('tablet')) return 'Tablet';
      if (desc.contains('laptop') || desc.contains('portatil') || desc.contains('computador')) return 'Laptop';
      if (desc.contains('bateria') || desc.contains('pilas')) return 'Batería';
    }

    switch (notificacion.tipoDispositivo) {
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

  @override
  Widget build(BuildContext context) {
    final bool isBateria = notificacion.tipoDispositivo == TipoDispositivo.bateria;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      height: 98,
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
                    '${notificacion.cantidad}x',
                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: _leftTextColor),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      Image.asset(
                        _iconPath,
                        width: isBateria ? 28 : 48,
                        height: isBateria ? 38 : 48,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificacion.titulo,
                    style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: _textoDark),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      notificacion.descripcion,
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: _textoDark.withValues(alpha: 0.85), height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'Fecha:${notificacion.fecha}',
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.bold, color: _textoDark.withValues(alpha: 0.8)),
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
}
