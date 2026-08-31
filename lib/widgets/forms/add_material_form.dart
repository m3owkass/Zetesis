import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/grupo_biblioteca.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/attachment_picker.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class AddMaterialForm extends ConsumerStatefulWidget {
  final MaterialBibliotecaModel? material;

  const AddMaterialForm({super.key, this.material});

  @override
  ConsumerState<AddMaterialForm> createState() => _AddMaterialFormState();
}

class _AddMaterialFormState extends ConsumerState<AddMaterialForm> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController = TextEditingController(
    text: widget.material?.nome ?? '',
  );
  late final _autorController = TextEditingController(
    text: widget.material?.autor ?? '',
  );
  late final _descricaoController = TextEditingController(
    text: widget.material?.descricao ?? '',
  );
  late final _dateController = TextEditingController(
    text: widget.material?.dataEnvio ?? _hoje(),
  );
  late final _linkController = TextEditingController(
    text: widget.material?.assetUrl ?? '',
  );
  late final _conteudoTextoController = TextEditingController(
    text: widget.material?.conteudoTexto ?? '',
  );

  late DateTime _dataSelecionada =
      _parseData(widget.material?.dataEnvio) ?? DateTime.now();
  late String? _tipoSelecionado = widget.material?.tipo;

  PickedAttachment? _anexo;
  bool _anexoRemovido = false;
  bool _salvando = false;

  bool get _editando => widget.material != null;

  FormatoConteudo? _formatoDoTipo(List<GrupoBibliotecaModel> tipos) {
    for (final grupo in tipos) {
      if (grupo.nome == _tipoSelecionado) return grupo.formatoConteudo;
    }
    return null;
  }

  String _hoje() => _formatarData(DateTime.now());

  String _formatarData(DateTime data) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)}/${data.year}';
  }

  DateTime? _parseData(String? data) {
    if (data == null) return null;
    final partes = data.split('/');
    if (partes.length != 3) return null;
    final dia = int.tryParse(partes[0]);
    final mes = int.tryParse(partes[1]);
    final ano = int.tryParse(partes[2]);
    if (dia == null || mes == null || ano == null) return null;
    return DateTime(ano, mes, dia);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _autorController.dispose();
    _descricaoController.dispose();
    _dateController.dispose();
    _linkController.dispose();
    _conteudoTextoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final selecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (selecionada != null) {
      setState(() {
        _dataSelecionada = selecionada;
        _dateController.text = _formatarData(selecionada);
      });
    }
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final tipo = _tipoSelecionado;
    if (tipo == null) {
      _mostrarSnackBar('Selecione um tipo.', AppColors.danger);
      return;
    }

    final currentUser = ref.read(userProvider).value;
    if (!_editando && currentUser == null) {
      _mostrarSnackBar(
        'Não foi possível identificar o usuário atual.',
        AppColors.danger,
      );
      return;
    }

    final tipos = ref.read(gruposProvider).valueOrNull ?? [];
    final formato = _formatoDoTipo(tipos) ?? FormatoConteudo.arquivo;

    setState(() => _salvando = true);

    try {
      final repo = ref.read(materialBibliotecaRepositoryProvider);
      final uploadService = ref.read(storageUploadServiceProvider);
      final String id;

      final camposBase = {
        'nome': _nomeController.text.trim(),
        'tipo': tipo,
        'descricao': _descricaoController.text.trim(),
        'autor': _autorController.text.trim(),
        'dataEnvio': _dateController.text,
        'conteudoTexto': formato == FormatoConteudo.texto
            ? _conteudoTextoController.text.trim()
            : null,
        if (formato == FormatoConteudo.link)
          'assetUrl': _linkController.text.trim(),
      };

      if (_editando) {
        id = widget.material!.id!;
        await repo.update(id, {
          ...camposBase,
          if (formato == FormatoConteudo.arquivo &&
              _anexoRemovido &&
              _anexo == null)
            'assetUrl': null,
        });
      } else {
        id = await repo.add(
          MaterialBibliotecaModel(
            nome: _nomeController.text.trim(),
            tipo: tipo,
            descricao: _descricaoController.text.trim(),
            autor: _autorController.text.trim(),
            dataEnvio: _dateController.text,
            enviadoPor: currentUser?.nome,
            conteudoTexto: formato == FormatoConteudo.texto
                ? _conteudoTextoController.text.trim()
                : null,
            assetUrl: formato == FormatoConteudo.link
                ? _linkController.text.trim()
                : null,
          ),
        );
      }

      final anexo = _anexo;
      if (formato == FormatoConteudo.arquivo && anexo != null) {
        final path = 'materiais/$id-${anexo.fileName}';
        await uploadService.upload(path: path, bytes: anexo.bytes);
        await repo.update(id, {'assetUrl': path});
      }

      if (!mounted) return;
      _mostrarSnackBar(
        _editando ? 'Material atualizado com sucesso!' : 'Material salvo com sucesso!',
        AppColors.success,
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar('Erro ao salvar material.', AppColors.danger);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tiposAsync = ref.watch(gruposProvider);

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
                ? 'Informe o nome do material'
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
          TextFormField(
            controller: _autorController,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Autor',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            readOnly: true,
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Data de envio',
              prefixIcon: Icon(Icons.calendar_today_outlined),
            ),
            onTap: _selecionarData,
            validator: (value) => (value == null || value.isEmpty)
                ? 'Selecione uma data'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          tiposAsync.when(
            data: (tipos) {
              if (tipos.isEmpty) {
                return const MensagemEstado(
                  icon: Icons.category_outlined,
                  titulo: 'Nenhum tipo disponível',
                  subtitulo: 'Os tipos ainda não foram cadastrados.',
                );
              }

              final formato = _formatoDoTipo(tipos);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _tipoSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: tipos
                        .map(
                          (grupo) => DropdownMenuItem(
                            value: grupo.nome,
                            child: Text(grupo.nome),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _tipoSelecionado = value),
                    validator: (value) =>
                        value == null ? 'Selecione um tipo' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (formato == FormatoConteudo.link) ...[
                    TextFormField(
                      controller: _linkController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Link',
                        hintText: 'https://...',
                        prefixIcon: Icon(Icons.link),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o link';
                        }
                        final uri = Uri.tryParse(value.trim());
                        final valido =
                            uri != null &&
                            (uri.scheme == 'http' || uri.scheme == 'https');
                        return valido
                            ? null
                            : 'Informe uma URL válida (http/https)';
                      },
                    ),
                  ] else if (formato == FormatoConteudo.texto) ...[
                    TextFormField(
                      controller: _conteudoTextoController,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        labelText: 'Conteúdo do texto',
                        alignLabelWithHint: true,
                        prefixIcon: Icon(Icons.notes_outlined),
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Informe o conteúdo do texto'
                          : null,
                    ),
                  ] else
                    AttachmentPicker(
                      key: ValueKey(_tipoSelecionado),
                      tipo: TipoAnexo.qualquer,
                      label: 'Anexo',
                      assetUrlExistente: widget.material?.assetUrl,
                      onChanged: (anexo) => setState(() {
                        _anexo = anexo;
                        _anexoRemovido = anexo == null;
                      }),
                    ),
                ],
              );
            },
            error: (err, _) => const MensagemEstado.erro(
              subtitulo: 'Não foi possível carregar os tipos.',
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: _editando ? 'Atualizar material' : 'Salvar material',
            icon: Icons.save_outlined,
            loading: _salvando,
            onPressed: _salvando ? null : _salvar,
          ),
        ],
      ),
    );
  }
}
