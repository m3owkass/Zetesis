import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';

class CustomStatefulAppBar extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  const CustomStatefulAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  ConsumerState<CustomStatefulAppBar> createState() =>
      _CustomStatefulAppBarState();
}

class _CustomStatefulAppBarState extends ConsumerState<CustomStatefulAppBar> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return AppBar(
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: userAsync.when(
          loading: () => const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 10),
              Text("Carregando..."),
            ],
          ),

          error: (_, __) => const Text("Erro"),

          data: (user) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      (user?.avatarUrl != null && user!.avatarUrl.isNotEmpty)
                      ? NetworkImage(user.avatarUrl)
                      : null,
                  child: (user?.avatarUrl == null || user!.avatarUrl.isEmpty)
                      ? Text(
                          user?.nome.isNotEmpty == true
                              ? user!.nome[0].toUpperCase()
                              : '?',
                          style: const TextStyle(color: Colors.black),
                        )
                      : null,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    user?.nome ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          },
        ),
      ),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(color: const Color(0xffcbafa2), height: 2.0),
      ),

      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Row(
            children: [
              Image(
                image: const AssetImage('assets/phatos.webp'),
                fit: BoxFit.scaleDown,
                height: 35,
              ),
              const SizedBox(width: 8),
              const Text(
                '000',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
