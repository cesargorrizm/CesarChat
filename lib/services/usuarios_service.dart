import 'package:flutter/cupertino.dart';
import 'package:proyectoappcesar/global/enviroments.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoappcesar/models/usuarios_response.dart';
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

}