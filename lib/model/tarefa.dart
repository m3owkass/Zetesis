import 'package:zetesis/model/pergunta.dart';

class TarefaModel {
  final String? id;
  final String nome;
  final String descricao;
  final String tema;
  final String? enviadoPor;
  final String? dataEnvio;
  final List<PerguntaModel> perguntas;

  const TarefaModel({
    this.id,
    required this.nome,
    required this.tema,
    required this.descricao,
    this.enviadoPor,
    this.dataEnvio,
    required this.perguntas,
  });

  factory TarefaModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      TarefaModel(
        id: id ?? map['id'],
        nome: map['nome'] ?? '',
        tema: map['tema'] ?? '',
        descricao: map['descricao'] ?? '',
        enviadoPor: map['enviadoPor'],
        dataEnvio: map['dataEnvio'],
        perguntas: (map['perguntas'] as List? ?? [])
            .whereType<Map>()
            .map((p) => PerguntaModel.fromMap(Map<String, dynamic>.from(p)))
            .toList(),
      );

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'tema': tema,
      'enviadoPor': enviadoPor,
      'dataEnvio': dataEnvio,
      'perguntas': perguntas.map((p) => p.toMap()).toList(),
    };
  }
}
