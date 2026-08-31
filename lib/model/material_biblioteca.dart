class MaterialBibliotecaModel {
  final String? id;
  final String nome;
  final String tipo;
  final String? descricao;
  final String? assetUrl;
  final String? conteudoTexto;
  final String? autor;
  final String? dataEnvio;
  final String? enviadoPor;

  const MaterialBibliotecaModel({
    this.id,
    required this.nome,
    required this.tipo,
    this.descricao,
    this.assetUrl,
    this.conteudoTexto,
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
      conteudoTexto: map['conteudoTexto'],
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
    'conteudoTexto': conteudoTexto,
    'autor': autor,
    'dataEnvio': dataEnvio,
    'enviadoPor': enviadoPor,
  };
}
