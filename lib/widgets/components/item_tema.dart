import 'package:flutter/material.dart';
import 'package:zetesis/model/tema.dart';
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
          Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xfff0915a)
                  : const Color(0xff6055a2),
              borderRadius: BorderRadius.circular(200),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 3)
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ClipOval(
                child: SizedBox(
                  width: 132,
                  height: 132,
                  child: tema.assetUrl.isNotEmpty
                      ? StorageImage(path: tema.assetUrl, fit: BoxFit.cover)
                      : ColoredBox(
                          color: Colors.grey.shade700,
                          child: Center(
                            child: Text(
                              tema.nome.isNotEmpty
                                  ? tema.nome[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                fontSize: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff6055a2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              tema.nome,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
