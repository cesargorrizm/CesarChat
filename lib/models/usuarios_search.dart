// To parse this JSON data, do
//
//     final usuariosSearch = usuariosSearchFromMap(jsonString);

import 'dart:convert';

import 'package:proyectoappcesar/models/usuario.dart';
UsuariosSearch usuariosSearchFromJson(String str) => UsuariosSearch.fromJson(json.decode(str));

String usuariosSearchToJson(UsuariosSearch data) => json.encode(data.toJson());

class UsuariosSearch {
    UsuariosSearch({
       required this.usuarios,
    });

    List<Usuario> usuarios;

    // factory UsuariosSearch.fromJson(String str) => UsuariosSearch.fromMap(json.decode(str));

    // String toJson() => json.encode(toMap());

    factory UsuariosSearch.fromJson(Map<String, dynamic> json) => UsuariosSearch(
        usuarios: List<Usuario>.from(json["usuarios"].map((x) => Usuario.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "usuarios": List<dynamic>.from(usuarios.map((x) => x.toJson())),
    };
}






 
