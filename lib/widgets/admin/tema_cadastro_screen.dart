import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/forms/add_task_form.dart';
import 'package:zetesis/widgets/forms/add_tema_form.dart';

class DetalheLinha {
  final String rotulo;
  final String? valor;

  const DetalheLinha(this.rotulo, this.valor);
}

class TemaDialog extends StatelessWidget {
  const TemaDialog({super.key});

  final cor = AppColors.primary;
  final icon = Icons.note_add;
  final titulo = "Adicionar Tema";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Adicionar Tema'),
          Icon(Icons.note_add)
        ],
      )),
      body: Column(
        children: [
          Expanded(child: AddTemaForm())
        ],
      ),
    );
  }
}
