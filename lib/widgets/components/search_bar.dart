import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_theme.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
    super.key,
    required this.onBuscar,
    this.hint = 'Buscar materiais...',
  });

  final ValueChanged<String> onBuscar;
  final String hint;

  @override
  State<CustomSearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _temTexto = false;

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
