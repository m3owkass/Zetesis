import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/forms/add_material_form.dart';
import 'package:zetesis/widgets/forms/add_task_form.dart';

class DetalheLinha {
  final String rotulo;
  final String? valor;

  const DetalheLinha(this.rotulo, this.valor);
}

class MaterialDialog extends StatelessWidget {
  const MaterialDialog({super.key});

  final cor = AppColors.primary;
  final icon = Icons.note_add;
  final titulo = "Adicionar Material";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Adicionar Material'),
          Icon(Icons.note_add)
        ],
      )),
      body: Column(
        children: [
          Expanded(child: AddMaterialForm())
        ],
      ),
    );
  }
}
