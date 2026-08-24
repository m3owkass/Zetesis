import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';


class AddTemaForm extends ConsumerStatefulWidget {
  const AddTemaForm({super.key});

  @override
  ConsumerState<AddTemaForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends ConsumerState<AddTemaForm> {
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

  void _saveTema() async{
    if(!_formKey.currentState!.validate()) return;
    final currentUser = ref.read(userProvider).value;
    if(currentUser == null) return;

    final novoTema = TemaModel(nome: _nomeController.text, descricao: _descricaoController.text, assetUrl: _assetController.text);
    await ref.read(temaRepositoryProvider).add(novoTema);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Form(
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
                decoration:  InputDecoration(label: Text("Descricao")),
                controller: _descricaoController,
              )
            ),

          
            TextButton(onPressed:(){
              _saveTema();
              Navigator.pop(context);
            } , child: Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text("Cadastrar", style: TextStyle(color: AppColors.textPrimary),),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
