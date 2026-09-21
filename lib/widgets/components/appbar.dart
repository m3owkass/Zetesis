import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/views/admin_screen.dart';
import 'package:zetesis/views/perfil_screen.dart';
import 'package:zetesis/views/ranking_screen.dart';
import 'package:zetesis/widgets/components/pontos_badge.dart';
import 'package:zetesis/widgets/components/storage_image.dart';

class CustomStatefulAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const CustomStatefulAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    final isAdmin = ref.watch(userProvider).valueOrNull?.admin == true;

    final isDev =
        kDebugMode && ref.watch(userProvider).valueOrNull?.developer == true;

    return AppBar(
      backgroundColor: context.colors.card,
      foregroundColor: context.colors.primaryDark,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: userAsync.when(
          loading: () => const _Saudacao(nome: '...'),
          error: (_, _) => const _Saudacao(nome: ''),
          data: (user) => Row(
            children: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    ref.read(authControllerProvider.notifier).logout();
                  } else if (value == 'perfil') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PerfilScreen()),
                    );
                  } else if (value == 'admin') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AdminScreen()),
                    );
                  } else if (value == 'ranking') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RankingScreen()),
                    );
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'perfil',
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(width: 8),
                        Text('Perfil'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'ranking',
                    child: Row(
                      children: [
                        Icon(Icons.military_tech),
                        SizedBox(width: 8),
                        Text('Ranking'),
                      ],
                    ),
                  ),
                  if (isDev || isAdmin)
                    const PopupMenuItem(
                      value: 'admin',
                      child: Row(
                        children: [
                          Icon(Icons.admin_panel_settings),
                          SizedBox(width: 8),
                          Text('Admin'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text('Sair'),
                      ],
                    ),
                  ),
                ],
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: context.colors.field,
                  backgroundImage:
                      StorageImage.resolveUrl(user?.avatarUrl) != null
                      ? NetworkImage(StorageImage.resolveUrl(user!.avatarUrl)!)
                      : null,
                  child: StorageImage.resolveUrl(user?.avatarUrl) == null
                      ? Text(
                          user?.nome.isNotEmpty == true
                              ? user!.nome[0].toUpperCase()
                              : '?',
                          style: TextStyle(color: context.colors.primaryDark),
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _Saudacao(nome: user?.nome ?? '')),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(2),
        child: Divider(height: 2, thickness: 2, color: context.colors.border),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: PontosBadge(valor: userAsync.valueOrNull?.pontos ?? 0),
        ),
      ],
    );
  }
}

class _Saudacao extends StatelessWidget {
  final String nome;

  const _Saudacao({required this.nome});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Olá $nome',
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: context.colors.primaryDark,
      ),
    );
  }
}
