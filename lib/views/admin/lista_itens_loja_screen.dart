import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/admin/item_lista_admin.dart';
import 'package:zetesis/widgets/admin/item_loja_cadastro_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/confirmar_acao.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class ListaItensLojaScreen extends ConsumerStatefulWidget {
  const ListaItensLojaScreen({super.key});

  @override
  ConsumerState<ListaItensLojaScreen> createState() =>
      _ListaItensLojaScreenState();
}

class _ListaItensLojaScreenState extends ConsumerState<ListaItensLojaScreen> {
  void _exibirDetalhes(BuildContext context, WidgetRef ref, ItemLojaModel item) {
    DetalhesDialog.mostrar(
      context,
      icon: Icons.storefront_outlined,
      cor: context.colors.accent,
      titulo: item.nome,
      linhas: [
        DetalheLinha('Custo', '${item.custo} phatos'),
        DetalheLinha('Tipo', item.tipo == 'avatar' ? 'Avatar' : 'Geral'),
        DetalheLinha('Status', item.status ? 'Ativo' : 'Inativo'),
      ],
      acoes: [
        AcaoSecao(
          label: 'Editar',
          variant: AppButtonVariant.primary,
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ItemLojaDialog(item: item)),
            );
          },
        ),
        AcaoSecao(
          label: 'Excluir',
          variant: AppButtonVariant.danger,
          onPressed: () => _excluir(context, ref, item),
        ),
      ],
    );
  }

  Future<void> _excluir(
    BuildContext context,
    WidgetRef ref,
    ItemLojaModel item,
  ) async {
    final confirmado = await confirmarAcao(
      context,
      titulo: 'Excluir item?',
      mensagem:
          'Tem certeza que deseja excluir "${item.nome}"? '
          'Essa ação não pode ser desfeita.',
      confirmar: 'Excluir',
      destrutivo: true,
    );
    if (!confirmado || item.id == null) return;
    if (!context.mounted) return;
    Navigator.pop(context);
    await ref.read(itemLojaRepositoryProvider).remove(item.id!);
  }

  @override
  Widget build(BuildContext context) {
    final itensAsync = ref.watch(itemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Itens da Loja')),
      body: itensAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os itens.',
        ),
        data: (itens) {
          if (itens.isEmpty) {
            return const MensagemEstado(
              icon: Icons.storefront_outlined,
              titulo: 'Nenhum item cadastrado',
              subtitulo: 'Crie um novo item para vê-lo aqui.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: itens.length,
            itemBuilder: (context, index) {
              final item = itens[index];

              return ItemListaAdmin(
                icon: item.tipo == 'avatar'
                    ? Icons.face_outlined
                    : Icons.storefront_outlined,
                cor: context.colors.accent,
                titulo: item.nome,
                subtitulo: '${item.custo} phatos · ${item.status ? 'Ativo' : 'Inativo'}',
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _exibirDetalhes(context, ref, item),
              );
            },
          );
        },
      ),
    );
  }
}
