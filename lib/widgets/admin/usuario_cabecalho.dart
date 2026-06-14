import 'package:flutter/material.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

/// cabecalho do usuario no dialog de detalhes com avatar, phatos, ranking
/// e badges
class UsuarioCabecalho extends StatelessWidget {
  final UsuarioModel usuario;

  const UsuarioCabecalho({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // avatar
        Container(
          width: 72,
          height: 72,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.field,
            border: Border.all(color: AppColors.border),
          ),
          child: StorageImage(
            path: usuario.avatarUrl,
            fit: BoxFit.cover,
            placeholder: const Icon(
              Icons.person,
              size: 36,
              color: AppColors.hint,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // phatos e ranking lado a lado
        Row(
          children: [
            Expanded(
              child: _Stat(
                icone: Image.asset('assets/phatos.webp', height: 28),
                valor: '${usuario.pontos}',
                label: 'Phatos',
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Stat(
                icone: const Icon(
                  Icons.military_tech_rounded,
                  color: AppColors.primary,
                  size: 28,
                ),
                valor: usuario.ranking,
                label: 'Ranking',
              ),
            ),
          ],
        ),
        // badges de papel
        if (usuario.admin || usuario.developer) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              if (usuario.admin)
                const _Badge(label: 'Admin', cor: AppColors.primary),
              if (usuario.developer)
                const _Badge(label: 'Developer', cor: AppColors.accent),
            ],
          ),
        ],
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final Widget icone;
  final String valor;
  final String label;

  const _Stat({required this.icone, required this.valor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          SizedBox(height: 28, child: icone),
          const SizedBox(height: AppSpacing.xs),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color cor;

  const _Badge({required this.label, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: cor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
