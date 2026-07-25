import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';

/// **Custom Submit Button**
class CustomSubmitButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const CustomSubmitButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: getFigmaColor(context, 'Primary', 'Dark'),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: getFigmaColor(context, 'Primary', 'On Main'),
        ),
      ),
    );
  }
}

/// **Custom Social Login Button**
class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget icon; // Change from IconData to Widget

  const SocialLoginButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
        backgroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Primary', 'On Main')),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        foregroundColor: WidgetStateProperty.all(getFigmaColor(context, 'Primary', 'Main')),
      ),
      onPressed: onPressed,
      icon: icon, // Use the widget directly
      label: Text(text),
    );
  }
}
