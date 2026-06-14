import 'package:flutter/material.dart';
import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

/// dropdown que mostra uma pergunta, quando abre mostra as respostas com
/// a certa destacada e a explicacao
class PerguntaExpansivel extends StatelessWidget {
  final int numero;
  final PerguntaModel pergunta;

  const PerguntaExpansivel({
    super.key,
    required this.numero,
    required this.pergunta,
  });

  String get _tipoLabel => switch (pergunta.tipo) {
    TipoPergunta.multipla => 'Múltipla escolha',
    TipoPergunta.vf => 'Verdadeiro/Falso',
    TipoPergunta.lacuna => 'Lacuna',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        // tira a linha divisoria padrao do ExpansionTile
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          leading: Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$numero',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(pergunta.enunciado, style: theme.textTheme.titleMedium),
          subtitle: Text(_tipoLabel, style: theme.textTheme.bodySmall),
          children: [
            for (final resposta in pergunta.respostas)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      resposta.isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: resposta.isCorrect
                          ? AppColors.success
                          : AppColors.hint,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        resposta.texto,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: resposta.isCorrect
                              ? AppColors.successDark
                              : null,
                          fontWeight: resposta.isCorrect
                              ? FontWeight.w600
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (pergunta.explicacao.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.field,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  pergunta.explicacao,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
