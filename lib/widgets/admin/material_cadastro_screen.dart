import 'package:flutter/material.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/widgets/forms/add_material_form.dart';

class MaterialDialog extends StatelessWidget {
  final MaterialBibliotecaModel? material;

  const MaterialDialog({super.key, this.material});

  @override
  Widget build(BuildContext context) {
    final editando = material != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(editando ? 'Editar Material' : 'Adicionar Material'),
            const Icon(Icons.note_add),
          ],
        ),
      ),
      body: Column(
        children: [Expanded(child: AddMaterialForm(material: material))],
      ),
    );
  }
}
