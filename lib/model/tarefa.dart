import 'package:zetesis/model/resposta.dart';
import 'package:zetesis/model/tema.dart';

class TarefaModel {
  final String? id;
  final String nome;
  final String descricao;
  final TemaModel tema;
  final List<RespostaModal> perguntas;

  const TarefaModel({this.id, required this.nome, required this.tema, required this.descricao, required this.perguntas});

  factory TarefaModel.fromMap(Map<String, dynamic> map, {String? id}) =>
      TarefaModel(
        id: id ?? map['id'],
        nome: map['nome'] ?? '',
        tema: map['tema'],
        descricao: map['descricao'] ??'',
        perguntas: map['pergutas']
      );

  Map<String, dynamic> toMap(){
    return{
      'nome':nome,
      'descricao':descricao,
      'tema':tema,
      'perguntas':perguntas
    };
  }
}
