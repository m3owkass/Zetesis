import 'package:flutter/material.dart';
import 'package:zetesis/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _itens = [
    'assets/home.webp',
    'assets/biblioteca.webp',
    'assets/loja.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            for (var i = 0; i < _itens.length; i++)
              Expanded(
                child: _NavItem(
                  asset: _itens[i],
                  selecionado: i == currentIndex,
                  onTap: () => onTap(i),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String asset;
  final bool selecionado;
  final VoidCallback onTap;

  const _NavItem({
    required this.asset,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 3,
            width: selecionado ? 40 : 0,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(3)),
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: selecionado ? 1 : 0.4,
            child: Image.asset(asset, height: 64),
          ),
        ],
      ),
    );
  }
}
