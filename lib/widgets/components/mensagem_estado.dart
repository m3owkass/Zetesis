import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

class MensagemEstado extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String? subtitulo;

  const MensagemEstado({
    super.key,
    required this.icon,
    required this.titulo,
    this.subtitulo,
  });

  const MensagemEstado.erro({Key? key, String? subtitulo})
    : this(
        key: key,
        icon: Icons.cloud_off_rounded,
        titulo: 'Algo deu errado',
        subtitulo: subtitulo ?? 'Verifique sua conexão e tente novamente.',
      );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: AppColors.border),
            const SizedBox(height: AppSpacing.md),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitulo != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitulo!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
