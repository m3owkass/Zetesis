import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/tarefa_providers.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';

class AddTaskForm extends ConsumerStatefulWidget {
  const AddTaskForm({super.key});

  @override
  ConsumerState<AddTaskForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<AddTaskForm> {
  final List<TextEditingController> _textEditingControllers = [
    TextEditingController(),
  ];

  void addPergunta() {
    setState(() {
      _textEditingControllers.add(TextEditingController());
    });
  }

  @override
  void dispose() {
    for (var controller in _textEditingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarefasAsync = ref.watch(tarefasProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _textEditingControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: InputDecoration(label: Text('Pergunta ${index+1}')),
                    controller: _textEditingControllers[index],
                  ),
                );
              },
            ),
          ),
          TextButton(
            onPressed: addPergunta,
            child: const Text('Adicione pergunta'),
          ),
        ],
      ),
    );
  }
}
