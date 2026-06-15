import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/admin/item_lista_admin.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/confirmar_acao.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class ListaConteudosScreen extends ConsumerWidget {
  const ListaConteudosScreen({super.key});

  void _exibirDetalhes(
    BuildContext context,
    WidgetRef ref,
    MaterialBibliotecaModel material,
  ) {
    DetalhesDialog.mostrar(
      context,
      icon: Icons.menu_book_outlined,
      cor: AppColors.primaryLight,
      titulo: material.nome,
      linhas: [
        DetalheLinha('Tipo', material.tipo),
        DetalheLinha('Descrição', material.descricao),
        DetalheLinha('Autor', material.autor),
        DetalheLinha('Enviado por', material.enviadoPor),
        DetalheLinha('Data de envio', material.dataEnvio),
      ],
      acoes: [
        AcaoSecao(
          label: 'Editar',
          variant: AppButtonVariant.primary,
          onPressed: () {
            Navigator.pop(context);
            // todo: abrir o form de edicao do conteudo
          },
        ),
        AcaoSecao(
          label: 'Excluir',
          variant: AppButtonVariant.danger,
          onPressed: () => _excluir(context, ref, material),
        ),
      ],
    );
  }

  Future<void> _excluir(
    BuildContext context,
    WidgetRef ref,
    MaterialBibliotecaModel material,
  ) async {
    final confirmado = await confirmarAcao(
      context,
      titulo: 'Excluir conteúdo?',
      mensagem:
          'Tem certeza que deseja excluir "${material.nome}"? '
          'Essa ação não pode ser desfeita.',
      confirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || material.id == null) return;
    if (!context.mounted) return;
    Navigator.pop(context); // fecha o dialog de detalhes
    await ref.read(materialBibliotecaRepositoryProvider).remove(material.id!);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conteudosAsync = ref.watch(todosMateriaisProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Conteúdos')),
      body: conteudosAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os conteúdos.',
        ),
        data: (conteudos) {
          if (conteudos.isEmpty) {
            return const MensagemEstado(
              icon: Icons.menu_book_outlined,
              titulo: 'Nenhum conteúdo cadastrado',
              subtitulo: 'Crie um novo conteúdo para vê-lo aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: conteudos.length,
            itemBuilder: (context, index) {
              final material = conteudos[index];
              final detalhes = [
                material.tipo,
                if (material.autor != null && material.autor!.isNotEmpty)
                  material.autor,
                if (material.enviadoPor != null &&
                    material.enviadoPor!.isNotEmpty)
                  material.enviadoPor,
              ].join(' • ');

              return ItemListaAdmin(
                icon: Icons.menu_book_outlined,
                trailing: Icon(Icons.arrow_forward_ios),
                cor: AppColors.primaryLight,
                titulo: material.nome,
                subtitulo: detalhes.isNotEmpty ? detalhes : null,
                onTap: () => _exibirDetalhes(context, ref, material),
              );
            },
          );
        },
      ),
    );
  }
}
