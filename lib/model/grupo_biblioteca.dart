enum FormatoConteudo {
  arquivo,

  link,

  texto;

  static FormatoConteudo fromName(String? name) => FormatoConteudo.values
      .firstWhere((f) => f.name == name, orElse: () => FormatoConteudo.arquivo);
}

extension FormatoConteudoRotulo on FormatoConteudo {
  String get rotulo => switch (this) {
    FormatoConteudo.arquivo => 'Arquivo (upload)',
    FormatoConteudo.link => 'Link',
    FormatoConteudo.texto => 'Texto',
  };
}

class GrupoBibliotecaModel {
  final String? id;
  final String nome;
  final String? descricao;
  final String? assetUrl;
  final FormatoConteudo formatoConteudo;

  const GrupoBibliotecaModel({
    this.id,
    required this.nome,
    this.descricao,
    this.assetUrl,
    this.formatoConteudo = FormatoConteudo.arquivo,
  });

  factory GrupoBibliotecaModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return GrupoBibliotecaModel(
      id: id ?? map['id'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'],
      assetUrl: map['assetUrl'],
      formatoConteudo: FormatoConteudo.fromName(map['formatoConteudo']),
    );
  }

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'descricao': descricao,
    'assetUrl': assetUrl,
    'formatoConteudo': formatoConteudo.name,
  };
}
