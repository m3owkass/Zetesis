import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/item_tema.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';

class SelecaoTemaScreen extends ConsumerStatefulWidget {
  const SelecaoTemaScreen({super.key});

  @override
  ConsumerState<SelecaoTemaScreen> createState() => _SelecaoTemaScreenState();
}

class _SelecaoTemaScreenState extends ConsumerState<SelecaoTemaScreen> {
  TemaModel? _selected;

  void _confirm() {
    final tema = _selected;
    if (tema == null) return;

    ref.read(temaSelecionadoProvider.notifier).state = tema.nome;

    final uid = ref.read(authServiceProvider).currentUser?.uid;
    final usuarios = ref.read(usuarioRepositoryProvider);
    final storage = ref.read(secureStorageProvider);

    Navigator.pop(context);

    if (uid != null) {
      usuarios
          .update(uid, {'temaAtual': tema.nome})
          .catchError(
            (e) => debugPrint('Erro ao salvar tema no Firestore: $e'),
          );
      storage.getUser().then((userData) {
        if (userData != null) {
          userData['temaAtual'] = tema.nome;
          storage
              .saveUser(userData)
              .catchError(
                (e) => debugPrint('Erro ao salvar tema no storage: $e'),
              );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final temasAsync = ref.watch(temasProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Escolha seu tema',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: temasAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar os temas.',
                ),
                data: (temas) => temas.isEmpty
                    ? const MensagemEstado(
                        icon: Icons.category_outlined,
                        titulo: 'Nenhum tema disponível',
                        subtitulo: 'Os temas ainda não foram cadastrados.',
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: AppSpacing.lg,
                              mainAxisSpacing: AppSpacing.lg,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: temas.length,
                        itemBuilder: (context, index) => ItemTema(
                          tema: temas[index],
                          isSelected: _selected?.nome == temas[index].nome,
                          onSelect: (tema) => setState(() => _selected = tema),
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: AppButton(
                label: 'Confirmar',
                variant: AppButtonVariant.success,
                onPressed: _selected != null ? _confirm : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
