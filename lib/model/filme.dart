class FilmeModel {
  final String? id;
  final String nome;
  final String link;

  const FilmeModel({this.id, required this.nome, required this.link});

  factory FilmeModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      FilmeModel(
        id: id ?? map['id'],
        nome: map['nome'] ?? '',
        link: map['link'] ?? '',
      );

  Map<String, dynamic> toMap() => {'nome': nome, 'link': link};
}
