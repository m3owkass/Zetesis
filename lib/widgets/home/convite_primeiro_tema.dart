import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_theme.dart';
import 'package:zetesis/views/selecao_tema_screen.dart';
import 'package:zetesis/widgets/components/app_button.dart';

class ConvitePrimeiroTema extends StatelessWidget {
  const ConvitePrimeiroTema({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Escolha um tema para começar',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Escolher tema',
          variant: AppButtonVariant.accent,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SelecaoTemaScreen()),
          ),
        ),
      ],
    );
  }
}
