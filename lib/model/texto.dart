class TextoModel {
  final String? id;
  final String nome;
  final String descricao;

  const TextoModel({this.id, required this.nome, required this.descricao});

  factory TextoModel.fromMap(Map<String, dynamic> map) => TextoModel(
    nome: map['nome'] ?? '',
    descricao: map['descricao'] ?? '',
  );

  Map<String, dynamic> toMap() => {'nome': nome, 'descricao': descricao};
}
