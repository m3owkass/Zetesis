import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialBibliotecaScreen extends ConsumerWidget {
  final String destino;
  const MaterialBibliotecaScreen({super.key, required this.destino});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
      
      ), 
    );
  }
}