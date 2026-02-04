import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLogo({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Hero(
      tag: 'app_logo',
      child: Icon(
        Icons.gavel_rounded,
        size: size,
        color: color ?? theme.colorScheme.primary,
      ),
    );
  }
}
