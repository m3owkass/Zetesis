
class TarefaModel {
  final String? id;
  final String nome;
  final String descricao;
  final String tema;
  final List<String> respostas;

  const TarefaModel({this.id, required this.nome, required this.tema, required this.descricao, required this.respostas});

  factory TarefaModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      TarefaModel(
        id: id ?? map['id'],
        nome: map['nome'] ?? '',
        tema: map['tema'],
        descricao: map['descricao'] ??'',
        respostas: (map['respostas'] as List?)
        ?.whereType<String>()
        .toList()
        ?? []
      );

  Map<String, dynamic> toMap(){
    return{
      'nome':nome,
      'descricao':descricao,
      'tema':tema,
      'respostas':respostas
    };
  }
}
