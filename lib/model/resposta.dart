class RespostaModel {
  final String texto;
  final bool isCorrect;

  const RespostaModel({required this.texto, this.isCorrect = false});

  factory RespostaModel.fromMap(Map<String, dynamic> map) => RespostaModel(
    texto: map['texto'] ?? '',
    isCorrect: map['isCorrect'] == true,
  );

  Map<String, dynamic> toMap() {
    return {'texto': texto, 'isCorrect': isCorrect};
  }
}
