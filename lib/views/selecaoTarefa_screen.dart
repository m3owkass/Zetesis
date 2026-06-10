import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/tarefa_screen.dart';
import 'package:zetesis/widgets/components/item_tarefa.dart';

class SelecaotarefaScreen extends ConsumerStatefulWidget {
  const SelecaotarefaScreen({super.key});

  @override
  ConsumerState<SelecaotarefaScreen> createState() =>
      _SelecaotarefaScreenState();
}

class _SelecaotarefaScreenState extends ConsumerState<SelecaotarefaScreen> {
  TarefaModel? _selected;

  @override
  Widget build(BuildContext context) {
    final tarefaAsync = ref.watch(tarefasProvider);

    void _confirm() {
      if (_selected == null) return;
      final nome = _selected!.nome;
      

      debugPrint('selecionada: $nome');
      ref.read(tarefaSelecionadoProvider.notifier).state = nome;

      final uid = ref.read(authServiceProvider).currentUser?.uid;
      final db = ref.read(databaseServiceProvider);
      final storage = ref.read(secureStorageProvider);
      ref.invalidate(userProvider);

      if (uid != null) {
        db.updateUser(uid, {'tarefaAtual': nome}).ignore();
        storage.getUser().then((userData) {
          if (userData != null) {
            userData['tarefaAtual'] = nome;
            storage.saveUser(userData).ignore();
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xff1e1b3a),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xff6055a2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                'Escolha sua tarefa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: tarefaAsync.when(
                data: (tarefas) => GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                    mainAxisSpacing: 32,
                    childAspectRatio: 0.82,
                  ),
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) => ItemTarefa(
                    tarefa: tarefas[index],
                    isSelected: _selected?.nome == tarefas[index].nome,
                    onSelect: (tema) => setState(() => _selected = tema),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(
                  child: Text(
                    'Erro: $err',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffef5350),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(0, 52),
                      ),
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                       
                          _confirm;
                          _selected !=null? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TarefaScreen(),
                            )
                          ):null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selected != null
                            ? Color(0xff66bb6a)
                            : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size(0, 52),
                      ),
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
