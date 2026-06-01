class MusicaModel {
  final String? id;
  final String nome;
  final String link;

  const MusicaModel({this.id, required this.nome, required this.link});

  factory MusicaModel.fromMap(Map<String, dynamic> map) => MusicaModel(
    nome: map['nome'] ?? '',
    link: map['link'] ?? '',
  );

  Map<String, dynamic> toMap() => {'nome': nome, 'link': link};
}
