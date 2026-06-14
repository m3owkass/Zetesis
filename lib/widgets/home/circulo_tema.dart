import 'package:flutter/material.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/selecao_tema_screen.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class CirculoTema extends StatelessWidget {
  final TemaModel? tema;

  const CirculoTema({super.key, required this.tema});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width * 0.5;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SelecaoTemaScreen()),
      ),
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: (tema?.assetUrl != null && tema!.assetUrl.isNotEmpty)
                  ? StorageImage(path: tema!.assetUrl, fit: BoxFit.cover)
                  : Container(
                      color: AppColors.primary,
                      alignment: Alignment.center,
                      child: Text(
                        tema?.nome.isNotEmpty == true
                            ? tema!.nome[0].toUpperCase()
                            : '?',
                        style: const TextStyle(
                          fontSize: 56,
                          color: Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.touch_app_rounded,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                'Toque para trocar de tema',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
