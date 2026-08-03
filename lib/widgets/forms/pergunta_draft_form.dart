import 'package:flutter/material.dart';

class PerguntaDraftForm extends StatefulWidget {
  final List<TextEditingController> perguntasControllers;

  const PerguntaDraftForm({super.key, required this.perguntasControllers});

  @override
  State<PerguntaDraftForm> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<PerguntaDraftForm> {
  final List<TextEditingController> _respostasControllers = [
    TextEditingController(),
  ];

  @override
  void dispose() {
    for (var controller in _respostasControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addResposta() {
    setState(() {
      _respostasControllers.add(TextEditingController());
    });
  }

  void deleteResposta(int index) {
    setState(() {
      _respostasControllers.removeAt(index).dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.perguntasControllers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                      side: const BorderSide(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      side: const BorderSide(color: Colors.black),
                    ),
                    trailing: IconButton(
                      onPressed: () => deletePergunta(index),
                      icon: Icon(Icons.close),
                    ),
                    title: Column(
                      children: [
                        Text("Pergunta ${index + 1}"),

                        TextField(
                          decoration: InputDecoration(label: Text('Enunciado')),
                          controller: [index],
                        ),
                      ],
                    ),

                    children: [
                      SizedBox(
                        height: 250,
                        child: ListView.builder(
                          itemCount: _respostasControllers.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(12),
                              child: TextField(
                                decoration: InputDecoration(
                                  label: Text('Resposta ${index + 1}'),
                                ),
                                controller: _respostasControllers[index],
                              ),
                            );
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: addResposta,
                        child: const Text('Adicione resposta'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
