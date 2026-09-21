class ItemLojaModel {
  final String? id;
  final String nome;
  final int custo;
  final String? assetUrl;
  final bool status;
  final String tipo;

  ItemLojaModel({
    this.id,
    required this.nome,
    required this.custo,
    this.assetUrl,
    required this.status,
    this.tipo = 'geral',
  });

  factory ItemLojaModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return ItemLojaModel(
      id: id ?? map['id'],
      nome: map['nome'] ?? '',
      custo: (map['custo'] as num?)?.toInt() ?? 0,
      assetUrl: map['assetUrl'],
      status: map['status'] ?? false,
      tipo: map['tipo'] ?? 'geral',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'custo': custo,
      'assetUrl': assetUrl,
      'status': status,
      'tipo': tipo,
    };
  }
}
