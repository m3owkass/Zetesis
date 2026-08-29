import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class UpdateTemaForm extends ConsumerStatefulWidget {

  const UpdateTemaForm({super.key,});
  
  @override
  ConsumerState<UpdateTemaForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<UpdateTemaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _assetController = TextEditingController();

  @override
  void dispose() {
    _descricaoController.dispose();
    _nomeController.dispose();
    _assetController.dispose();
    super.dispose();
  }

  void _updateTema(String? id) async {
    if (!_formKey.currentState!.validate()) return;
    final currentUser = ref.read(userProvider).value;
    if (currentUser == null) return;
    TemaModel updatedTema = TemaModel(
      nome: _nomeController.text,
      descricao: _descricaoController.text,
      assetUrl: _assetController.text,
    );
    if(id == null){
      MensagemEstado.erro(subtitulo: "Não foi possivel encontrar o tema selecionado");
      return;
    }

    await ref.read(temaRepositoryProvider).update(id, updatedTema.toMap());
  }

  @override
  Widget build(BuildContext context) {
    final temaAtualizar = ref.watch(temaAtualizarProvider);

    return Scaffold(
      body: temaAtualizar.when(
        data: (tema) {
          _nomeController.text = tema!.nome;
          _descricaoController.text = tema!.descricao;
          return Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text('Nome')),
                    controller: _nomeController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextFormField(
                    decoration: InputDecoration(label: Text("Descricao")),
                    controller: _descricaoController,
                  ),
                ),

                TextButton(
                  onPressed: () {
                    
                    _updateTema(tema?.id);
                    Navigator.pop(context);
                    
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Atualizar",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os temas.',
        ),
      ),
    );
  }
}
