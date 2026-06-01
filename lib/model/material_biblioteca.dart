class MaterialBibliotecaModel {
  final String? id;
  final String nome;
  final String tipo;
  final String? descricao;
  final String? url;

  const MaterialBibliotecaModel({
    this.id,
    required this.nome,
    required this.tipo,
    this.descricao,
    this.url,
  });

  factory MaterialBibliotecaModel.fromMap(
    Map<String, dynamic> map, {
    String? id,
  }) {
    return MaterialBibliotecaModel(
      id: id ?? map['id'],
      nome: map['nome'] ?? '',
      tipo: map['tipo'] ?? '',
      descricao: map['descricao'],
      url: map['url'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'tipo': tipo,
    'descricao': descricao,
    'url': url,
  };
}
