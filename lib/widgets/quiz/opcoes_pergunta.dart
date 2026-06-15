import 'package:flutter/material.dart';
import 'package:zetesis/model/pergunta.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/theme/app_theme.dart';

class OpcoesPergunta extends StatelessWidget {
  final PerguntaModel pergunta;
  final int? selectedIndex;
  final bool checked;
  final ValueChanged<int> onSelect;

  const OpcoesPergunta({
    super.key,
    required this.pergunta,
    required this.selectedIndex,
    required this.checked,
    required this.onSelect,
  });

  Color _corFundo(int index) {
    if (!checked) {
      return index == selectedIndex ? AppColors.primary : Colors.white;
    }
    if (pergunta.respostas[index].isCorrect) return AppColors.success;
    if (index == selectedIndex) return AppColors.danger;
    return Colors.white;
  }

  Color _corTexto(int index) {
    if (!checked) {
      return index == selectedIndex ? Colors.white : AppColors.primaryDark;
    }
    if (pergunta.respostas[index].isCorrect || index == selectedIndex) {
      return Colors.white;
    }
    return AppColors.primaryDark;
  }

  BoxDecoration _decoracao(int index) {
    final selecionada = index == selectedIndex;
    return BoxDecoration(
      color: _corFundo(index),
      borderRadius: BorderRadius.circular(AppRadius.sm),
      border: Border.all(
        color: selecionada && !checked
            ? AppColors.primaryDark
            : AppColors.border,
        width: 2,
      ),
    );
  }

  void _tap(int index) {
    if (!checked) onSelect(index);
  }

  @override
  Widget build(BuildContext context) {
    return switch (pergunta.tipo) {
      TipoPergunta.vf => Row(
        children: [
          for (int i = 0; i < pergunta.respostas.length; i++) ...[
            if (i > 0) const SizedBox(width: 14),
            Expanded(child: _cartaoVF(i)),
          ],
        ],
      ),
      TipoPergunta.lacuna => Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          for (int i = 0; i < pergunta.respostas.length; i++) _chipLacuna(i),
        ],
      ),
      TipoPergunta.multipla => Column(
        children: [
          for (int i = 0; i < pergunta.respostas.length; i++) ...[
            _alternativa(i),
            const SizedBox(height: 12),
          ],
        ],
      ),
    };
  }

  Widget _cartaoVF(int index) {
    final corTexto = _corTexto(index);
    final ehVerdadeiro = pergunta.respostas[index].texto
        .toLowerCase()
        .startsWith('v');

    return GestureDetector(
      onTap: () => _tap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: _decoracao(index),
        child: Column(
          children: [
            Icon(
              ehVerdadeiro ? Icons.thumb_up_rounded : Icons.thumb_down_rounded,
              size: 40,
              color: corTexto == Colors.white
                  ? Colors.white
                  : (ehVerdadeiro ? AppColors.success : AppColors.danger),
            ),
            const SizedBox(height: 10),
            Text(
              pergunta.respostas[index].texto.toUpperCase(),
              style: TextStyle(
                color: corTexto,
                fontSize: 17,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipLacuna(int index) {
    return GestureDetector(
      onTap: () => _tap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: _decoracao(index),
        child: Text(
          pergunta.respostas[index].texto,
          style: TextStyle(
            color: _corTexto(index),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _alternativa(int index) {
    final corTexto = _corTexto(index);
    final letra = String.fromCharCode(65 + index);
    IconData? icone;
    if (checked) {
      if (pergunta.respostas[index].isCorrect) {
        icone = Icons.check_circle;
      } else if (index == selectedIndex) {
        icone = Icons.cancel;
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: _decoracao(index),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          onTap: () => _tap(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: corTexto == Colors.white
                      ? Colors.white24
                      : AppColors.primary.withValues(alpha: 0.12),
                  child: Text(
                    letra,
                    style: TextStyle(
                      color: corTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    pergunta.respostas[index].texto,
                    style: TextStyle(
                      color: corTexto,
                      fontSize: 17,
                      height: 1.25,
                    ),
                  ),
                ),
                if (icone != null) ...[
                  const SizedBox(width: 8),
                  Icon(icone, color: Colors.white),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
