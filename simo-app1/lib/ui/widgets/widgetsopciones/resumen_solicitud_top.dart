import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ResumenSolicitudTop extends StatelessWidget {
  final String dispositivoLabel;
  final String dispositivoIcon;
  final String destinoAliado;
  final String destinoDireccion;
  final String metodoEntrega;
  final int puntos;
  final String actionText;
  final Color actionColor;
  final Color actionTextColor;
  final IconData? actionIcon;
  final VoidCallback? onActionPressed;
  final bool compactAddress;

  const ResumenSolicitudTop({
    super.key,
    required this.dispositivoLabel,
    required this.dispositivoIcon,
    required this.destinoAliado,
    required this.destinoDireccion,
    required this.metodoEntrega,
    required this.puntos,
    required this.actionText,
    required this.actionColor,
    this.actionTextColor = const Color(0xFF4A4A4A),
    this.actionIcon,
    this.onActionPressed,
    this.compactAddress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DeviceCard(
              dispositivoLabel: dispositivoLabel,
              dispositivoIcon: dispositivoIcon,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destino: $destinoAliado',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      destinoDireccion,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFFF4F0E9),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Cantidad: x1',
                      style: TextStyle(
                        color: Color(0xFFF4F0E9),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Forma de entrega:',
                      style: TextStyle(
                        color: Color(0xFFF4F0E9),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      metodoEntrega,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            SizedBox(
              width: 100,
              child: _PointsPill(puntos: puntos),
            ),
            const SizedBox(width: 14),
            _ActionButton(
              text: actionText,
              color: actionColor,
              textColor: actionTextColor,
              icon: actionIcon,
              onPressed: onActionPressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final String dispositivoLabel;
  final String dispositivoIcon;

  const _DeviceCard({
    required this.dispositivoLabel,
    required this.dispositivoIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 110,
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 10,
            right: 12,
            child: Text(
              '1x',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      dispositivoIcon,
                      height: 44,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.devices,
                          size: 40,
                          color: Color(0xFF3E3E3E),
                        );
                      },
                    ),
                  ),
                ),
                Text(
                  dispositivoLabel,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF3E3E3E),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PointsPill extends StatelessWidget {
  final int puntos;

  const _PointsPill({required this.puntos});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/imagenes/canjear/flor.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '$puntos',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
              color: AppColors.simoAzul,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final IconData? icon;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.text,
    required this.color,
    required this.textColor,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          disabledBackgroundColor: color,
          foregroundColor: textColor,
          disabledForegroundColor: textColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 18, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
