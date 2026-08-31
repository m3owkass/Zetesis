import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/material_biblioteca.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/utils/abrir_anexo.dart';
import 'package:zetesis/utils/embed_link.dart';
import 'package:zetesis/widgets/admin/acao_secao.dart';
import 'package:zetesis/widgets/admin/detalhes_dialog.dart';
import 'package:zetesis/widgets/components/anexo.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/embed_player.dart';
import 'package:zetesis/widgets/components/item_biblioteca.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {
  const MaterialBibliotecaScreen({super.key});

  void _exibirDetalhes(BuildContext context, MaterialBibliotecaModel item) {
    final temAnexo = item.assetUrl != null && item.assetUrl!.isNotEmpty;
    final temImagem = ehExtensaoDeImagem(item.assetUrl);
    final embed = detectarEmbed(item.assetUrl);

    DetalhesDialog.mostrar(
      context,
      icon: Icons.menu_book_outlined,
      cor: AppColors.primary,
      titulo: item.nome,
      cabecalho: embed != null
          ? EmbedPlayer(url: item.assetUrl!)
          : temImagem
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: StorageImage(
                path: item.assetUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          : null,
      linhas: [
        DetalheLinha('Autor', item.autor),
        DetalheLinha('Descrição', item.descricao),
        DetalheLinha('Conteúdo', item.conteudoTexto),
      ],
      acoes: [
        if (temAnexo)
          AcaoSecao(
            label: 'Abrir anexo',
            variant: AppButtonVariant.primary,
            onPressed: () => abrirAnexo(context, item.assetUrl),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materiaisAsync = ref.watch(materiaisProvider);
    final grupoNome = ref.watch(grupoSelecionadoProvider) ?? 'Materiais';

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          grupoNome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: materiaisAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => const MensagemEstado.erro(
          subtitulo: 'Não foi possível carregar os materiais.',
        ),
        data: (materiais) {
          if (materiais.isEmpty) {
            return const MensagemEstado(
              icon: Icons.inbox_outlined,
              titulo: 'Nada por aqui ainda',
              subtitulo: 'Este grupo não tem materiais no momento.',
            );
          }
          final favoritos = ref.watch(favoritosProvider).value ?? {};
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: materiais.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final item = materiais[index];
              return ItemBiblioteca(
                item: item,
                isFavorito: favoritos.contains(item.id),
                onTap: () => _exibirDetalhes(context, item),
                onFavorite: item.id == null
                    ? null
                    : () {
                        final user = ref.read(authStateProvider).value;
                        if (user == null) return;
                        ref
                            .read(usuarioRepositoryProvider)
                            .toggleFavorito(
                              user.uid,
                              item.id!,
                              add: !favoritos.contains(item.id),
                            );
                      },
              );
            },
          );
        },
      ),
    );
  }
}
