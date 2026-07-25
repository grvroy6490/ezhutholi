import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String currentRoute;

  const BottomNavBar({super.key, required this.currentRoute});

  int _getActiveIndex() {
    switch (currentRoute) {
      case '/Home':
        return 0;
      case '/Tips':
        return 1;
      case '/Search':
        return 2;
      case '/Settings':
        return 3;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = getFigmaColor(context, 'Primary', 'Main');
    final secondary = getFigmaColor(context, 'Secondary', 'Main');
    final surface = getFigmaColor(context, 'Schemes', 'Surface');
    final activeIndex = _getActiveIndex();

    Widget navIcon(IconData icon, int index) {
      final selected = activeIndex == index;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? primary.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: selected ? primary : secondary),
      );
    }

    return BottomNavigationBar(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: secondary,
      selectedLabelStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 12,
      ),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      currentIndex: activeIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: navIcon(Icons.home_outlined, 0),
          activeIcon: navIcon(Icons.home, 0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: navIcon(Icons.lightbulb_outline, 1),
          activeIcon: navIcon(Icons.lightbulb, 1),
          label: 'Tips & Guides',
        ),
        BottomNavigationBarItem(
          icon: navIcon(Icons.search, 2),
          activeIcon: navIcon(Icons.search, 2),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: navIcon(Icons.settings_outlined, 3),
          activeIcon: navIcon(Icons.settings, 3),
          label: 'Settings',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentRoute != '/Home') {
              Navigator.pushReplacementNamed(context, '/Home');
            }
            break;
          case 1:
            if (currentRoute != '/Tips') {
              Navigator.pushReplacementNamed(context, '/Tips');
            }
            break;
          case 2:
            if (currentRoute != '/Search') {
              Navigator.pushReplacementNamed(context, '/Search');
            }
            break;
          case 3:
            if (currentRoute != '/Settings') {
              Navigator.pushReplacementNamed(context, '/Settings');
            }
            break;
        }
      },
    );
  }
}
