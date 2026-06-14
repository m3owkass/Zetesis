import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/components/app_button.dart';

/// uma linha rotulo: valor dentro do dialog de detalhes
///
/// linha com valor vazio some sozinha, entao da pra listar todos os
/// campos sem se preocupar com os opcionais
class DetalheLinha {
  final String rotulo;
  final String? valor;

  const DetalheLinha(this.rotulo, this.valor);
}

/// dialog de detalhes generico, o visual e fixo e cada tela so passa o
/// titulo e a lista de linhas
class DetalhesDialog extends StatelessWidget {
  final IconData icon;
  final Color cor;
  final String titulo;
  final List<DetalheLinha> linhas;

  /// botoes de acao da tela, como editar, excluir e tornar admin, eles
  /// ficam embaixo dos dados, o dialog nao fecha sozinho quando voce clica,
  /// entao chame `Navigator.pop(context)` dentro do `onPressed` se quiser fechar
  final List<AcaoSecao> acoes;

  /// conteudo livre que aparece acima das linhas, serve pra coisas como o
  /// avatar e os dados do usuario
  final Widget? cabecalho;

  /// conteudo livre que aparece abaixo das linhas e acima dos botoes, serve
  /// pra coisa que nao cabe num par rotulo/valor, tipo a lista de perguntas
  /// de uma tarefa
  final Widget? conteudoExtra;

  const DetalhesDialog({
    super.key,
    required this.icon,
    required this.cor,
    required this.titulo,
    required this.linhas,
    this.acoes = const [],
    this.cabecalho,
    this.conteudoExtra,
  });

  /// abre o dialog, atalho pro `showDialog`
  static Future<void> mostrar(
    BuildContext context, {
    required IconData icon,
    required Color cor,
    required String titulo,
    required List<DetalheLinha> linhas,
    List<AcaoSecao> acoes = const [],
    Widget? cabecalho,
    Widget? conteudoExtra,
  }) {
    return showDialog(
      context: context,
      builder: (_) => DetalhesDialog(
        icon: icon,
        cor: cor,
        titulo: titulo,
        linhas: linhas,
        acoes: acoes,
        cabecalho: cabecalho,
        conteudoExtra: conteudoExtra,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visiveis = linhas
        .where((l) => l.valor != null && l.valor!.trim().isNotEmpty)
        .toList();

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: cor),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(titulo, style: Theme.of(context).textTheme.titleLarge),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (cabecalho != null) ...[
                cabecalho!,
                const SizedBox(height: AppSpacing.md),
              ],
              for (final linha in visiveis) ...[
                Text(
                  linha.rotulo,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  linha.valor!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              if (conteudoExtra != null) ...[
                conteudoExtra!,
                const SizedBox(height: AppSpacing.md),
              ],
              for (final acao in acoes) ...[
                AppButton(
                  label: acao.label,
                  variant: acao.variant,
                  height: 44,
                  onPressed: acao.onPressed,
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
