import 'package:flutter/material.dart';
import 'package:zetesis/model/item_loja.dart';

class ItemLoja extends StatelessWidget {
  final ItemLojaModel item;

  const ItemLoja({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xffddd6d2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (item.assetUrl != null && item.assetUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.assetUrl!,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            item.nome,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${item.custo} pts',
            style: const TextStyle(
              color: Color(0xff6055a2),
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
