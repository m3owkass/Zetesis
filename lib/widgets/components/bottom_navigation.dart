import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/home.webp'), height: 70),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/biblioteca.webp'), height: 70),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/loja.webp'), height: 70),
          label: '',
        ),
      ],
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
