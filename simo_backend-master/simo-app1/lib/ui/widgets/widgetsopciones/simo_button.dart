import 'package:flutter/material.dart';

class SimoButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double fontSize;
  final double horizontalPadding;
  final IconData? icon;
  final bool iconOnRight;

  const SimoButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 42,
    this.fontSize = 14,
    this.horizontalPadding = 16,
    this.icon,
    this.iconOnRight = false,
  });

  @override
  State<SimoButton> createState() => _SimoButtonState();
}

class _SimoButtonState extends State<SimoButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onPressed,
      child: ScaleTransition(
        scale: _scale,
        child: SizedBox(
          width: widget.width,
          height: widget.height,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                      widget.backgroundColor ?? const Color(0xFFD8006B),
                  foregroundColor: widget.textColor ?? Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.horizontalPadding,
                  ),
                  elevation: 0,
                ).copyWith(
                  overlayColor: WidgetStateProperty.all(
                    Colors.white.withOpacity(0.1),
                  ),
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null && !widget.iconOnRight) ...[
                  Icon(widget.icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    widget.text,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: widget.fontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (widget.icon != null && widget.iconOnRight) ...[
                  const SizedBox(width: 8),
                  Icon(widget.icon, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
