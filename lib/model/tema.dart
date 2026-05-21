

 class TemaModel{
   String? id;
   String nome;
   String descricao;
   String assetUrl;

  TemaModel({

    this.id,
    required this.nome,
    required this.descricao,
    required this.assetUrl
  });

  factory TemaModel.fromMap(Map<String, dynamic> map) {
    return TemaModel(
      nome: map['nome'],
      assetUrl: map['assetUrl'],
      descricao: map['descricao']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'descricao': descricao,
      'assetUrl': assetUrl,
    };
  }

 }