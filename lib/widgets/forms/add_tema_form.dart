import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/attachment_picker.dart';

class AddTemaForm extends ConsumerStatefulWidget {
  final TemaModel? tema;

  const AddTemaForm({super.key, this.tema});

  @override
  ConsumerState<AddTemaForm> createState() => _AddTemaFormState();
}

class _AddTemaFormState extends ConsumerState<AddTemaForm> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController = TextEditingController(
    text: widget.tema?.nome ?? '',
  );
  late final _descricaoController = TextEditingController(
    text: widget.tema?.descricao ?? '',
  );

  PickedAttachment? _anexo;
  bool _anexoRemovido = false;
  bool _salvando = false;

  bool get _editando => widget.tema != null;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _salvando = true);

    try {
      final repo = ref.read(temaRepositoryProvider);
      final uploadService = ref.read(storageUploadServiceProvider);
      final String id;

      final camposBase = {
        'nome': _nomeController.text.trim(),
        'descricao': _descricaoController.text.trim(),
      };

      if (_editando) {
        id = widget.tema!.id!;
        await repo.update(id, {
          ...camposBase,
          if (_anexoRemovido && _anexo == null) 'assetUrl': '',
        });
      } else {
        id = await repo.add(
          TemaModel(
            nome: _nomeController.text.trim(),
            descricao: _descricaoController.text.trim(),
            assetUrl: '',
          ),
        );
      }

      final anexo = _anexo;
      if (anexo != null) {
        final path = 'temas/$id-${anexo.fileName}';
        await uploadService.upload(path: path, bytes: anexo.bytes);
        await repo.update(id, {'assetUrl': path});
      }

      if (!mounted) return;
      _mostrarSnackBar(
        _editando ? 'Tema atualizado com sucesso!' : 'Tema criado com sucesso!',
        AppColors.success,
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar('Erro ao salvar tema.', AppColors.danger);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextFormField(
            controller: _nomeController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Nome',
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe o nome do tema'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _descricaoController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AttachmentPicker(
            tipo: TipoAnexo.imagem,
            label: 'Imagem (opcional)',
            assetUrlExistente: widget.tema?.assetUrl,
            onChanged: (anexo) => setState(() {
              _anexo = anexo;
              _anexoRemovido = anexo == null;
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _editando ? 'Atualizar tema' : 'Salvar tema',
            icon: Icons.save_outlined,
            loading: _salvando,
            onPressed: _salvando ? null : _salvar,
          ),
        ],
      ),
    );
  }
}
