import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/quiz/enunciado_pergunta.dart';
import 'package:zetesis/widgets/quiz/opcoes_pergunta.dart';
import 'package:zetesis/widgets/quiz/painel_feedback.dart';
import 'package:zetesis/widgets/quiz/quiz_top_bar.dart';
import 'package:zetesis/widgets/quiz/resultado_tarefa.dart';

class TarefaScreen extends ConsumerStatefulWidget {
  final TarefaModel tarefa;

  const TarefaScreen({super.key, required this.tarefa});

  @override
  ConsumerState<TarefaScreen> createState() => _TarefaScreenState();
}

class _TarefaScreenState extends ConsumerState<TarefaScreen> {
  static const int _pontosPorAcerto = 10;
  static const int _bonusSequencia = 5;
  static const int _sequenciaParaBonus = 3;

  int _perguntaIndex = 0;
  int? _selectedIndex;
  bool _checked = false;
  int _acertos = 0;
  int _pontosGanhos = 0;
  int _sequencia = 0;
  int _melhorSequencia = 0;
  int _ultimoGanho = 0;
  bool _finished = false;
  bool _salvo = false;

  TarefaModel get _tarefa => widget.tarefa;
  int get _total => _tarefa.perguntas.length;
  PerguntaModel get _pergunta => _tarefa.perguntas[_perguntaIndex];
  bool get _comboAtivo => _sequencia >= _sequenciaParaBonus;
  String get _tarefaId => _tarefa.id ?? _tarefa.nome;

  bool get _temProgresso =>
      !_finished && (_perguntaIndex > 0 || _selectedIndex != null || _checked);

  bool get _modoPratica =>
      ref.read(userProvider).valueOrNull?.concluiu(_tarefaId) ?? false;

  bool get _acertou {
    final i = _selectedIndex;
    return i != null && _pergunta.respostas[i].isCorrect;
  }

  void _verificar() {
    if (_checked || _selectedIndex == null) return;
    setState(() {
      _checked = true;
      if (_acertou) {
        _acertos++;
        _sequencia++;
        if (_sequencia > _melhorSequencia) _melhorSequencia = _sequencia;
        _ultimoGanho = _pontosPorAcerto + (_comboAtivo ? _bonusSequencia : 0);
        _pontosGanhos += _ultimoGanho;
      } else {
        _sequencia = 0;
        _ultimoGanho = 0;
      }
    });
  }

  void _continuar() {
    if (_perguntaIndex + 1 >= _total) {
      _salvarConclusao();
      setState(() => _finished = true);
    } else {
      setState(() {
        _perguntaIndex++;
        _selectedIndex = null;
        _checked = false;
      });
    }
  }

  void _salvarConclusao() {
    if (_salvo || _modoPratica) return;
    _salvo = true;

    final uid = ref.read(authServiceProvider).currentUser?.uid;
    if (uid == null) return;
    ref
        .read(usuarioRepositoryProvider)
        .concluirTarefa(uid, tarefaId: _tarefaId, pontos: _pontosGanhos);
  }

  TarefaModel? _proximaTarefa() {
    final tarefas = ref.read(tarefasProvider).valueOrNull ?? [];
    final concluidas =
        ref.read(userProvider).valueOrNull?.tarefasConcluidas.toSet() ?? {};
    for (final t in tarefas) {
      final id = t.id ?? t.nome;
      if (id != _tarefaId && !concluidas.contains(id)) return t;
    }
    return null;
  }

  void _irParaProxima(TarefaModel proxima) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => TarefaScreen(tarefa: proxima)),
    );
  }

  Future<bool> _confirmarSaida() async {
    if (!_temProgresso) return true;
    final sair = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair da tarefa?'),
        content: const Text(
          'Você perderá o progresso desta tarefa. Deseja sair mesmo assim?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Continuar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    return sair ?? false;
  }

  Future<void> _tentarSair() async {
    final sair = await _confirmarSaida();
    if (!mounted) return;
    if (sair) Navigator.pop(context);
  }

  String _rotuloTipo(TipoPergunta tipo) => switch (tipo) {
    TipoPergunta.vf => 'Verdadeiro ou falso?',
    TipoPergunta.lacuna => 'Complete a frase',
    TipoPergunta.multipla => 'Múltipla escolha',
  };

  @override
  Widget build(BuildContext context) {
    if (_tarefa.perguntas.isEmpty) return _semPerguntas();
    if (_finished) {
      final proxima = _proximaTarefa();
      return ResultadoTarefa(
        acertos: _acertos,
        total: _total,
        pontosGanhos: _pontosGanhos,
        melhorSequencia: _melhorSequencia,
        pratica: _modoPratica,
        onConcluir: () => Navigator.pop(context),
        onProxima: proxima == null ? null : () => _irParaProxima(proxima),
      );
    }

    final progresso = (_perguntaIndex + (_checked ? 1 : 0)) / _total;

    return PopScope(
      canPop: !_temProgresso,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final sair = await _confirmarSaida();
        if (!context.mounted) return;
        if (sair) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        body: SafeArea(
          child: Column(
            children: [
              QuizTopBar(
                progresso: progresso,
                pontos: _pontosGanhos,
                onClose: _tentarSair,
              ),
              if (_modoPratica) _avisoPratica(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  children: [
                    Text(
                      'Pergunta ${_perguntaIndex + 1} de $_total'
                      ' • ${_rotuloTipo(_pergunta.tipo)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.1,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    EnunciadoPergunta(
                      pergunta: _pergunta,
                      selectedIndex: _selectedIndex,
                    ),
                    const SizedBox(height: 24),
                    OpcoesPergunta(
                      pergunta: _pergunta,
                      selectedIndex: _selectedIndex,
                      checked: _checked,
                      onSelect: (i) => setState(() => _selectedIndex = i),
                    ),
                  ],
                ),
              ),
              _checked
                  ? PainelFeedback(
                      acertou: _acertou,
                      comboAtivo: _comboAtivo,
                      sequencia: _sequencia,
                      ultimoGanho: _ultimoGanho,
                      explicacao: _pergunta.explicacao,
                      ultima: _perguntaIndex + 1 >= _total,
                      onContinuar: _continuar,
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: AppButton(
                        label: 'Verificar',
                        onPressed: _selectedIndex != null ? _verificar : null,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _semPerguntas() {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Esta tarefa ainda não tem perguntas',
              style: TextStyle(fontSize: 20, color: AppColors.primaryDark),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avisoPratica() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.replay, size: 16, color: AppColors.primary),
          SizedBox(width: 6),
          Text(
            'Modo prática — esta tarefa já foi pontuada',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
