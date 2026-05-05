import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class SimoHeader extends StatelessWidget implements PreferredSizeWidget {
  final int puntos;
  final bool showBackButton;
  final bool showLogo;
  final VoidCallback? onBackPressed;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onLogoTap;

  const SimoHeader({
    super.key,
    this.puntos = 0,
    this.showBackButton = false,
    this.showLogo = true,
    this.onBackPressed,
    this.onNotificationTap,
    this.onLogoTap,
  });

  @override
  Widget build(BuildContext context) {
    // Conditional sizing: confirmation screens (!showLogo) have slightly smaller elements
    final double florSize = showLogo ? 34 : 28;
    final double ptsFontSize = showLogo ? 22 : 18;
    final double notifySize = showLogo ? 42 : 36;
    final double backBtnSize = showLogo ? 38 : 32;

    return AppBar(
      backgroundColor: AppColors.simoCrudo,
      elevation: 3,
      shadowColor: Colors.black12,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      flexibleSpace: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showBackButton)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onBackPressed ?? () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.only(right: 18),
                          color: Colors.transparent,
                          child: Image.asset(
                            'assets/imagenes/canjear/atras.png',
                            height: backBtnSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  if (showLogo)
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onLogoTap,
                        child: Image.asset(
                          'assets/imagenes/canjear/simo.png',
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/canjear/flor.png',
                    height: florSize,
                    width: florSize,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$puntos',
                    style: TextStyle(
                      color: AppColors.simoAzul,
                      fontWeight: FontWeight.w900,
                      fontSize: ptsFontSize,
                    ),
                  ),
                  const SizedBox(width: 14),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: onNotificationTap,
                      child: Image.asset(
                        'assets/imagenes/canjear/notificacion.png',
                        height: notifySize,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
