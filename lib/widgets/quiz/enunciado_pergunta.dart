import 'package:flutter/material.dart';
import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/theme/app_colors.dart';

class EnunciadoPergunta extends StatelessWidget {
  final PerguntaModel pergunta;
  final int? selectedIndex;

  const EnunciadoPergunta({
    super.key,
    required this.pergunta,
    required this.selectedIndex,
  });

  static const _estilo = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryDark,
    height: 1.35,
  );

  @override
  Widget build(BuildContext context) {
    if (pergunta.tipo != TipoPergunta.lacuna ||
        !pergunta.enunciado.contains('___')) {
      return Text(pergunta.enunciado, style: _estilo);
    }

    final partes = pergunta.enunciado.split('___');
    final selecionada = selectedIndex != null
        ? pergunta.respostas[selectedIndex!].texto
        : null;

    return Text.rich(
      TextSpan(
        style: _estilo,
        children: [
          for (int i = 0; i < partes.length; i++) ...[
            TextSpan(text: partes[i]),
            if (i < partes.length - 1)
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selecionada != null
                        ? AppColors.primary
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selecionada != null
                          ? AppColors.primary
                          : AppColors.border,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    selecionada ?? '          ',
                    style: _estilo.copyWith(
                      fontSize: 19,
                      color: selecionada != null
                          ? Colors.white
                          : AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
