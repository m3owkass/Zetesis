class MaterialBibliotecaModel {
  final String? id;
  final String nome;
  final String tipo;
  final String? descricao;
  final String? assetUrl;

  /// autor da obra em si, tipo o autor do livro
  final String? autor;
  final String? dataEnvio;

  /// nome de quem enviou o conteudo na hora do envio
  final String? enviadoPor;

  const MaterialBibliotecaModel({
    this.id,
    required this.nome,
    required this.tipo,
    this.descricao,
    this.assetUrl,
    this.autor,
    this.dataEnvio,
    this.enviadoPor,
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
      assetUrl: map['assetUrl'],
      autor: map['autor'],
      dataEnvio: map['dataEnvio'],
      enviadoPor: map['enviadoPor'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'tipo': tipo,
    'descricao': descricao,
    'assetUrl': assetUrl,
    'autor': autor,
    'dataEnvio': dataEnvio,
    'enviadoPor': enviadoPor,
  };
}
