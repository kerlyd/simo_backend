import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SimoBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SimoBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.simoCrudo,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              0,
              'Inicio',
              'assets/imagenes/canjear/Inicio_icono.png',
            ),
            _buildNavItem(
              1,
              'Opciones',
              'assets/imagenes/canjear/opciones_icono.png',
            ),
            _buildNavItem(
              2,
              'Canjear',
              'assets/imagenes/canjear/Canjear_icono.png',
            ),
            _buildNavItem(
              3,
              'Usuario',
              'assets/imagenes/canjear/usuario_icono.png',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String imagePath) {
    final isSelected = currentIndex == index;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              imagePath,
              color: isSelected ? const Color(0xFF424242) : Colors.grey[600],
              height: 32,
              width: 32,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF424242) : Colors.grey[600],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 40,
                height: 3,
                color: AppColors.simoAzul,
              )
            else
              const SizedBox(height: 7),
          ],
        ),
      ),
    );
  }
}
