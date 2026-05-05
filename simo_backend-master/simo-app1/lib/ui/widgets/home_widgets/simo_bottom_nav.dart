import 'package:flutter/material.dart';

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
      decoration: const BoxDecoration(
        color: Color(0xFFF7F4EC),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          backgroundColor: const Color(0xFFF7F4EC),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF2D4EA2), // Assuming selected is blue
          unselectedItemColor: Colors.black87,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.home_filled, 0),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.grid_view, 1),
              label: 'Opciones',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.autorenew, 2),
              label: 'Canjear',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(Icons.person, 3),
              label: 'Usuario',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index) {
    bool isSelected = currentIndex == index;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isSelected ? const Color(0xFF2D4EA2) : Colors.black87,
          size: 28,
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 30,
            color: const Color(0xFF2D4EA2),
          ),
      ],
    );
  }
}
