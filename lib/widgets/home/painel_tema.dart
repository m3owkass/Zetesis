import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/model/tarefa.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/model/usuario.dart';
import 'package:zetesis/provider/auth_providers.dart';
import 'package:zetesis/provider/tarefa_providers.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/selecao_tarefa_screen.dart';
import 'package:zetesis/views/selecao_tema_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';
import 'package:zetesis/widgets/components/mensagem_estado.dart';


class PainelTema extends ConsumerStatefulWidget {
  PainelTema({super.key, this.progresso, this.total, this.tudoFeito, this.feitas});
    late var total;
    late var progresso; 
    late var tudoFeito;
    late var feitas;
 
  @override
  ConsumerState<PainelTema> createState() => _PainelTemaState();
}

class _PainelTemaState extends ConsumerState<PainelTema> {
  void contabilizarTarefa(List<TarefaModel> tarefas, UsuarioModel users){

    setState(() {
    widget.total = tarefas.length;
    widget.feitas = users.tarefasConcluidas.length;
    widget.progresso = widget.total == 0 ? 0.0 : widget.feitas / widget.total;
    widget.tudoFeito = widget.total > 0 && widget.feitas == widget.total;  
    });
    
  }

  @override
  Widget build(BuildContext context,) {
    final tarefaAsync = ref.watch(todasTarefasProvider);
    final userAsync = ref.watch(userProvider);

     return tarefaAsync. when(
      loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar os temas.',
                ),
      data: (tarefas)=>  Column(
        
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progresso', style: Theme.of(context).textTheme.titleMedium),
            userAsync.when(
               error: (err, _) => const MensagemEstado.erro(
                  subtitulo: 'Não foi possível carregar os temas.',
                ),
                 loading: () => const Center(child: CircularProgressIndicator()),
              data: (user) {contabilizarTarefa(tarefas, user!); return Text(widget.total == 0 ? '—' : '${widget.feitas}/${widget.total} tarefas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.colors.primary,
              )
              
              );})
  
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: widget.progresso,
            minHeight: 12,
            backgroundColor: context.colors.field,
            color: widget.tudoFeito ? context.colors.success : context.colors.accent,
          ),
        ),
        if (widget.tudoFeito) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, color: context.colors.star, size: 18),
              const SizedBox(width: 6),
              Text(
                'Tema concluído!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Iniciar Desafio',
          variant: AppButtonVariant.accent,
          onPressed: widget.total == 0
              ? null
              : () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SelecaoTemaScreen()),
                ),
        ),
      ],
    ));
  }
}
