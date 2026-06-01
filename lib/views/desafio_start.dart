import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/selecao_tema.dart';

class DesafioStart extends ConsumerStatefulWidget {
  const DesafioStart({super.key});

  @override
  ConsumerState<DesafioStart> createState() => _DesafioStartState();
}

class _DesafioStartState extends ConsumerState<DesafioStart> {
  @override
  Widget build(BuildContext context) {
    final temaSelecionadoAsync = ref.watch(temaAtualProvider);

    return temaSelecionadoAsync.when(
      data: (tema) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.heightOf(context) * 0.05,
            ),
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SelecaoTema()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xfff0915a),
                  borderRadius: BorderRadius.circular(180),
                ),
                height: MediaQuery.heightOf(context) * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: tema != null
                      ? Image.network(tema.assetUrl)
                      : Image.asset('assets/desafio_placeholder.png'),
                ),
              ),
            ),
          ),
          if (tema != null) ...[
            Container(
              width: MediaQuery.widthOf(context) * 0.6,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff6055a2),
              ),
              child: Center(
                child: Text(
                  tema.nome,
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.widthOf(context) * 0.4,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff8175c8),
              ),
              child: Center(
                child: Text(
                  tema.descricao,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          SizedBox(height: MediaQuery.heightOf(context) * 0.1),
          TextButton(
            onPressed: () {},
            child: Container(
              width: MediaQuery.widthOf(context) * 0.7,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xfff0915a),
              ),
              child: Center(
                child: Text(
                  'Iniciar Desafio',
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.03,
                    color: const Color(0xff23255d),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Erro: $err')),
    );
  }
}
