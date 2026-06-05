import 'package:flutter/material.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/widgets/components/item_card.dart';

class ItemLoja extends StatelessWidget {
  final ItemLojaModel item;

  const ItemLoja({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ItemCard(
      imageUrl: item.assetUrl,
      title: item.nome,
      footer: Text(
        '${item.custo} pts',
        style: const TextStyle(
          color: Color(0xff6055a2),
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
