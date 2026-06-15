import 'package:flutter/material.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class AcaoSecao {
  final String label;
  final AppButtonVariant variant;
  final VoidCallback onPressed;

  const AcaoSecao({
    required this.label,
    required this.variant,
    required this.onPressed,
  });
}
