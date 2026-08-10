import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/forms/resposta_draft.dart';

class AddMaterialForm extends ConsumerStatefulWidget {
  const AddMaterialForm({super.key});

  @override
  ConsumerState<AddMaterialForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<AddMaterialForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final _dateController = TextEditingController(
    text: DateFormat('dd/MM/yyyy').format(DateTime.now()),
  );

  @override
  void dispose() {
    _autorController.dispose();
    _descricaoController.dispose();
    _tipoController.dispose();
    _nomeController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  void _saveMaterial() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(userProvider).value;
    if (currentUser == null) return;

    final novoMaterial = MaterialBibliotecaModel(
      nome: _nomeController.text,
      tipo: _tipoController.text,
      dataEnvio: _dateController.text,
      enviadoPor: currentUser.nome,
    );

    await ref.read(materialBibliotecaRepositoryProvider).add(novoMaterial);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conteúdo salvo com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiposAsync = ref.watch(gruposProvider);

    return Form(
      key: _formKey,
      child: Scaffold(
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
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(label: Text('Descrição')),
                controller: _descricaoController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(label: Text('Autor ')),
                controller: _autorController,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(12.0),
              child: TextFormField(
                readOnly: true,
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                onTap: () async {
                  await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2026),
                    lastDate: DateTime(2100),
                  ).then((selectedDate) {
                    if (selectedDate != null) {
                      _dateController.text = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDate);
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date.';
                  }
                  return null;
                },
              ),
            ),
            Expanded(
              child: tiposAsync.when(
                data: (tipos) => tipos.isEmpty
                    ? const MensagemEstado(
                        icon: Icons.category_outlined,
                        titulo: 'Nenhum tipo disponível',
                        subtitulo: 'Os tipos ainda não foram cadastrados.',
                      )
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: DropdownMenuFormField(
                          label: Text("Selecione um Tipo"),
                          controller: _tipoController,
                          dropdownMenuEntries: tipos
                              .map<DropdownMenuEntry<String>>((tema) {
                                return DropdownMenuEntry<String>(
                                  value: tema.nome,
                                  label: tema.nome,
                                );
                              })
                              .toList(),
                        ),
                      ),
                error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar os tipos.',
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),

            TextButton(onPressed: _saveMaterial, child: Text('data')),
          ],
        ),
      ),
    );
  }
}
