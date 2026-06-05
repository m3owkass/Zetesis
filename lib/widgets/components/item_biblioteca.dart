import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/widgets/components/item_card.dart';

class ItemBiblioteca extends StatelessWidget {
  final MaterialBibliotecaModel? item;

  const ItemBiblioteca({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      imageUrl: item?.assetUrl,
      title: item?.nome ?? '',
      footer: (item?.descricao != null && item!.descricao!.isNotEmpty)
          ? Text(
              item!.descricao!,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
    );
  }
}
