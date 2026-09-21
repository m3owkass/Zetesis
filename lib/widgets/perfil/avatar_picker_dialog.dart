import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class AvatarPickerDialog extends ConsumerWidget {
  final UsuarioModel user;

  const AvatarPickerDialog({super.key, required this.user});

  static Future<void> mostrar(BuildContext context, UsuarioModel user) {
    return showDialog(
      context: context,
      builder: (_) => AvatarPickerDialog(user: user),
    );
  }

  Future<void> _selecionar(
    BuildContext context,
    WidgetRef ref,
    ItemLojaModel item,
  ) async {
    final ok = await ref
        .read(authControllerProvider.notifier)
        .updateAvatarUrl(item.assetUrl ?? '');
    if (!context.mounted) return;
    if (ok) Navigator.pop(context);
  }

  Future<void> _comprarESelecionar(
    BuildContext context,
    WidgetRef ref,
    ItemLojaModel item,
  ) async {
    final uid = ref.read(authServiceProvider).currentUser?.uid;
    final itemId = item.id;
    if (uid == null || itemId == null) return;

    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Confirmar compra'),
        content: Text('Comprar "${item.nome}" por ${item.custo} phatos?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Comprar'),
          ),
        ],
      ),
    );
    if (confirmou != true) return;

    final result = await ref
        .read(usuarioRepositoryProvider)
        .comprarItem(uid, itemId: itemId, custo: item.custo);

    if (!context.mounted) return;
    if (!result.ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.erro!),
          backgroundColor: context.colors.danger,
        ),
      );
      return;
    }

    await _selecionar(context, ref, item);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itensAsync = ref.watch(itemsProvider);

    return AlertDialog(
      backgroundColor: context.colors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      title: const Text('Escolha seu avatar'),
      content: SizedBox(
        width: double.maxFinite,
        child: itensAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => const MensagemEstado.erro(
            subtitulo: 'Não foi possível carregar os avatares.',
          ),
          data: (itens) {
            final avatares = itens
                .where((i) => i.tipo == 'avatar' && i.status)
                .toList();

            if (avatares.isEmpty) {
              return const MensagemEstado(
                icon: Icons.face_outlined,
                titulo: 'Nenhum avatar disponível',
                subtitulo: 'Novos avatares chegam em breve.',
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSpacing.sm,
                crossAxisSpacing: AppSpacing.sm,
                childAspectRatio: 0.8,
              ),
              itemCount: avatares.length,
              itemBuilder: (context, index) {
                final item = avatares[index];
                final comprado = user.comprou(item.id);
                final selecionado =
                    user.avatarUrl.isNotEmpty && user.avatarUrl == item.assetUrl;

                return _AvatarTile(
                  item: item,
                  comprado: comprado,
                  selecionado: selecionado,
                  onTap: () => comprado
                      ? _selecionar(context, ref, item)
                      : _comprarESelecionar(context, ref, item),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

class _AvatarTile extends StatelessWidget {
  final ItemLojaModel item;
  final bool comprado;
  final bool selecionado;
  final VoidCallback onTap;

  const _AvatarTile({
    required this.item,
    required this.comprado,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.colors.field,
                  border: Border.all(
                    color: selecionado
                        ? context.colors.primary
                        : context.colors.border,
                    width: selecionado ? 3 : 1,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: StorageImage(path: item.assetUrl),
              ),
              if (!comprado)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Icon(
                    Icons.lock,
                    size: 18,
                    color: context.colors.textSecondary,
                  ),
                ),
              if (selecionado)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: context.colors.success,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.nome,
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (!comprado)
            Text(
              '${item.custo} phatos',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
