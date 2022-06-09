import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:proyectoappcesar/global/enviroments.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoappcesar/models/usuarios_response.dart';
import 'package:proyectoappcesar/models/usuarios_search.dart';
import 'package:proyectoappcesar/services/auth_service.dart';

class UsuariosService with ChangeNotifier{

  Future<List<Usuario>>getUsuarios() async{
    String? token = await AuthService.getToken();
    try {
      final uri = Uri.parse('${Enviroments.apiUrl}/usuarios');
      
      final resp = await http.get(uri,
      headers:{
        'Content-Type':'application/json',
        'x-token': token.toString()
      } );

      final usuarioRespose = usuariosResponseFromJson(resp.body);

      return usuarioRespose.usuarios;
      
    } catch (e) {
      return[];
    }

  }

  Future<List<Usuario>> searchUsuario(String query)async{
    try {
      var parametros = {'email':query};
      final uri = Uri.parse('${Enviroments.apiUrl}/usuario/?email=$query');
      final resp = await http.get(uri);
      
      final usuariosResponse = usuariosSearchFromJson(resp.body);
      

      return usuariosResponse.usuarios;

    } catch (e) {
      
      return[];
    }

  }

}