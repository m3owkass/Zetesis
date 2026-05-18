import 'package:flutter/material.dart';
import 'package:zetesis/model/item_loja.dart';

class ItemLoja extends StatelessWidget {
  final ItemLojaModel item;

  ItemLoja({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160.0,
      child: Center(child: Text(item.nome)),
    );
  }
}
