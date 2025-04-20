import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthLogoHeader extends StatelessWidget {
  final double height;
  final double width;
  final String assetPath;
  final double borderRadius;

  const AuthLogoHeader({
    super.key,
    this.height = 100,
    this.width = 230,
    this.assetPath = 'assets/images/eluthozhi_logo.svg',
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SvgPicture.asset(
          assetPath,
          width: width,
        ),
      ),
    );
  }
}
