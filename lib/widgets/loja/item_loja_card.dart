import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/item_loja.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/pontos_badge.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class ItemLojaCard extends ConsumerWidget {
  final ItemLojaModel item;
  final UsuarioModel? user;

  const ItemLojaCard({super.key, required this.item, required this.user});

  Future<void> _comprar(BuildContext context, WidgetRef ref) async {
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.ok ? '"${item.nome}" adquirido!' : result.erro!),
        backgroundColor: result.ok ? AppColors.success : AppColors.danger,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final comprado = user?.comprou(item.id) ?? false;
    final temSaldo = (user?.pontos ?? 0) >= item.custo;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.field,
            backgroundImage:
                (item.assetUrl != null && item.assetUrl!.isNotEmpty)
                ? NetworkImage(StorageImage.resolveUrl(item.assetUrl)!)
                : null,
            child: (item.assetUrl == null || item.assetUrl!.isEmpty)
                ? Text(
                    item.nome.isNotEmpty ? item.nome[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      color: AppColors.primaryDark,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.nome,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primaryDark,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                PontosBadge(valor: item.custo, iconSize: 20, fontSize: 14),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 130,
            child: comprado
                ? const _Adquirido()
                : AppButton(
                    label: temSaldo ? 'Comprar' : 'Sem phatos',
                    variant: AppButtonVariant.accent,
                    height: 44,
                    onPressed: temSaldo ? () => _comprar(context, ref) : null,
                  ),
          ),
        ],
      ),
    );
  }
}

class _Adquirido extends StatelessWidget {
  const _Adquirido();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: AppColors.success),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: AppColors.successDark, size: 18),
          SizedBox(width: 6),
          Text(
            'Adquirido',
            style: TextStyle(
              color: AppColors.successDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
