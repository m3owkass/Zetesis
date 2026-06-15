class GrupoBibliotecaModel {
  final String? id;
  final String nome;
  final String? descricao;
  final String? assetUrl;

  const GrupoBibliotecaModel({
    this.id,
    required this.nome,
    this.descricao,
    this.assetUrl,
  });

  factory GrupoBibliotecaModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return GrupoBibliotecaModel(
      id: id ?? map['id'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      assetUrl: map['assetUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'descricao': descricao,
    'assetUrl': assetUrl,
  };
}
