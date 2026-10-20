import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/ranking_screen.dart';
import 'package:zetesis/widgets/admin/card_estatistica.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';
import 'package:zetesis/widgets/home/circulo_tema.dart';
import 'package:zetesis/widgets/home/convite_primeiro_tema.dart';
import 'package:zetesis/widgets/home/painel_tema.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});


  void calcularRanking(List<TarefaModel> tarefas, UsuarioModel user , WidgetRef ref) async{
    final repo = ref.read(usuarioRepositoryProvider);
    String ranking;
    double total = tarefas.length.toDouble();
    double feitas = user.tarefasConcluidas.length.toDouble();
    String id = user.uid!;

    if(feitas<=total*0.4){
      ranking = "Bronze";
    }else if(feitas<=total*0.6){
      ranking = "Prata";
    }else{
      ranking = "Ouro";
    }
    final camposBase = {'nome': user.nome, "ranking": ranking};
    await repo.update(id, camposBase);
    }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final lastTarefa = ref.watch(lastTarefaProvider);
    final tarefaAsync = ref.watch(todasTarefasProvider);

    return userAsync.when(
      data: (user) {
        tarefaAsync.when(data: (tarefas) => calcularRanking(tarefas, user!, ref),
        error: (error, stackTrace) => (),
        loading: () => (),);
        
        return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 10,),
                  
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> RankingScreen())),
                    child: CardEstatistica(
                      icon: Icons.emoji_events_rounded,
                      cor: context.colors.accent,
                      valor: user?.ranking,
                      label: 'Seu Ranking',
                    ),
                  ),
                  SizedBox(height: 30,),
                  lastTarefa.when(
                    data: (tarefa) => CardEstatistica(
                      icon: Icons.auto_awesome,
                      cor: context.colors.accent,
                      valor: tarefa?.nome,
                      label: 'Última Tarefa Concluída',
                    ),
                    error: (err, _) => Text('oi'),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            PainelTema(),
            SizedBox(height: 30,),
          ],
        ),
    );},
      error: (err, _) => const MensagemEstado.erro(
        subtitulo: 'Não foi possível carregar os temas.',
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
