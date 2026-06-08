import 'dart:ffi';

import 'package:zetesis/model/tema.dart';

class RespostaModal {
  final String? id;
  final String texto;
  final Bool isCorrect;


  const RespostaModal({this.id, required this.texto, required this.isCorrect});

  factory RespostaModal.fromMap(Map<String, dynamic> map, {String? id}) =>
      RespostaModal(
        id: id ?? map['id'],
        texto: map['texto'] ?? '',
        isCorrect: map['isCorrect']?? false,
      );

  Map<String, dynamic> toMap(){
    return{
      'texto': texto,
      'isCorrect':isCorrect
    };
  }
}
