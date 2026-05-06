import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../domain/entities/detalle_solicitud_entity.dart';
import '../../../domain/entities/notificacion_entity.dart';
import '../../providers/detalle_solicitud_notifier.dart';

// ─── Colores SIMÖ ─────────────────────────────────────────────────────────────
const _magenta = Color(0xFFD8006B);
const _amarillo = Color(0xFFFECD20);
const _azul = Color(0xFF2D4EA2);
const _crudo = Color(0xFFFFFCE7);
const _rojo = Color(0xFFE63956);
const _textoDark = Color(0xFF1E272E);

// ─── Screen ───────────────────────────────────────────────────────────────────

class DetalleSolicitudScreen extends StatefulWidget {
  final String solicitudId;
  const DetalleSolicitudScreen({super.key, required this.solicitudId});

  @override
  State<DetalleSolicitudScreen> createState() => _DetalleSolicitudScreenState();
}

class _DetalleSolicitudScreenState extends State<DetalleSolicitudScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetalleSolicitudNotifier>().cargar(widget.solicitudId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DetalleSolicitudNotifier>(
      builder: (context, notifier, _) {
        final state = notifier.state;
        return Scaffold(
          backgroundColor: _azul, // 100% blue background matching design
          body: Column(
            children: [
              _TopBar(puntosUsuario: 1780), // En un app real vendría del auth_notifier
              Expanded(
                child: state.isLoading
                    ? const _LoadingView()
                    : state.errorMessage != null
                        ? _ErrorView(message: state.errorMessage!)
                        : state.detalle == null
                            ? const _LoadingView()
                            : _Body(
                                detalle: state.detalle!,
                                notifier: notifier,
                                state: state,
                              ),
              ),
              const _BottomNav(),
            ],
          ),
        );
      },
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final DetalleSolicitudEntity detalle;
  final DetalleSolicitudNotifier notifier;
  final DetalleSolicitudState state;

  const _Body({required this.detalle, required this.notifier, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SeccionPrincipal(detalle: detalle, notifier: notifier, state: state),
          const SizedBox(height: 24),
          // Título "Confirmación"
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Confirmación',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          _SeccionConfirmacion(
            detalle: detalle,
            expanded: state.confirmacionExpanded,
            onToggle: notifier.toggleConfirmacion,
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int puntosUsuario;
  const _TopBar({required this.puntosUsuario});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(16, topPad + 16, 16, 24),
      decoration: const BoxDecoration(
        color: _crudo,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: const Icon(Icons.arrow_back_ios_new, size: 36, color: _textoDark),
          ),
          const Spacer(),
          // Badge puntos total usuario
          Transform.translate(
            offset: const Offset(0, -4),
            child: Row(
              children: [
                Image.asset('assets/icons/flor.png', width: 24, height: 24),
                const SizedBox(width: 6),
                Text(
                  '$puntosUsuario',
                  style: GoogleFonts.outfit(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: _azul,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Campana notificaciones
          GestureDetector(
            onTap: () => Navigator.pop(context), // Detalle se abre desde Notificaciones, por lo que pop() devuelve al usuario allí.
            child: Image.asset('assets/icons/notificacion.png', width: 42, height: 42),
          ),
        ],
      ),
    );
  }
}

// ─── Sección Principal (Dispositivo + Info + Botón) ───────────────────────────

class _SeccionPrincipal extends StatelessWidget {
  final DetalleSolicitudEntity detalle;
  final DetalleSolicitudNotifier notifier;
  final DetalleSolicitudState state;

  const _SeccionPrincipal({
    required this.detalle,
    required this.notifier,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta amarilla del dispositivo
            _IconoDispositivo(tipo: detalle.tipoDispositivo, cantidad: detalle.cantidad, electrodomestico: detalle.electrodomestico),
            const SizedBox(width: 20),
            // Información del destino
            Expanded(child: _InfoDestino(detalle: detalle)),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            // Badge con los puntos (forzamos que ocupe el mismo ancho que _IconoDispositivo para alinear perfectamente la columna izquierda)
            SizedBox(
              width: 152,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _BadgePuntosSolicitud(puntos: detalle.puntos),
              ),
            ),
            const SizedBox(width: 20),
            // Botón "Completo" (alineado debajo de la info de destino)
            _BotonCompleto(
              isSubmitting: state.isSubmitting,
              onTap: notifier.marcarCompleto,
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Ícono dispositivo (Tarjeta amarilla) ─────────────────────────────────────

class _IconoDispositivo extends StatelessWidget {
  final TipoDispositivo tipo;
  final int cantidad;
  final String electrodomestico;

  const _IconoDispositivo({required this.tipo, required this.cantidad, required this.electrodomestico});

  @override
  Widget build(BuildContext context) {
    final bool isBateria = tipo == TipoDispositivo.bateria;
    return Container(
      width: 152,
      height: 146,
      decoration: BoxDecoration(
        color: const Color(0xFFFECD20),
        borderRadius: BorderRadius.circular(24.74),
      ),
      child: Stack(
        children: [
          // Texto cantidad "21x" arriba a la derecha
          Positioned(
            top: 12,
            right: 14,
            child: Text(
              '${cantidad}x',
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: _textoDark),
            ),
          ),
          // Icono centrado con texto abajo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16), // Offset against top right text
                Image.asset(
                  _iconPath,
                  width: isBateria ? 63 : 80,
                  height: isBateria ? 64 : 80,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.devices, size: 60),
                ),
                const SizedBox(height: 4),
                Text(
                  _label,
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: _textoDark),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _iconPath {
    final elec = electrodomestico.toLowerCase();
    if (elec.contains('consola')) return 'assets/imagenes/opciones/consolasdejuegos.png';
    if (elec.contains('licuadora')) return 'assets/imagenes/opciones/licuadora.png';
    if (elec.contains('cargador') || elec.contains('cable')) return 'assets/imagenes/opciones/cargadores.png';
    if (elec.contains('microondas')) return 'assets/imagenes/opciones/microondas.png';
    if (elec.contains('mouse') || elec.contains('teclado')) return 'assets/imagenes/opciones/mouse.png';
    if (elec.contains('pantalla') || elec.contains('tv') || elec.contains('televisor')) return 'assets/imagenes/opciones/tv.png';
    if (elec.contains('plancha')) return 'assets/imagenes/opciones/plancha.png';
    if (elec.contains('refrigerador') || elec.contains('nevera')) return 'assets/imagenes/opciones/refrigerador.png';
    if (elec.contains('ventilador')) return 'assets/imagenes/opciones/ventilador.png';

    switch (tipo) {
      case TipoDispositivo.bateria:
        return 'assets/icons/image 4 (2).png';
      case TipoDispositivo.celular:
        return 'assets/icons/celular_icono.jpeg';
      case TipoDispositivo.tablet:
        return 'assets/icons/tablet_icono.png';
      case TipoDispositivo.laptop:
        return 'assets/imagenes/opciones/laptop.png';
      default:
        return 'assets/icons/celular_icono.png';
    }
  }

  String get _label {
    final elec = electrodomestico.toLowerCase();
    if (elec.contains('consola')) return 'Consola';
    if (elec.contains('licuadora')) return 'Licuadora';
    if (elec.contains('cargador') || elec.contains('cable')) return 'Cables';
    if (elec.contains('microondas')) return 'Microondas';
    if (elec.contains('mouse') || elec.contains('teclado')) return 'Periférico';
    if (elec.contains('pantalla') || elec.contains('tv') || elec.contains('televisor')) return 'Pantalla/TV';
    if (elec.contains('plancha')) return 'Plancha';
    if (elec.contains('refrigerador') || elec.contains('nevera')) return 'Refrigerador';
    if (elec.contains('ventilador')) return 'Ventilador';

    switch (tipo) {
      case TipoDispositivo.bateria:
        return 'Bateria';
      case TipoDispositivo.celular:
        return 'Celular';
      case TipoDispositivo.tablet:
        return 'Tablet';
      case TipoDispositivo.laptop:
        return 'Laptop';
      default:
        return 'Dispositivo';
    }
  }
}

// ─── Info destino ─────────────────────────────────────────────────────────────

class _InfoDestino extends StatelessWidget {
  final DetalleSolicitudEntity detalle;
  const _InfoDestino({required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Destino: ',
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              TextSpan(
                text: detalle.destino,
                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          detalle.direccionDestino,
          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9)),
        ),
        const SizedBox(height: 8),
        Text(
          'Cantidad: x${detalle.cantidad}',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9)),
        ),
        const SizedBox(height: 12),
        Text(
          'Forma de entrega:',
          style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white.withValues(alpha: 0.9)),
        ),
        const SizedBox(height: 2),
        Text(
          detalle.metodoEntrega == MetodoEntrega.loLlevasTu ? 'Lo llevas tú' : 'Lo recogemos',
          style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

// ─── Badge puntos solicitud ───────────────────────────────────────────────────

class _BadgePuntosSolicitud extends StatelessWidget {
  final int puntos;
  const _BadgePuntosSolicitud({required this.puntos});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFCE7),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icons/flor.png', width: 28, height: 28),
          const SizedBox(width: 8),
          Text(
            '$puntos',
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: _azul,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botón Completo ───────────────────────────────────────────────────────────

class _BotonCompleto extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onTap;

  const _BotonCompleto({required this.isSubmitting, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSubmitting ? null : onTap,
      child: Container(
        width: 160,
        height: 69,
        decoration: BoxDecoration(
          color: _amarillo,
          borderRadius: BorderRadius.circular(6.67),
        ),
        alignment: Alignment.center,
        child: isSubmitting
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: _textoDark, strokeWidth: 3),
              )
            : Text(
                'Completo',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: _textoDark),
              ),
      ),
    );
  }
}

// ─── Sección Confirmación ─────────────────────────────────────────────────────

class _SeccionConfirmacion extends StatelessWidget {
  final DetalleSolicitudEntity detalle;
  final bool expanded;
  final VoidCallback onToggle;

  const _SeccionConfirmacion({
    required this.detalle,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _crudo,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onToggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: _textoDark,
                    size: 28,
                  ),
                  const Spacer(),
                  Text(
                    '${detalle.fecha} - NIT:${detalle.nit}',
                    style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: _textoDark),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _ConfirmacionDetalle(detalle: detalle),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }
}

class _ConfirmacionDetalle extends StatelessWidget {
  final DetalleSolicitudEntity detalle;
  const _ConfirmacionDetalle({required this.detalle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Detalles de la solicitud',
              style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w600, color: _textoDark),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¡Solicitud aceptada!',
                style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: _textoDark),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'CODE: ${detalle.codigo}',
                  style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold, color: _azul),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Filas de detalle
          _FilaDetalle(label: 'Dispositivo:', value: _labelTipo(detalle.tipoDispositivo), valueColor: _azul),
          const SizedBox(height: 8),
          _FilaDetalle(
            label: 'Fecha limite de entrega:',
            value: detalle.fechaLimiteEntrega,
            valueColor: _azul,
          ),
          const SizedBox(height: 8),
          _FilaDetalle(
            label: 'Puntos verdes ganados:',
            value: '${detalle.puntosGanados} puntos',
            valueColor: _azul,
          ),
          const SizedBox(height: 24),
          // NOTA
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'NOTA: ',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: _textoDark),
                ),
                TextSpan(
                  text: detalle.nota,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w500, color: _textoDark.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _labelTipo(TipoDispositivo t) {
    switch (t) {
      case TipoDispositivo.bateria:
        return 'Bateria';
      case TipoDispositivo.celular:
        return 'Celular';
      case TipoDispositivo.tablet:
        return 'Tablet';
      case TipoDispositivo.laptop:
        return 'Laptop';
      default:
        return 'Dispositivo';
    }
  }
}

class _FilaDetalle extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _FilaDetalle({required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: _textoDark)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor),
          ),
        ),
      ],
    );
  }
}

// ─── Bottom Nav ───────────────────────────────────────────────────────────────

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final botPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 20, 16, botPad + 12),
      decoration: const BoxDecoration(
        color: _crudo,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: 'assets/icons/Inicio_icono.png', 
            label: 'Inicio', 
            active: false,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
          ),
          _NavItem(
            icon: 'assets/icons/opciones_icono.png', 
            label: 'Opciones', 
            active: false,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/opciones', (route) => false),
          ),
          _NavItem(
            icon: 'assets/icons/Canjear_icono.png', 
            label: 'Canjear', 
            active: false,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/canjear', (route) => false),
          ),
          _NavItem(
            icon: 'assets/icons/usuario_icono.png', 
            label: 'Usuario', 
            active: false,
            onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/usuario', (route) => false),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _NavItem({required this.icon, required this.label, required this.active, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon, width: 36, height: 36),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            color: _textoDark,
          ),
        ),
        if (active)
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 30,
            height: 2,
            color: _azul,
          ),
      ],
    ),
    );
  }
}

// ─── Views auxiliares ─────────────────────────────────────────────────────────

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: _amarillo));
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: _rojo, size: 48),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _magenta),
              onPressed: () => Navigator.of(context).maybePop(),
              child: Text(
                'Volver',
                style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}