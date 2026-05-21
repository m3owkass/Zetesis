import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/views/materialbiblioteca_screen.dart';
import 'package:zetesis/widgets/components/item_loja.dart';

class BibliotecaScreen extends ConsumerWidget {
  const BibliotecaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
      final List<Map<String, dynamic>> items = const [
      {
        "nome": "Textos",
        "imagem": "bibliotecaTexto.png",
        "destino": "texto"},

      {
        "nome": "Músicas",
        "imagem": "bibliotecaMusica.png",
        "destino": "musica"},
      {
        "nome": "Vídeos",
        "imagem": "bibliotecaVideo.png",
        "destino": "video"},
      {
        "nome": "Imagens",
        "imagem": "bibliotecaImagem.png",
        "destino": "imagem"},
      {
        "nome": "Livros",
        "imagem": "bibliotecaLivro.png",
        "destino": "livro"},
      {
        "nome": "Outros",
        "imagem": "bibliotecaOutro.png",
        "destino": "outro"},
    ];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final item = items[index];

            return GestureDetector(
              onTap: () => Navigator.push(
                context,
              MaterialPageRoute(builder: (_) => MaterialBibliotecaScreen(destino:item["destino"]))),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffddd6d2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      child: Image.asset(
                        item["imagem"],
                      ),
                    ),
              
                    const SizedBox(height: 16),
              
                    Text(
                      item["nome"],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ), 
    );
  }
}