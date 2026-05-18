class ItemLojaModel {
  final String nome;
  final int custo;
  final String? assetUrl;
  final bool status;

  ItemLojaModel({
    required this.nome,
    required this.custo,
    this.assetUrl,
    required this.status
  });

  factory ItemLojaModel.fromMap(Map<String, dynamic> map) {
    return ItemLojaModel(
      nome: map['nome'],
      custo: map['custo'],
      assetUrl: map['assetUrl'],
      status: map['status'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'custo': custo,
      'assetUrl': assetUrl,
      'status': status,
    };
  }
}