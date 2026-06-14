import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/theme/app_colors.dart';
import 'package:zetesis/views/home_screen.dart';
import 'package:zetesis/views/biblioteca_screen.dart';
import 'package:zetesis/views/loja_screen.dart';
import 'package:zetesis/widgets/components/appbar.dart';
import 'package:zetesis/widgets/components/bottom_navigation.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _currentIndex = 0;

  static const _pages = [HomeScreen(), BibliotecaScreen(), LojaScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const CustomStatefulAppBar(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 2)),
        ),
        child: CustomBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),
    );
  }
}
