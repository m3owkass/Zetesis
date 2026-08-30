import 'package:flutter/material.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/forms/add_task_form.dart';
import 'package:zetesis/widgets/forms/add_tema_form.dart';
import 'package:zetesis/widgets/forms/update_tema_form.dart';



class UpdateTemaDialog extends StatelessWidget {
  const UpdateTemaDialog({super.key,});

  final cor = AppColors.primary;
  final icon = Icons.note_add;
  final titulo = "Atualizar Tema";
  
  

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Atualizar Tema'),
          Icon(Icons.note_add)
        ],
      )),
      body: Column(
        children: [
          Expanded(child: UpdateTemaForm())
        ],
      ),
    );
  }
}
