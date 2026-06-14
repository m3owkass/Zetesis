import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/widgets/components/pontos_badge.dart';

class QuizTopBar extends StatelessWidget {
  final double progresso;
  final int pontos;
  final VoidCallback onClose;

  const QuizTopBar({
    super.key,
    required this.progresso,
    required this.pontos,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: AppColors.primaryDark),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: progresso),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 12,
                  backgroundColor: AppColors.field,
                  color: AppColors.success,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          PontosBadge(valor: pontos, iconSize: 24, fontSize: 16),
        ],
      ),
    );
  }
}
