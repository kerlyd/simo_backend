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
      if (desc.contains('bosque') || desc.contains('cafe')) return 'assets/imagenes/canjear/sabor_bosque.png';
      if (desc.contains('verdeo')) return 'assets/imagenes/canjear/verdeo.png';
      if (desc.contains('alkatronic')) return 'assets/imagenes/canjear/alkatronic.png';
      if (desc.contains('betty') || desc.contains('selfy')) return 'assets/imagenes/canjear/bettys.png';
      if (desc.contains('cine')) return 'assets/imagenes/canjear/cine.png';
      if (desc.contains('civica') || desc.contains('cívica')) return 'assets/imagenes/canjear/civica.png';
      if (desc.contains('falabella')) return 'assets/imagenes/canjear/falabella.png';
      if (desc.contains('h&m') || desc.contains('hym')) return 'assets/imagenes/canjear/hym.png';
      if (desc.contains('jumbo')) return 'assets/imagenes/canjear/jumbo.png';
      if (desc.contains('koaj')) return 'assets/imagenes/canjear/koaj.png';
      if (desc.contains('puntos colombia')) return 'assets/imagenes/canjear/puntos_colombia.png';
      if (desc.contains('acampar')) return 'assets/imagenes/canjear/acampar.png';

      return 'assets/icons/flor.png'; // Fallback genérico
    }

    if (titulo.contains('reciclaje')) {
      if (desc.contains('celular') || desc.contains('movil')) return 'assets/icons/celular_icono.jpeg';
      if (desc.contains('tablet')) return 'assets/icons/tablet_icono.png';
      if (desc.contains('laptop') || desc.contains('portatil') || desc.contains('computador')) return 'assets/imagenes/opciones/laptop.png';
      if (desc.contains('bateria') || desc.contains('pilas')) return 'assets/icons/image 4 (2).png';
      if (desc.contains('consola')) return 'assets/imagenes/opciones/consolasdejuegos.png';
      if (desc.contains('licuadora')) return 'assets/imagenes/opciones/licuadora.png';
      if (desc.contains('cargador') || desc.contains('cable')) return 'assets/imagenes/opciones/cargadores.png';
      if (desc.contains('microondas')) return 'assets/imagenes/opciones/microondas.png';
      if (desc.contains('mouse') || desc.contains('teclado')) return 'assets/imagenes/opciones/mouse.png';
      if (desc.contains('pantalla') || desc.contains('tv') || desc.contains('televisor')) return 'assets/imagenes/opciones/tv.png';
      if (desc.contains('plancha')) return 'assets/imagenes/opciones/plancha.png';
      if (desc.contains('refrigerador') || desc.contains('nevera')) return 'assets/imagenes/opciones/refrigerador.png';
      if (desc.contains('ventilador')) return 'assets/imagenes/opciones/ventilador.png';
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
      if (desc.contains('consola')) return 'Consola';
      if (desc.contains('licuadora')) return 'Licuadora';
      if (desc.contains('cargador') || desc.contains('cable')) return 'Cables';
      if (desc.contains('microondas')) return 'Microondas';
      if (desc.contains('mouse') || desc.contains('teclado')) return 'Periférico';
      if (desc.contains('pantalla') || desc.contains('tv') || desc.contains('televisor')) return 'Pantalla/TV';
      if (desc.contains('plancha')) return 'Plancha';
      if (desc.contains('refrigerador') || desc.contains('nevera')) return 'Refrigerador';
      if (desc.contains('ventilador')) return 'Ventilador';
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
                      notificacion.descripcion.replaceAll('por reciclar tu ', 'por reciclar: ').replaceAll('Selfy´s Bowls', "Betty's Bowls").replaceAll("Selfy's Bowls", "Betty's Bowls"),
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
