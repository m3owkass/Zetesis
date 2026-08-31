import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/model/resposta.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

const int _minRespostas = 2;
const int _maxRespostas = 6;

class _RespostaDraft {
  _RespostaDraft({String texto = '', this.isCorrect = false})
    : controller = TextEditingController(text: texto);

  factory _RespostaDraft.fromModel(RespostaModel r) =>
      _RespostaDraft(texto: r.texto, isCorrect: r.isCorrect);

  final TextEditingController controller;
  bool isCorrect;

  void dispose() => controller.dispose();
}

class _PerguntaDraft {
  _PerguntaDraft({this.tipo = TipoPergunta.multipla})
    : enunciadoController = TextEditingController(),
      explicacaoController = TextEditingController(),
      respostas = _respostasIniciais(tipo);

  _PerguntaDraft.fromModel(PerguntaModel p)
    : tipo = p.tipo,
      enunciadoController = TextEditingController(text: p.enunciado),
      explicacaoController = TextEditingController(text: p.explicacao),
      respostas = p.respostas.map(_RespostaDraft.fromModel).toList();

  TipoPergunta tipo;
  final TextEditingController enunciadoController;
  final TextEditingController explicacaoController;
  List<_RespostaDraft> respostas;

  static List<_RespostaDraft> _respostasIniciais(TipoPergunta tipo) =>
      tipo == TipoPergunta.vf
      ? [_RespostaDraft(texto: 'Verdadeiro'), _RespostaDraft(texto: 'Falso')]
      : [_RespostaDraft(), _RespostaDraft()];

  void mudarTipo(TipoPergunta novo) {
    if (novo == tipo) return;
    for (final r in respostas) {
      r.dispose();
    }
    tipo = novo;
    respostas = _respostasIniciais(novo);
  }

  void dispose() {
    enunciadoController.dispose();
    explicacaoController.dispose();
    for (final r in respostas) {
      r.dispose();
    }
  }
}

class AddTaskForm extends ConsumerStatefulWidget {
  final TarefaModel? tarefa;

  const AddTaskForm({super.key, this.tarefa});

  @override
  ConsumerState<AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends ConsumerState<AddTaskForm> {
  final _formKey = GlobalKey<FormState>();

  late final _nomeController = TextEditingController(
    text: widget.tarefa?.nome ?? '',
  );
  late final _descricaoController = TextEditingController(
    text: widget.tarefa?.descricao ?? '',
  );
  late String? _temaSelecionado = widget.tarefa?.tema;

  late final List<_PerguntaDraft> _perguntas = widget.tarefa == null
      ? [_PerguntaDraft()]
      : widget.tarefa!.perguntas.map(_PerguntaDraft.fromModel).toList();

  bool _salvando = false;

  bool get _editando => widget.tarefa != null;

  String _hoje() {
    final agora = DateTime.now();
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(agora.day)}/${dois(agora.month)}/${agora.year}';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    for (final p in _perguntas) {
      p.dispose();
    }
    super.dispose();
  }

  void _mostrarSnackBar(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: cor),
    );
  }

  void _adicionarPergunta() {
    setState(() => _perguntas.add(_PerguntaDraft()));
  }

  void _removerPergunta(int index) {
    setState(() => _perguntas.removeAt(index).dispose());
  }

  void _adicionarResposta(_PerguntaDraft pergunta) {
    if (pergunta.respostas.length >= _maxRespostas) return;
    setState(() => pergunta.respostas.add(_RespostaDraft()));
  }

  void _removerResposta(_PerguntaDraft pergunta, int index) {
    if (pergunta.respostas.length <= _minRespostas) return;
    setState(() => pergunta.respostas.removeAt(index).dispose());
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final tema = _temaSelecionado;
    if (tema == null) {
      _mostrarSnackBar('Selecione um tema.', AppColors.danger);
      return;
    }

    for (var i = 0; i < _perguntas.length; i++) {
      final corretas = _perguntas[i].respostas.where((r) => r.isCorrect);
      if (corretas.length != 1) {
        _mostrarSnackBar(
          'Marque exatamente uma resposta correta na pergunta ${i + 1}.',
          AppColors.danger,
        );
        return;
      }
    }

    setState(() => _salvando = true);

    try {
      final currentUser = ref.read(userProvider).value;

      final tarefa = TarefaModel(
        id: widget.tarefa?.id,
        nome: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        tema: tema,
        enviadoPor: widget.tarefa?.enviadoPor ?? currentUser?.nome,
        dataEnvio: widget.tarefa?.dataEnvio ?? _hoje(),
        perguntas: _perguntas
            .map(
              (p) => PerguntaModel(
                enunciado: p.enunciadoController.text.trim(),
                explicacao: p.explicacaoController.text.trim(),
                tipo: p.tipo,
                respostas: p.respostas
                    .map(
                      (r) => RespostaModel(
                        texto: r.controller.text.trim(),
                        isCorrect: r.isCorrect,
                      ),
                    )
                    .toList(),
              ),
            )
            .toList(),
      );

      final repo = ref.read(tarefaRepositoryProvider);
      if (_editando) {
        await repo.update(widget.tarefa!.id!, tarefa.toMap());
      } else {
        await repo.add(tarefa);
      }

      if (!mounted) return;
      _mostrarSnackBar(
        _editando ? 'Tarefa atualizada com sucesso!' : 'Tarefa salva com sucesso!',
        AppColors.success,
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      _mostrarSnackBar('Erro ao salvar tarefa.', AppColors.danger);
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final temasAsync = ref.watch(temasProvider);

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
                ? 'Informe o nome da tarefa'
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
          temasAsync.when(
            data: (temas) => temas.isEmpty
                ? const MensagemEstado(
                    icon: Icons.category_outlined,
                    titulo: 'Nenhum tema disponível',
                    subtitulo: 'Os temas ainda não foram cadastrados.',
                  )
                : DropdownButtonFormField<String>(
                    initialValue: _temaSelecionado,
                    decoration: const InputDecoration(
                      labelText: 'Tema',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: temas
                        .map(
                          (tema) => DropdownMenuItem(
                            value: tema.nome,
                            child: Text(tema.nome),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _temaSelecionado = value),
                    validator: (value) =>
                        value == null ? 'Selecione um tema' : null,
                  ),
            error: (err, _) => const MensagemEstado.erro(
              subtitulo: 'Não foi possível carregar os temas.',
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Perguntas', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          for (var i = 0; i < _perguntas.length; i++) _buildPerguntaCard(i),
          TextButton.icon(
            onPressed: _adicionarPergunta,
            icon: const Icon(Icons.add),
            label: const Text('Adicionar pergunta'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            label: _editando ? 'Atualizar tarefa' : 'Salvar tarefa',
            icon: Icons.save_outlined,
            loading: _salvando,
            onPressed: _salvando ? null : _salvar,
          ),
        ],
      ),
    );
  }

  Widget _buildPerguntaCard(int index) {
    final pergunta = _perguntas[index];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pergunta ${index + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              IconButton(
                onPressed: _perguntas.length > 1
                    ? () => _removerPergunta(index)
                    : null,
                icon: const Icon(Icons.delete_outline),
                color: AppColors.danger,
              ),
            ],
          ),
          DropdownButtonFormField<TipoPergunta>(
            initialValue: pergunta.tipo,
            decoration: const InputDecoration(labelText: 'Tipo de pergunta'),
            items: TipoPergunta.values
                .map(
                  (tipo) => DropdownMenuItem(
                    value: tipo,
                    child: Text(switch (tipo) {
                      TipoPergunta.multipla => 'Múltipla escolha',
                      TipoPergunta.vf => 'Verdadeiro ou Falso',
                      TipoPergunta.lacuna => 'Complete a frase',
                    }),
                  ),
                )
                .toList(),
            onChanged: (novo) {
              if (novo != null) setState(() => pergunta.mudarTipo(novo));
            },
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: pergunta.enunciadoController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Enunciado',
              alignLabelWithHint: true,
              helperText: pergunta.tipo == TipoPergunta.lacuna
                  ? 'Use ___ para indicar a lacuna'
                  : null,
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Informe o enunciado'
                : null,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: pergunta.explicacaoController,
            textCapitalization: TextCapitalization.sentences,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Explicação (opcional)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildRespostas(pergunta),
        ],
      ),
    );
  }

  Widget _buildRespostas(_PerguntaDraft pergunta) {
    final correta = pergunta.respostas.indexWhere((r) => r.isCorrect);
    final travada = pergunta.tipo == TipoPergunta.vf;

    return RadioGroup<int>(
      groupValue: correta == -1 ? null : correta,
      onChanged: (value) => setState(() {
        for (final r in pergunta.respostas) {
          r.isCorrect = false;
        }
        if (value != null) pergunta.respostas[value].isCorrect = true;
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < pergunta.respostas.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Radio<int>(value: i),
                  Expanded(
                    child: TextFormField(
                      controller: pergunta.respostas[i].controller,
                      readOnly: travada,
                      decoration: InputDecoration(
                        labelText: pergunta.tipo == TipoPergunta.lacuna
                            ? 'Opção ${i + 1}'
                            : 'Alternativa ${i + 1}',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty)
                          ? 'Informe o texto'
                          : null,
                    ),
                  ),
                  if (!travada)
                    IconButton(
                      onPressed: pergunta.respostas.length > _minRespostas
                          ? () => _removerResposta(pergunta, i)
                          : null,
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),
          if (!travada && pergunta.respostas.length < _maxRespostas)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => _adicionarResposta(pergunta),
                icon: const Icon(Icons.add),
                label: Text(
                  pergunta.tipo == TipoPergunta.lacuna
                      ? 'Adicionar opção'
                      : 'Adicionar alternativa',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
