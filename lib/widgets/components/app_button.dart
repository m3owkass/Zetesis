import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

enum AppButtonVariant { primary, success, danger, accent, neutral }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool loading;
  final bool expand;
  final IconData? icon;
  final double height;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.loading = false,
    this.expand = true,
    this.icon,
    this.height = 52,
  });

  ({Color bg, Color fg, BorderSide side}) get _colors => switch (variant) {
    AppButtonVariant.primary => (
      bg: AppColors.primary,
      fg: Colors.white,
      side: BorderSide.none,
    ),
    AppButtonVariant.success => (
      bg: AppColors.success,
      fg: Colors.white,
      side: BorderSide.none,
    ),
    AppButtonVariant.danger => (
      bg: AppColors.danger,
      fg: Colors.white,
      side: BorderSide.none,
    ),
    AppButtonVariant.accent => (
      bg: AppColors.accent,
      fg: AppColors.primaryDark,
      side: BorderSide.none,
    ),
    AppButtonVariant.neutral => (
      bg: Colors.white,
      fg: AppColors.primary,
      side: const BorderSide(color: AppColors.border),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final habilitado = onPressed != null && !loading;

    final botao = ElevatedButton(
      onPressed: habilitado ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: c.bg,
        foregroundColor: c.fg,
        disabledBackgroundColor: AppColors.border.withValues(alpha: 0.5),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        minimumSize: Size(0, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
          side: c.side,
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      child: loading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2, color: c.fg),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: botao) : botao;
  }
}
