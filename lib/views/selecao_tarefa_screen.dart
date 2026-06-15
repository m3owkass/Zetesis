import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/tarefa_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/item_tarefa.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class SelecaotarefaScreen extends ConsumerStatefulWidget {
  const SelecaotarefaScreen({super.key});

  @override
  ConsumerState<SelecaotarefaScreen> createState() =>
      _SelecaotarefaScreenState();
}

class _SelecaotarefaScreenState extends ConsumerState<SelecaotarefaScreen> {
  TarefaModel? _selected;

  void _confirm() {
    final tarefa = _selected;
    if (tarefa == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TarefaScreen(tarefa: tarefa)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefaAsync = ref.watch(tarefasProvider);
    final user = ref.watch(userProvider).valueOrNull;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Escolha sua tarefa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: tarefaAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar as tarefas.',
                ),
                data: (tarefas) => tarefas.isEmpty
                    ? const MensagemEstado(
                        icon: Icons.assignment_outlined,
                        titulo: 'Nenhuma tarefa neste tema',
                        subtitulo: 'Escolha outro tema ou volte mais tarde.',
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.md,
                              mainAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: tarefas.length,
                        itemBuilder: (context, index) {
                          final tarefa = tarefas[index];
                          return ItemTarefa(
                            tarefa: tarefa,
                            isSelected: _selected?.nome == tarefa.nome,
                            concluida:
                                user?.concluiu(tarefa.id ?? tarefa.nome) ??
                                false,
                            onSelect: (t) => setState(() => _selected = t),
                          );
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: 'Começar',
                variant: AppButtonVariant.success,
                onPressed: _selected != null ? _confirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
