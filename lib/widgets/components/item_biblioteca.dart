import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class ItemBiblioteca extends StatelessWidget {
  final MaterialBibliotecaModel? item;
  final bool isFavorito;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;

  const ItemBiblioteca({
    super.key,
    required this.item,
    this.isFavorito = false,
    this.onFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final item = this.item;
    if (item == null) return const SizedBox.shrink();

    final temImagem = ehExtensaoDeImagem(item.assetUrl);
    final temAnexo = item.assetUrl != null && item.assetUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: AppColors.border),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 56, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (temImagem) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: StorageImage(
                        path: item.assetUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primaryDark,
                          ),
                        ),
                        if (item.autor != null) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            item.autor!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                        if (item.descricao != null &&
                            item.descricao!.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            item.descricao!,
                            style: const TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (temAnexo && !temImagem) ...[
                          const SizedBox(height: AppSpacing.sm),
                          const Row(
                            children: [
                              Icon(
                                Icons.attachment,
                                size: 16,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                'Toque para abrir o anexo',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onFavorite,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      isFavorito ? Icons.star : Icons.star_border,
                      color: isFavorito ? AppColors.star : AppColors.border,
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
