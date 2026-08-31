import 'package:flutter/material.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/widgets/forms/add_tema_form.dart';

class TemaDialog extends StatelessWidget {
  final TemaModel? tema;

  const TemaDialog({super.key, this.tema});

  @override
  Widget build(BuildContext context) {
    final editando = tema != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(editando ? 'Editar Tema' : 'Adicionar Tema'),
            const Icon(Icons.note_add),
          ],
        ),
      ),
      body: Column(children: [Expanded(child: AddTemaForm(tema: tema))]),
    );
  }
}
