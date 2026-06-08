class MaterialBibliotecaModel {
  final String? id;
  final String nome;
  final String tipo;
  final String? descricao;
  final String? assetUrl;
  final String? autor;
  final String? dataEnvio;

  const MaterialBibliotecaModel({
    this.id,
    required this.nome,
    required this.tipo,
    this.descricao,
    this.assetUrl,
    this.autor,
    this.dataEnvio,
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
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'tipo': tipo,
    'descricao': descricao,
    'assetUrl': assetUrl,
    'autor': autor,
    'dataEnvio': dataEnvio,
  };
}
