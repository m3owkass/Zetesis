import 'package:flutter/material.dart';

enum FieldType { username, email, password, platform, description }

class CustomFormField extends StatefulWidget {
  final TextEditingController controller;
  final FieldType fieldType;
  final String label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Icon? preffixIcon;

  const CustomFormField({
    super.key,
    required this.controller,
    required this.fieldType,
    required this.label,
    this.hint,
    this.validator,
    this.labelStyle,
    this.hintStyle,
    this.preffixIcon
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
    final normalColor = widget.labelStyle?.color ??  Color(0xff4c4666);

    return TextFormField(
      controller: widget.controller,
      obscureText: widget.fieldType == FieldType.password ? _obscure : false,
      validator: widget.validator,
      keyboardType: _getKeyboardType(),
      style:  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      cursorColor: Colors.white70,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        hintStyle: widget.hintStyle,
        prefixIcon: widget.preffixIcon,
        border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff4c4666))),
        
        
        

        labelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color: Colors.white);
          }
          return TextStyle(color: normalColor);
        }),

        floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
          if (states.contains(WidgetState.error)) {
            return TextStyle(color: errorColor);
          }
          if (states.contains(WidgetState.focused)) {
            return const TextStyle(color:Color(0xff5f54a0));
          }
          return TextStyle(color: Color(0xff4c4666));
        }),
        suffixIcon: widget.fieldType == FieldType.password
            ? IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,  
                  color: Color(0xff5f54a0),
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