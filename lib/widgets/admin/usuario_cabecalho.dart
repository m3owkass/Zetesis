import 'package:flutter/material.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class UsuarioCabecalho extends StatelessWidget {
  final UsuarioModel usuario;

  const UsuarioCabecalho({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.colors.field,
            border: Border.all(color: context.colors.border),
          ),
          child: StorageImage(
            path: usuario.avatarUrl,
            fit: BoxFit.cover,
            placeholder: Icon(
              Icons.person,
              size: 36,
              color: context.colors.hint,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
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
                icone: Icon(
                  Icons.military_tech_rounded,
                  color: context.colors.primary,
                  size: 28,
                ),
                valor: usuario.ranking,
                label: 'Ranking',
              ),
            ),
          ],
        ),
        if (usuario.admin || usuario.developer) ...[
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              if (usuario.admin)
                _Badge(label: 'Admin', cor: context.colors.primary),
              if (usuario.developer)
                _Badge(label: 'Developer', cor: context.colors.accent),
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
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: context.colors.border),
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
