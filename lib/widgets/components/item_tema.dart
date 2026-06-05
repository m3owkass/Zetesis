import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';

class ItemTema extends ConsumerStatefulWidget {
  final TemaModel tema;

  const ItemTema({super.key, required this.tema});

  @override
  ConsumerState<ItemTema> createState() => _ItemTemaState();
}

class _ItemTemaState extends ConsumerState<ItemTema> {
  Future<void> _saveTheme(String nome) async {
    final uid = ref.read(authServiceProvider).currentUser?.uid;
    if (uid == null) return;
    await ref.read(databaseServiceProvider).updateUser(uid, {
      'temaAtual': nome,
    });
    final storage = ref.read(secureStorageProvider);
    final userData = await storage.getUser();
    if (userData != null) {
      userData['temaAtual'] = nome;
      await storage.saveUser(userData);
    }
    ref.invalidate(userProvider);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final nome = widget.tema.nome;
        ref.read(temaSelecionadoProvider.notifier).state = nome;
        _saveTheme(nome);
        Navigator.pop(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xfff0915a),
              borderRadius: BorderRadius.circular(200),
            ),
            child: FittedBox(
              fit: BoxFit.cover,
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: CircleAvatar(
                  radius: 66,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage:
                      widget.tema.assetUrl.isNotEmpty
                      ? NetworkImage(widget.tema.assetUrl)
                      : null,
                  child:
                      widget.tema.assetUrl.isEmpty
                      ? Text(
                          widget.tema.nome.isNotEmpty
                              ? widget.tema.nome[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.black,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xff6055a2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.tema.nome,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
