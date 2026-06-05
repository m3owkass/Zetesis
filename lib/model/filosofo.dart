class FilosofoModel {
  final String? id;
  final String nome;

  const FilosofoModel({this.id, required this.nome});

  factory FilosofoModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      FilosofoModel(id: id ?? map['id'], nome: map['nome'] ?? '');

  Map<String, dynamic> toMap() => {'nome': nome};
}
