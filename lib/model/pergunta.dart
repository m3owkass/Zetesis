import 'package:zetesis/model/resposta.dart';

enum TipoPergunta {
  multipla,

  vf,

  lacuna;

  static TipoPergunta fromName(String? name) => TipoPergunta.values.firstWhere(
    (t) => t.name == name,
    orElse: () => TipoPergunta.multipla,
  );
}

class PerguntaModel {
  final String enunciado;

  final String explicacao;
  final TipoPergunta tipo;
  final List<RespostaModel> respostas;

  const PerguntaModel({
    required this.enunciado,
    this.explicacao = '',
    this.tipo = TipoPergunta.multipla,
    required this.respostas,
  });

  factory PerguntaModel.fromMap(Map<String, dynamic> map) => PerguntaModel(
    enunciado: map['enunciado'] ?? '',
    explicacao: map['explicacao'] ?? '',
    tipo: TipoPergunta.fromName(map['tipo']),
    respostas: (map['respostas'] as List? ?? [])
        .whereType<Map>()
        .map((r) => RespostaModel.fromMap(Map<String, dynamic>.from(r)))
        .toList(),
  );

  Map<String, dynamic> toMap() {
    return {
      'enunciado': enunciado,
      'explicacao': explicacao,
      'tipo': tipo.name,
      'respostas': respostas.map((r) => r.toMap()).toList(),
    };
  }
}
