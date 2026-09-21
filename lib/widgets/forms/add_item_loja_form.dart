import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/attachment_picker.dart';

class AddItemLojaForm extends ConsumerStatefulWidget {
  final ItemLojaModel? item;

  const AddItemLojaForm({super.key, this.item});

  @override
  ConsumerState<AddItemLojaForm> createState() => _AddItemLojaFormState();
}

class _AddItemLojaFormState extends ConsumerState<AddItemLojaForm> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController = TextEditingController(
    text: widget.item?.nome ?? '',
  );
  late final _custoController = TextEditingController(
    text: widget.item?.custo.toString() ?? '',
  );

  late String _tipo = widget.item?.tipo ?? 'geral';
  late bool _status = widget.item?.status ?? true;

  PickedAttachment? _anexo;
  bool _anexoRemovido = false;
  bool _salvando = false;

  bool get _editando => widget.item != null;

  @override
  void dispose() {
    _nomeController.dispose();
    _custoController.dispose();
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
      final repo = ref.read(itemLojaRepositoryProvider);
      final uploadService = ref.read(storageUploadServiceProvider);
      final String id;

      final camposBase = {
        'nome': _nomeController.text.trim(),
        'custo': int.parse(_custoController.text.trim()),
        'tipo': _tipo,
        'status': _status,
      };

      if (_editando) {
        id = widget.item!.id!;
        await repo.update(id, {
          ...camposBase,
          if (_anexoRemovido && _anexo == null) 'assetUrl': '',
        });
      } else {
        id = await repo.add(
          ItemLojaModel(
            nome: _nomeController.text.trim(),
            custo: int.parse(_custoController.text.trim()),
            tipo: _tipo,
            status: _status,
            assetUrl: '',
          ),
        );
      }

      final anexo = _anexo;
      if (anexo != null) {
        final path = 'items/$id-${anexo.fileName}';
        await uploadService.upload(path: path, bytes: anexo.bytes);
        await repo.update(id, {'assetUrl': path});
      }

      if (!mounted) return;
      _mostrarSnackBar(
        _editando ? 'Item atualizado com sucesso!' : 'Item criado com sucesso!',
        context.colors.success,
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar('Erro ao salvar item.', context.colors.danger);
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
                ? 'Informe o nome do item'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _custoController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Custo (phatos)',
              prefixIcon: Icon(Icons.toll_outlined),
            ),
            validator: (value) {
              final custo = int.tryParse(value?.trim() ?? '');
              if (custo == null || custo < 0) {
                return 'Informe um custo válido';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _tipo,
            decoration: const InputDecoration(
              labelText: 'Tipo',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: const [
              DropdownMenuItem(value: 'geral', child: Text('Geral')),
              DropdownMenuItem(value: 'avatar', child: Text('Avatar')),
            ],
            onChanged: (value) => setState(() => _tipo = value ?? 'geral'),
          ),
          const SizedBox(height: AppSpacing.md),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Ativo na loja'),
            value: _status,
            onChanged: (value) => setState(() => _status = value),
          ),
          const SizedBox(height: AppSpacing.md),
          AttachmentPicker(
            tipo: TipoAnexo.imagem,
            label: 'Imagem (opcional)',
            assetUrlExistente: widget.item?.assetUrl,
            onChanged: (anexo) => setState(() {
              _anexo = anexo;
              _anexoRemovido = anexo == null;
            }),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _editando ? 'Atualizar item' : 'Salvar item',
            icon: Icons.save_outlined,
            loading: _salvando,
            onPressed: _salvando ? null : _salvar,
          ),
        ],
      ),
    );
  }
}
