import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.onBuscar,
    this.hint = 'Buscar materiais...',
    this.initialValue = '',
  });

  final ValueChanged<String> onBuscar;
  final String hint;
  final String initialValue;

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  late final TextEditingController _controller;
  bool _temTexto = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _temTexto = widget.initialValue.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant CustomSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.initialValue,
        selection: TextSelection.collapsed(offset: widget.initialValue.length),
      );
      if (_temTexto != widget.initialValue.isNotEmpty) {
        setState(() => _temTexto = widget.initialValue.isNotEmpty);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _aoMudar(String valor) {
    final temTexto = valor.isNotEmpty;
    if (temTexto != _temTexto) {
      setState(() => _temTexto = temTexto);
    }
    widget.onBuscar(valor);
  }

  void _limpar() {
    _controller.clear();
    setState(() => _temTexto = false);
    widget.onBuscar('');
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: TextField(
        controller: _controller,
        onChanged: _aoMudar,
        textInputAction: TextInputAction.search,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: cs.surfaceContainerHighest,
          prefixIcon: Icon(Icons.search, color: cs.primary),
          suffixIcon: _temTexto
              ? IconButton(
                  icon: Icon(Icons.close, color: cs.onSurfaceVariant),
                  onPressed: _limpar,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            borderSide: BorderSide(color: cs.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
