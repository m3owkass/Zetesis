import 'package:flutter/material.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/selecao_tarefa_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class PainelTema extends StatelessWidget {
  final TemaModel tema;
  final List<TarefaModel> tarefas;
  final int feitas;

  const PainelTema({
    super.key,
    required this.tema,
    required this.tarefas,
    required this.feitas,
  });

  @override
  Widget build(BuildContext context) {
    final total = tarefas.length;
    final progresso = total == 0 ? 0.0 : feitas / total;
    final tudoFeito = total > 0 && feitas == total;

    return Column(
      children: [
        Text(
          tema.nome,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (tema.descricao.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            tema.descricao,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progresso',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    total == 0 ? '—' : '$feitas/$total tarefas',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progresso,
                  minHeight: 12,
                  backgroundColor: AppColors.field,
                  color: tudoFeito ? AppColors.success : AppColors.accent,
                ),
              ),
              if (tudoFeito) ...[
                const SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: AppColors.star,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Tema concluído!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: total == 0
              ? 'Nenhuma tarefa neste tema'
              : feitas == 0
              ? 'Iniciar desafio'
              : 'Continuar',
          variant: AppButtonVariant.accent,
          onPressed: total == 0
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SelecaotarefaScreen(),
                  ),
                ),
        ),
      ],
    );
  }
}
