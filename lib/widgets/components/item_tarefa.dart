import 'package:flutter/material.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

class ItemTarefa extends StatelessWidget {
  final TarefaModel tarefa;
  final bool isSelected;

  final bool concluida;
  final void Function(TarefaModel) onSelect;

  const ItemTarefa({
    super.key,
    required this.tarefa,
    required this.isSelected,
    this.concluida = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(tarefa),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected ? context.colors.primary : context.colors.card,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: isSelected ? context.colors.accent : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    tarefa.nome.isNotEmpty ? tarefa.nome : 'Sem nome',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? context.colors.onDark
                          : context.colors.primaryDark,
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Icon(Icons.check_circle, color: context.colors.onDark, size: 22),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: Text(
                tarefa.descricao,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: isSelected
                      ? context.colors.onDark.withValues(alpha: 0.7)
                      : context.colors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 14,
                  color: isSelected
                      ? context.colors.onDark.withValues(alpha: 0.7)
                      : context.colors.textSecondary,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${tarefa.perguntas.length} perguntas',
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? context.colors.onDark.withValues(alpha: 0.7)
                          : context.colors.textSecondary,
                    ),
                  ),
                ),
                if (concluida)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.success,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check,
                          size: 12,
                          color: context.colors.onDark,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Concluída',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: context.colors.onDark,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
