import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class PainelFeedback extends StatelessWidget {
  final bool acertou;
  final bool comboAtivo;
  final int sequencia;
  final int ultimoGanho;
  final String explicacao;
  final bool ultima;
  final VoidCallback onContinuar;

  const PainelFeedback({
    super.key,
    required this.acertou,
    required this.comboAtivo,
    required this.sequencia,
    required this.ultimoGanho,
    required this.explicacao,
    required this.ultima,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    final corTexto = acertou ? AppColors.successDark : AppColors.dangerDark;
    final corFundo = (acertou ? AppColors.success : AppColors.danger)
        .withValues(alpha: 0.15);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                acertou ? Icons.check_circle : Icons.cancel,
                color: corTexto,
                size: 28,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  acertou ? 'Correto!' : 'Incorreto',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: corTexto,
                  ),
                ),
              ),
              if (acertou) ...[
                if (comboAtivo) ...[
                  _Selo(
                    cor: AppColors.accent,
                    icon: Icons.local_fire_department,
                    texto: 'x$sequencia',
                  ),
                  const SizedBox(width: 8),
                ],
                _Selo(
                  cor: AppColors.success,
                  icon: Icons.star,
                  texto: '+$ultimoGanho',
                ),
              ],
            ],
          ),
          if (explicacao.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              explicacao,
              style: TextStyle(fontSize: 15, height: 1.35, color: corTexto),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: ultima ? 'Ver resultado' : 'Continuar',
            variant: acertou
                ? AppButtonVariant.success
                : AppButtonVariant.danger,
            onPressed: onContinuar,
          ),
        ],
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  final Color cor;
  final IconData icon;
  final String texto;

  const _Selo({required this.cor, required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
