import 'package:flutter/cupertino.dart';
import 'package:proyectoappcesar/models/mensajes_response.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoappcesar/services/auth_service.dart';

import '../global/enviroments.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;

  Future getChat(String usuarioId) async {
     String? token = await AuthService.getToken();
    final uri = Uri.parse('${Enviroments.apiUrl}/mensajes/$usuarioId');
    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token':token.toString()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);


    return mensajesResp.mensajes;
  }
}
