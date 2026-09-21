import 'package:flutter/material.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class ItemTema extends StatelessWidget {
  final TemaModel tema;
  final bool isSelected;
  final void Function(TemaModel) onSelect;

  const ItemTema({
    super.key,
    required this.tema,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(tema),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.accent : context.colors.primary,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: context.colors.accent, width: 4)
                  : null,
            ),
            padding: const EdgeInsets.all(6),
            child: ClipOval(
              child: SizedBox(
                width: 120,
                height: 120,
                child: tema.assetUrl.isNotEmpty
                    ? StorageImage(path: tema.assetUrl, fit: BoxFit.cover)
                    : ColoredBox(
                        color: context.colors.primary,
                        child: Center(
                          child: Text(
                            tema.nome.isNotEmpty
                                ? tema.nome[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 36,
                              color: context.colors.onDark,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? context.colors.accent : context.colors.primary,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Text(
              tema.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: context.colors.onDark,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
