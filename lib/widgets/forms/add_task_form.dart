import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/provider/tarefa_providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/widgets/components/custom_formfield.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/forms/pergunta_draft_form.dart';

class AddTaskForm extends ConsumerStatefulWidget {
  const AddTaskForm({super.key});

  @override
  ConsumerState<AddTaskForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<AddTaskForm> {
  final List<TextEditingController> _perguntasControllers = [
    TextEditingController(),
  ];



  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _temaController = TextEditingController();

  void addPergunta() {
    setState(() {
      _perguntasControllers.add(TextEditingController());
    });
  }

  void deletePergunta(int index) {
    setState(() {
      _perguntasControllers.removeAt(index).dispose();
    });
  }


  @override
  void dispose() {
    for (var controller in _perguntasControllers) {
      controller.dispose();
    }

    _temaController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tarefasAsync = ref.watch(tarefasProvider);
    final temasAsync = ref.watch(temasProvider);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(label: Text('Nome')),
              controller: _nomeController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Expanded(
              child: temasAsync.when(
                data: (temas) => temas.isEmpty
                    ? const MensagemEstado(
                        icon: Icons.category_outlined,
                        titulo: 'Nenhum tema disponível',
                        subtitulo: 'Os temas ainda não foram cadastrados.',
                      )
                    : DropdownMenuFormField(
                        label: Text("Selecione um Tema"),
                        controller: _temaController,
                        dropdownMenuEntries: temas
                            .map<DropdownMenuEntry<String>>((tema) {
                              return DropdownMenuEntry<String>(
                                value: tema.nome,
                                label: tema.nome,
                              );
                            })
                            .toList(),
                      ),
                error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar os temas.',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ),

          PerguntaDraftForm()
        ],
      ),
    );
  }
}
