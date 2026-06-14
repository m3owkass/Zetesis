import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';

class PontosBadge extends StatelessWidget {
  final int valor;
  final double iconSize;
  final double fontSize;
  final Color textColor;

  const PontosBadge({
    super.key,
    required this.valor,
    this.iconSize = 28,
    this.fontSize = 18,
    this.textColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/phatos.webp', height: iconSize),
        const SizedBox(width: 4),
        Text(
          '$valor',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
