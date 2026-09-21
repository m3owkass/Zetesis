import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

class BibliotecaFiltros extends ConsumerStatefulWidget {
  const BibliotecaFiltros({super.key});

  @override
  ConsumerState<BibliotecaFiltros> createState() => _BibliotecaFiltrosState();
}

class _BibliotecaFiltrosState extends ConsumerState<BibliotecaFiltros> {
  late final _buscaController = TextEditingController(
    text: ref.read(buscaMaterialProvider),
  );

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final autores = ref.watch(autoresDoGrupoProvider);
    final autorSelecionado = ref.watch(filtroAutorProvider);
    final ordenacao = ref.watch(ordenacaoMaterialProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: TextField(
            controller: _buscaController,
            onChanged: (value) =>
                ref.read(buscaMaterialProvider.notifier).state = value,
            decoration: InputDecoration(
              hintText: 'Buscar por nome, autor ou descrição',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _buscaController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _buscaController.clear();
                        ref.read(buscaMaterialProvider.notifier).state = '';
                        setState(() {});
                      },
                    ),
              filled: true,
              fillColor: context.colors.card,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: AppSpacing.md,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.pill),
                borderSide: BorderSide(color: context.colors.border),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Row(
            children: [
              if (autores.length > 1) ...[
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: ChoiceChip(
                    label: const Text('Todos'),
                    selected: autorSelecionado == null,
                    onSelected: (_) =>
                        ref.read(filtroAutorProvider.notifier).state = null,
                    selectedColor: context.colors.primary,
                    labelStyle: TextStyle(
                      color: autorSelecionado == null
                          ? context.colors.onDark
                          : context.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    backgroundColor: context.colors.card,
                    side: BorderSide(color: context.colors.border),
                  ),
                ),
                for (final autor in autores)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: ChoiceChip(
                      label: Text(autor),
                      selected: autorSelecionado == autor,
                      onSelected: (_) =>
                          ref.read(filtroAutorProvider.notifier).state =
                              autor,
                      selectedColor: context.colors.primary,
                      labelStyle: TextStyle(
                        color: autorSelecionado == autor
                            ? context.colors.onDark
                            : context.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      backgroundColor: context.colors.card,
                      side: BorderSide(color: context.colors.border),
                    ),
                  ),
                Container(
                  height: 24,
                  width: 1,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                  ),
                  color: context.colors.border,
                ),
              ],
              PopupMenuButton<OrdenacaoMaterial>(
                initialValue: ordenacao,
                onSelected: (value) =>
                    ref.read(ordenacaoMaterialProvider.notifier).state =
                        value,
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: OrdenacaoMaterial.recentes,
                    child: Text('Mais recentes'),
                  ),
                  PopupMenuItem(
                    value: OrdenacaoMaterial.antigos,
                    child: Text('Mais antigos'),
                  ),
                  PopupMenuItem(
                    value: OrdenacaoMaterial.nome,
                    child: Text('Nome A-Z'),
                  ),
                  PopupMenuItem(
                    value: OrdenacaoMaterial.autor,
                    child: Text('Autor A-Z'),
                  ),
                ],
                child: Chip(
                  avatar: Icon(
                    Icons.sort,
                    size: 18,
                    color: context.colors.primary,
                  ),
                  label: Text(_tituloOrdenacao(ordenacao)),
                  backgroundColor: context.colors.card,
                  side: BorderSide(color: context.colors.border),
                  labelStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _tituloOrdenacao(OrdenacaoMaterial ordenacao) => switch (ordenacao) {
    OrdenacaoMaterial.recentes => 'Mais recentes',
    OrdenacaoMaterial.antigos => 'Mais antigos',
    OrdenacaoMaterial.nome => 'Nome A-Z',
    OrdenacaoMaterial.autor => 'Autor A-Z',
  };
}
