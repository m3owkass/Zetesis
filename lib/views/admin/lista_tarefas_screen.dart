import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/admin/item_lista_admin.dart';
import 'package:zetesis/widgets/admin/pergunta_expansivel.dart';
import 'package:zetesis/widgets/admin/tasks_cadastro_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/confirmar_acao.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class ListaTarefasScreen extends ConsumerWidget {
  const ListaTarefasScreen({super.key});

  void _exibirDetalhes(
    BuildContext context,
    WidgetRef ref,
    TarefaModel tarefa,
  ) {
    DetalhesDialog.mostrar(
      context,
      icon: Icons.assignment_outlined,
      cor: AppColors.accent,
      titulo: tarefa.nome,
      linhas: [
        DetalheLinha('Tema', tarefa.tema),
        DetalheLinha('Descrição', tarefa.descricao),
        DetalheLinha('Enviado por', tarefa.enviadoPor),
        DetalheLinha('Data de envio', tarefa.dataEnvio),
      ],
      conteudoExtra: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Perguntas (${tarefa.perguntas.length})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          for (final (i, pergunta) in tarefa.perguntas.indexed)
            PerguntaExpansivel(numero: i + 1, pergunta: pergunta),
        ],
      ),
      acoes: [
        AcaoSecao(
          label: 'Editar',
          variant: AppButtonVariant.primary,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TasksDialog(tarefa: tarefa)),
            );
          },
        ),
        AcaoSecao(
          label: 'Excluir',
          variant: AppButtonVariant.danger,
          onPressed: () => _excluir(context, ref, tarefa),
        ),
      ],
    );
  }

  Future<void> _excluir(
    BuildContext context,
    WidgetRef ref,
    TarefaModel tarefa,
  ) async {
    final confirmado = await confirmarAcao(
      context,
      titulo: 'Excluir tarefa?',
      mensagem:
          'Tem certeza que deseja excluir "${tarefa.nome}"? '
          'Essa ação não pode ser desfeita.',
      confirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || tarefa.id == null) return;
    if (!context.mounted) return;
    Navigator.pop(context);
    await ref.read(tarefaRepositoryProvider).remove(tarefa.id!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefasAsync = ref.watch(todasTarefasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarefas')),
      body: tarefasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar as tarefas.',
        ),
        data: (tarefas) {
          if (tarefas.isEmpty) {
            return const MensagemEstado(
              icon: Icons.assignment_outlined,
              titulo: 'Nenhuma tarefa cadastrada',
              subtitulo: 'Crie uma nova tarefa para vê-la aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: tarefas.length,
            itemBuilder: (context, index) {
              final tarefa = tarefas[index];
              final detalhes = [
                tarefa.tema,
                '${tarefa.perguntas.length} perguntas',
              ].join(' • ');

              return ItemListaAdmin(
                icon: Icons.assignment_outlined,
                cor: AppColors.accent,
                titulo: tarefa.nome,
                subtitulo: detalhes,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _exibirDetalhes(context, ref, tarefa),
              );
            },
          );
        },
      ),
    );
  }
}
