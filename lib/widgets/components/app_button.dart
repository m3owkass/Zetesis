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

  ({Color bg, Color fg, BorderSide side}) _colors(BuildContext context) =>
      switch (variant) {
        AppButtonVariant.primary => (
          bg: context.colors.primary,
          fg: context.colors.onDark,
          side: BorderSide.none,
        ),
        AppButtonVariant.success => (
          bg: context.colors.success,
          fg: context.colors.onDark,
          side: BorderSide.none,
        ),
        AppButtonVariant.danger => (
          bg: context.colors.danger,
          fg: context.colors.onDark,
          side: BorderSide.none,
        ),
        AppButtonVariant.accent => (
          bg: context.colors.accent,
          fg: context.colors.primaryDark,
          side: BorderSide.none,
        ),
        AppButtonVariant.neutral => (
          bg: context.colors.card,
          fg: context.colors.primary,
          side: BorderSide(color: context.colors.border),
        ),
      };

  @override
  Widget build(BuildContext context) {
    final c = _colors(context);
    final habilitado = onPressed != null && !loading;

    final botao = ElevatedButton(
      onPressed: habilitado ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: c.bg,
        foregroundColor: c.fg,
        disabledBackgroundColor: context.colors.border.withValues(alpha: 0.5),
        disabledForegroundColor: context.colors.onDark,
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
