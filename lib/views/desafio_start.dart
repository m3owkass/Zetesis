import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zetesis/controller/auth_controller.dart';
import 'package:zetesis/model/tema.dart';
import 'package:zetesis/provider/providers.dart';
import 'package:zetesis/services/database_service.dart';
import 'package:zetesis/views/selecao_tema.dart';

class DesafioStart extends ConsumerStatefulWidget {
  const DesafioStart({super.key});

  @override
  ConsumerState<DesafioStart> createState() => _DesafioStartState();
}

class _DesafioStartState extends ConsumerState<DesafioStart> {
  DesafioStart desafioStart = DesafioStart();
  int desafioSelecionado = 0;

  final List<String> images = [
    'assets/desafio_placeholder.png',
    'assets/icon_google.png',
    'assets/biblioteca.webp',
    'assets/loja.webp',
  ];
  final List<String> temas = [
    'existencia',
    'subjetividade',
    'verdade',
    'dinheiro',
  ];
  DatabaseService databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.heightOf(context) * 0.05),
            child: TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<int>(builder: (context) => SelecaoTema()),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff0915a),
                  borderRadius: BorderRadius.circular(180),
                ),
                height: MediaQuery.heightOf(context) * 0.35,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(images[desafioSelecionado]),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.widthOf(context) * 0.6,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff6055a2),
              ),
              child: Center(
                child: Text(
                  temas[desafioSelecionado],
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.03,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.widthOf(context) * 0.4,
              height: MediaQuery.heightOf(context) * 0.063,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff8175c8),
              ),
              child: Center(
                child: Text(
                  temas[desafioSelecionado],
                  style: TextStyle(
                    fontSize: MediaQuery.heightOf(context) * 0.02,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.heightOf(context) * 0.1),
          TextButton(
            onPressed: (){
              databaseService.addTema(TemaModel(id: '1', nome: "nome", descricao: "descricao", assetUrl: "data:image/jpeg;base64,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"));
            },
            child: Center(
              child: Container(
                width: MediaQuery.widthOf(context) * 0.7,
                height: MediaQuery.heightOf(context) * 0.063,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xfff0915a),
                ),
                child: Center(
                  child: Text(
                    'Iniciar Desafio',
                    style: TextStyle(
                      fontSize: MediaQuery.heightOf(context) * 0.03,
                      color: Color(0xff23255d),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
