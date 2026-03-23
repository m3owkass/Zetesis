 import 'package:flutter/material.dart';

class UsuarioModel{
   String? email;
   String nome;
   String ranking;
   String senha;
   int pontos;
   Image avatar;
   bool admin;

  UsuarioModel({

    this.email,
    required this.nome,
    required this.ranking,
    required this.admin,
    required this.avatar,
    required this.pontos,
    required this.senha
  });
 }