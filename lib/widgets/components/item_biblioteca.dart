import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';

class ItemBiblioteca extends StatelessWidget {
  final MaterialBibliotecaModel? item;

  const ItemBiblioteca({super.key, required this.item});

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
          if (item?.assetUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item!.assetUrl!,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 8),
          Text(
            item!.nome,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          Text(
            item!.descricao ?? '?',
            style: const TextStyle(fontSize: 36, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
