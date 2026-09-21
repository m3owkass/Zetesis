import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';

enum FieldType { username, email, password, platform, description }

const _kFieldColors = AppColors.dark;

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Icon? prefixIcon;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.fieldType,
    required this.label,
    this.hint,
    this.validator,
    this.labelStyle,
    this.hintStyle,
    this.prefixIcon,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscure = true;

  TextInputType _getKeyboardType() {
    switch (widget.fieldType) {
      case FieldType.username:
        return TextInputType.text;
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.password:
        return TextInputType.visiblePassword;
      case FieldType.platform:
        return TextInputType.text;
      case FieldType.description:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final normalColor = widget.labelStyle?.color ?? _kFieldColors.hint;
    final focusColor = _kFieldColors.primaryLight;

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.fieldType == FieldType.password ? _obscure : false,
      validator: widget.validator,
      keyboardType: _getKeyboardType(),
      style: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return TextStyle(color: focusColor);
        }
        return TextStyle(color: normalColor);
      }),

      cursorColor: _kFieldColors.onDark.withValues(alpha: 0.7),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        prefixIcon: widget.prefixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: _kFieldColors.border),
        ),

        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return TextStyle(color: focusColor);
          }
          return TextStyle(color: normalColor);
        }),

        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return TextStyle(color: focusColor);
          }
          return TextStyle(color: normalColor);
        }),
        suffixIcon: widget.fieldType == FieldType.password
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: focusColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
