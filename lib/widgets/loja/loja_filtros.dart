import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

class LojaFiltros extends ConsumerWidget {
  const LojaFiltros({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tipo = ref.watch(filtroTipoLojaProvider);
    final posse = ref.watch(filtroPosseLojaProvider);
    final ordenacao = ref.watch(ordenacaoLojaProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          for (final opcao in FiltroTipoLoja.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: ChoiceChip(
                label: Text(_tituloTipo(opcao)),
                selected: tipo == opcao,
                onSelected: (_) =>
                    ref.read(filtroTipoLojaProvider.notifier).state = opcao,
                selectedColor: context.colors.primary,
                labelStyle: TextStyle(
                  color: tipo == opcao
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
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            color: context.colors.border,
          ),
          for (final opcao in FiltroPosseLoja.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: ChoiceChip(
                label: Text(_tituloPosse(opcao)),
                selected: posse == opcao,
                onSelected: (_) =>
                    ref.read(filtroPosseLojaProvider.notifier).state = opcao,
                selectedColor: context.colors.primary,
                labelStyle: TextStyle(
                  color: posse == opcao
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
            margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            color: context.colors.border,
          ),
          PopupMenuButton<OrdenacaoLoja>(
            initialValue: ordenacao,
            onSelected: (value) =>
                ref.read(ordenacaoLojaProvider.notifier).state = value,
            itemBuilder: (context) => [
              for (final opcao in OrdenacaoLoja.values)
                PopupMenuItem(value: opcao, child: Text(_tituloOrdenacao(opcao))),
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
    );
  }

  String _tituloTipo(FiltroTipoLoja tipo) => switch (tipo) {
    FiltroTipoLoja.todos => 'Todos',
    FiltroTipoLoja.avatar => 'Avatar',
    FiltroTipoLoja.geral => 'Geral',
  };

  String _tituloPosse(FiltroPosseLoja posse) => switch (posse) {
    FiltroPosseLoja.todos => 'Todos',
    FiltroPosseLoja.adquiridos => 'Adquiridos',
    FiltroPosseLoja.naoAdquiridos => 'Não adquiridos',
  };

  String _tituloOrdenacao(OrdenacaoLoja ordenacao) => switch (ordenacao) {
    OrdenacaoLoja.padrao => 'Padrão',
    OrdenacaoLoja.menorPreco => 'Menor preço',
    OrdenacaoLoja.maiorPreco => 'Maior preço',
  };
}
