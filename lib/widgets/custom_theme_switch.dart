import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';

class CustomThemeSwitch extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const CustomThemeSwitch({
    super.key,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 50,
        height: 20,
        padding: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: getFigmaColor(context, 'Surface', 'Surface Container Highest'),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: isDark ? 25 : 0,
              right: isDark ? 0 : 25,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: getFigmaColor(context, 'Primary', 'Main'),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                  color: getFigmaColor(context, 'Primary', 'On Main'),
                  size: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
