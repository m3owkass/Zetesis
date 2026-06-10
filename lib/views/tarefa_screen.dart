import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/bottom_navigation.dart';

class TarefaScreen extends ConsumerWidget {
  TarefaScreen({super.key});

  void _returnIndex(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tarefaAtualAsync = ref.watch(tarefaAtualProvider);
    final userAsync = ref.watch(userProvider);

    return tarefaAtualAsync.when(
      data: (tarefa) => Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.widthOf(context),
              height: MediaQuery.heightOf(context) / 4,
              decoration: BoxDecoration(color: Color(0xff6055a2)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: MediaQuery.heightOf(context) / 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff38344f),
                          ),
                          child: tarefa?.nome != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    tarefa!.nome,
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    "nome não encontrado",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                        ),
                        Container(
                          height: MediaQuery.heightOf(context) / 25,
                          width: MediaQuery.widthOf(context) / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff38344f),
                          ),
                          child: Text(
                            '${userAsync.valueOrNull?.pontos ?? 0}',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: tarefa?.descricao != null
                          ? Text(
                              tarefa!.descricao,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              "Descrição não encontrada",
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tarefa?.respostas.length != null
                    ? tarefa!.respostas.length
                    : 4,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilledButton(
                    onPressed: (){},
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Expanded(
                        child: Text(
                          tarefa?.respostas[index] != null
                              ? tarefa!.respostas[index]
                              : 'Placeholder',
                              textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white, fontSize: 23),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () => _returnIndex(context),
                    icon: Icon(Icons.logout, color: Color(0xff6055a2),size: MediaQuery.heightOf(context)/20,),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
    );
  }
}
