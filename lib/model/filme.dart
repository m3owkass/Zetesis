class FilmeModel {
  final String? id;
  final String nome;
  final String link;

  const FilmeModel({this.id, required this.nome, required this.link});

  factory FilmeModel.fromMap(Map<String, dynamic> map) => FilmeModel(
    nome: map['nome'] ?? '',
    link: map['link'] ?? '',
  );

  Map<String, dynamic> toMap() => {'nome': nome, 'link': link};
}
