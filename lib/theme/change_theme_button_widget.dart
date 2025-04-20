import 'package:eluthozhi_v3/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;

    return Switch.adaptive(
      value: isDark,
      onChanged: (value) {
        context.read<ThemeProvider>().toggleTheme();
      },
    );
  }
}
