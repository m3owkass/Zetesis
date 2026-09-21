import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class ResultadoTarefa extends StatelessWidget {
  final int acertos;
  final int total;
  final int pontosGanhos;
  final int melhorSequencia;
  final bool pratica;
  final VoidCallback onConcluir;

  final VoidCallback? onProxima;

  const ResultadoTarefa({
    super.key,
    required this.acertos,
    required this.total,
    required this.pontosGanhos,
    required this.melhorSequencia,
    required this.pratica,
    required this.onConcluir,
    this.onProxima,
  });

  @override
  Widget build(BuildContext context) {
    final perfeito = total > 0 && acertos == total;

    return Scaffold(
      backgroundColor: context.colors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Icon(
                perfeito ? Icons.emoji_events : Icons.flag,
                color: context.colors.star,
                size: 96,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                perfeito ? 'Perfeito!' : 'Tarefa concluída!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: context.colors.onDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Você acertou $acertos de $total perguntas',
                style: TextStyle(
                  fontSize: 18,
                  color: context.colors.onDark.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: context.colors.primaryDark,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      pratica ? Icons.replay : Icons.star,
                      color: context.colors.star,
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      pratica
                          ? 'Prática — sem phatos'
                          : '+$pontosGanhos phatos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: context.colors.onDark,
                      ),
                    ),
                  ],
                ),
              ),
              if (melhorSequencia >= 2) ...[
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: context.colors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Melhor sequência: $melhorSequencia',
                      style: TextStyle(
                        fontSize: 15,
                        color: context.colors.onDark.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
              const Spacer(),
              if (onProxima != null) ...[
                AppButton(
                  label: 'Próxima tarefa',
                  variant: AppButtonVariant.accent,
                  onPressed: onProxima,
                ),
                const SizedBox(height: 12),
              ],
              AppButton(
                label: 'Concluir',
                variant: AppButtonVariant.success,
                onPressed: onConcluir,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
