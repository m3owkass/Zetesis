import 'package:flutter/material.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/widgets/forms/add_item_loja_form.dart';

class ItemLojaDialog extends StatelessWidget {
  final ItemLojaModel? item;

  const ItemLojaDialog({super.key, this.item});

  @override
  Widget build(BuildContext context) {
    final editando = item != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(editando ? 'Editar Item' : 'Adicionar Item'),
            const Icon(Icons.add_shopping_cart),
          ],
        ),
      ),
      body: Column(children: [Expanded(child: AddItemLojaForm(item: item))]),
    );
  }
}
