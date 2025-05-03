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
    return BottomNavigationBar(
      backgroundColor: getFigmaColor(context, 'Schemes', 'Surface'),
      selectedItemColor: getFigmaColor(context, 'Primary', 'Main'),
      unselectedItemColor: getFigmaColor(context, 'Secondary', 'Main'),
      currentIndex: _getActiveIndex(),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'Tips'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentRoute != '/Home') Navigator.pushReplacementNamed(context, '/Home');
            break;
          case 1:
            if (currentRoute != '/Tips') Navigator.pushReplacementNamed(context, '/Tips');
            break;
          case 2:
            if (currentRoute != '/Search') Navigator.pushReplacementNamed(context, '/Search');
            break;
          case 3:
            if (currentRoute != '/Settings') Navigator.pushReplacementNamed(context, '/Settings');
            break;
        }
      },
    );
  }
}