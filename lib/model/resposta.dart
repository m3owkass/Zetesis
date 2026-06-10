import 'dart:ffi';

import 'package:zetesis/model/tema.dart';

class RespostaModal {
  final String? id;
  final String texto;
  final Bool isCorrect;
  final String tarefa;


  const RespostaModal({this.id, required this.texto, required this.isCorrect, required this.tarefa});

  factory RespostaModal.fromMap(Map<String, dynamic> map, {String? id}) =>
      RespostaModal(
        id: id ?? map['id'],
        texto: map['texto'] ?? '',
        tarefa:map['tarefa'],
        isCorrect: map['isCorrect']?? false,
      );

  Map<String, dynamic> toMap(){
    return{
      'texto': texto,
      'isCorrect':isCorrect,
      'tarefa':tarefa
    };
  }
}
