import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/admin/item_lista_admin.dart';
import 'package:zetesis/widgets/admin/update_tema_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/confirmar_acao.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class ListaTemasScreen extends ConsumerStatefulWidget {
  const ListaTemasScreen({super.key});
@override
  ConsumerState<ListaTemasScreen> createState() =>
      _ListaTemasScreenState();

}
class _ListaTemasScreenState extends ConsumerState<ListaTemasScreen> {


  void _exibirDetalhes(
    BuildContext context,
    WidgetRef ref,
    TemaModel tema,
    
  ) {
    
    DetalhesDialog.mostrar(
      
      context,
      icon: Icons.assignment_outlined,
      cor: AppColors.accent,
      titulo: tema.nome,
      linhas: [
        DetalheLinha('Descrição', tema.descricao),
      ],
      acoes: [
        AcaoSecao(
          label: 'Editar',
          variant: AppButtonVariant.primary,
          onPressed: () {
            ref.read(temaSelecionadoAtualizarProvider.notifier).state = tema.nome;
            Navigator.push(context, MaterialPageRoute(builder: (_)=> const UpdateTemaDialog()));
          
          },
        ),
        AcaoSecao(
          label: 'Excluir',
          variant: AppButtonVariant.danger,
          onPressed: () => _excluir(context, ref, tema),
        ),
      ],
    );
  }


  Future<void> _excluir(
    BuildContext context,
    WidgetRef ref,
    TemaModel tema,
  ) async {
    final confirmado = await confirmarAcao(
      context,
      titulo: 'Excluir tema?',
      mensagem:
          'Tem certeza que deseja excluir "${tema.nome}"? '
          'Essa ação não pode ser desfeita.',
      confirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || tema.id == null) return;
    if (!context.mounted) return;
    Navigator.pop(context);
    await ref.read(temaRepositoryProvider).remove(tema.id!);
  }

  @override
  Widget build(BuildContext context) {
    final temasAsync = ref.watch(todosTemasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Temas')),
      body: temasAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os temas.',
        ),
        data: (temas) {
          if (temas.isEmpty) {
            return const MensagemEstado(
              icon: Icons.assignment_outlined,
              titulo: 'Nenhum tema cadastrada',
              subtitulo: 'Crie um novo tema para vê-lo aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: temas.length,
            itemBuilder: (context, index) {
              final tema = temas[index];
              

              return ItemListaAdmin(
                icon: Icons.assignment_outlined,
                cor: AppColors.accent,
                titulo: tema.nome,
                subtitulo: tema.descricao,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () { 
                  _exibirDetalhes(context, ref, tema);}
              );
            },
          );
        },
      ),
    );
  }
}
