import 'package:flutter/material.dart';

class SimoHeader extends StatelessWidget {
  final int puntosVerdes;

  const SimoHeader({
    super.key,
    required this.puntosVerdes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 48, 28, 20),
      decoration: const BoxDecoration(
        color: Color(0xFFF7F4EC),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'SIMÖ',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFD8006B),
              letterSpacing: 2,
            ),
          ),
          Row(
            children: [
              Image.asset(
                'assets/imagenes/opciones/flor.png',
                height: 28,
              ),
              const SizedBox(width: 8),
              Text(
                puntosVerdes.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D4EA2), // Assuming blue color for points
                ),
              ),
              const SizedBox(width: 16),
              Stack(
                children: [
                  const Icon(
                    Icons.notifications,
                    color: Colors.black87,
                    size: 32,
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD8006B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
