import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/dev/seed_screen.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/admin/lista_conteudos_screen.dart';
import 'package:zetesis/views/admin/lista_tarefas_screen.dart';
import 'package:zetesis/views/admin/lista_usuarios_screen.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/card_estatistica.dart';
import 'package:zetesis/widgets/admin/card_secao.dart';
import 'package:zetesis/widgets/admin/tasks_cadastro_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefas = ref.watch(todasTarefasProvider).valueOrNull?.length;
    final conteudos = ref.watch(todosMateriaisProvider).valueOrNull?.length;
    final usuarios = ref.watch(totalUsuariosProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Painel administrativo')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              Expanded(
                child: CardEstatistica(
                  icon: Icons.assignment_outlined,
                  cor: AppColors.accent,
                  valor: tarefas,
                  label: 'Tarefas',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: CardEstatistica(
                  icon: Icons.menu_book_outlined,
                  cor: AppColors.primaryLight,
                  valor: conteudos,
                  label: 'Conteúdos',
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: CardEstatistica(
                  icon: Icons.people_outline,
                  cor: AppColors.primary,
                  valor: usuarios,
                  label: 'Usuários',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CardSecao(
            icon: Icons.assignment_outlined,
            cor: AppColors.accent,
            titulo: 'Tarefas',
            descricao: 'Revise envios e crie novas atividades.',
            acoes: [
              AcaoSecao(
                label: 'Ver enviadas',
                variant: AppButtonVariant.neutral,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ListaTarefasScreen()),
                ),
              ),
              AcaoSecao(
                label: 'Nova tarefa',
                variant: AppButtonVariant.accent,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TasksDialog()),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CardSecao(
            icon: Icons.menu_book_outlined,
            cor: AppColors.primaryLight,
            titulo: 'Conteúdos',
            descricao: 'Gerencie materiais e publicações.',
            acoes: [
              AcaoSecao(
                label: 'Ver conteúdos',
                variant: AppButtonVariant.neutral,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaConteudosScreen(),
                  ),
                ),
              ),
              AcaoSecao(
                label: 'Novo conteúdo',
                variant: AppButtonVariant.primary,
                onPressed: () => null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CardSecao(
            icon: Icons.people_outline,
            cor: AppColors.primary,
            titulo: 'Usuários',
            descricao: 'Consulte dados e acompanhe cadastros.',
            acoes: [
              AcaoSecao(
                label: 'Ver usuários',
                variant: AppButtonVariant.neutral,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ListaUsuariosScreen(),
                  ),
                ),
              ),
            ],
          ),
          if (kDebugMode) ...[
            const SizedBox(height: AppSpacing.md),
            CardSecao(
              icon: Icons.build_outlined,
              cor: AppColors.dangerDark,
              titulo: 'Seed de dados',
              descricao: 'Popular e limpar coleções do Firestore (só debug).',
              acoes: [
                AcaoSecao(
                  label: 'Abrir ferramentas',
                  variant: AppButtonVariant.danger,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SeedScreen()),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
