import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';

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
    if (item == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xffddd6d2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 56, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item!.nome,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (item!.autor != null)
                    Text(
                      'ENVIADO POR: ${item!.autor}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  if (item!.dataEnvio != null)
                    Text(
                      'em ${item!.dataEnvio}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  if (item!.descricao != null && item!.descricao!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      item!.descricao!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onFavorite,
                child: Container(
                  width: 44,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isFavorito
                        ? const Color(0xff4a7fc1)
                        : const Color(0xff4a7fc1).withAlpha(80),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    isFavorito ? Icons.star : Icons.star_border,
                    color: Colors.white,
                    size: 24,
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
