import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color backgroundDark;

  final Color surface;
  final Color field;
  final Color card;
  final Color border;
  final Color hint;

  final Color accent;
  final Color success;
  final Color successDark;
  final Color danger;
  final Color dangerDark;
  final Color star;

  final Color textPrimary;
  final Color textSecondary;
  final Color onDark;

  const AppColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.backgroundDark,
    required this.surface,
    required this.field,
    required this.card,
    required this.border,
    required this.hint,
    required this.accent,
    required this.success,
    required this.successDark,
    required this.danger,
    required this.dangerDark,
    required this.star,
    required this.textPrimary,
    required this.textSecondary,
    required this.onDark,
  });

  static const light = AppColors(
    primary: Color(0xff6055a2),
    primaryDark: Color(0xff38344f),
    primaryLight: Color(0xff8175c8),
    backgroundDark: Color(0xff251d30),
    surface: Color(0xfff8efeb),
    field: Color(0xffe8ddd8),
    card: Color(0xffddd6d2),
    border: Color(0xffcbafa2),
    hint: Color(0xffb7aac6),
    accent: Color(0xfff0915a),
    success: Color(0xff66bb6a),
    successDark: Color(0xff2e7d32),
    danger: Color(0xffef5350),
    dangerDark: Color(0xffc62828),
    star: Color(0xffffb300),
    textPrimary: Color(0xff38344f),
    textSecondary: Color(0xff6b6779),
    onDark: Colors.white,
  );

  static const dark = AppColors(
    primary: Color(0xff9d93d1),
    primaryDark: Color(0xffe4e0f5),
    primaryLight: Color(0xffb3aade),
    backgroundDark: Color(0xff0f0c14),
    surface: Color(0xff1c1824),
    field: Color(0xff2b2534),
    card: Color(0xff2b2534),
    border: Color(0xff453d52),
    hint: Color(0xff9086a3),
    accent: Color(0xfff0915a),
    success: Color(0xff81c784),
    successDark: Color(0xffa5d6a7),
    danger: Color(0xffef5350),
    dangerDark: Color(0xffef9a9a),
    star: Color(0xffffca28),
    textPrimary: Color(0xffece8f2),
    textSecondary: Color(0xffb8b0c9),
    onDark: Colors.white,
  );

  @override
  AppColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? backgroundDark,
    Color? surface,
    Color? field,
    Color? card,
    Color? border,
    Color? hint,
    Color? accent,
    Color? success,
    Color? successDark,
    Color? danger,
    Color? dangerDark,
    Color? star,
    Color? textPrimary,
    Color? textSecondary,
    Color? onDark,
  }) {
    return AppColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      surface: surface ?? this.surface,
      field: field ?? this.field,
      card: card ?? this.card,
      border: border ?? this.border,
      hint: hint ?? this.hint,
      accent: accent ?? this.accent,
      success: success ?? this.success,
      successDark: successDark ?? this.successDark,
      danger: danger ?? this.danger,
      dangerDark: dangerDark ?? this.dangerDark,
      star: star ?? this.star,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      onDark: onDark ?? this.onDark,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      field: Color.lerp(field, other.field, t)!,
      card: Color.lerp(card, other.card, t)!,
      border: Color.lerp(border, other.border, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      success: Color.lerp(success, other.success, t)!,
      successDark: Color.lerp(successDark, other.successDark, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerDark: Color.lerp(dangerDark, other.dangerDark, t)!,
      star: Color.lerp(star, other.star, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      onDark: Color.lerp(onDark, other.onDark, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
