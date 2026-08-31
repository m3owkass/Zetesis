import 'package:flutter/material.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/widgets/forms/add_task_form.dart';

class TasksDialog extends StatelessWidget {
  final TarefaModel? tarefa;

  const TasksDialog({super.key, this.tarefa});

  @override
  Widget build(BuildContext context) {
    final editando = tarefa != null;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(editando ? 'Editar Tarefa' : 'Adicionar Tarefa'),
            const Icon(Icons.note_add),
          ],
        ),
      ),
      body: Column(children: [Expanded(child: AddTaskForm(tarefa: tarefa))]),
    );
  }
}
