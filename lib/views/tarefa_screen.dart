import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/widgets/components/bottom_navigation.dart';

class TarefaScreen extends ConsumerWidget {
  TarefaScreen({super.key});

  void _returnIndex(context){
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temaSelecionadoAsync = ref.watch(temaAtualProvider);
    final userAsync = ref.watch(userProvider);

    return temaSelecionadoAsync.when(
      data: (tema) => Scaffold(
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
                          width: MediaQuery.widthOf(context) / 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff38344f),
                          ),
                          child: Text(
                            'tarefa 1',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                            textAlign: TextAlign.center,
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
                      child: Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque vel augue malesuada. Nulla commodo arcu augue?",
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
                itemCount: 4,
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    'pergunta ${index + 1}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Row(
              children: [IconButton(onPressed: () => _returnIndex(context), icon: Icon(Icons.logout))],
            )
          ],
        ),
      ),

      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
    );
  }
}
