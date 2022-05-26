import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:proyectoappcesar/global/enviroments.dart';
import 'package:proyectoappcesar/models/login_response.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;
  bool _autenticando = false;
  //crear instancia privada del storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;

  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //getters del token de forma estatica
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> delete() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    //Preparamos lo que vamos a mandar
    final data = {'email': email, 'password': password};
    final uri = Uri.parse('${Enviroments.apiUrl}/login');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    //validamos que la respuesta es correcta
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      await this._guardarToken(loginResponse.token);
      autenticando = false;
      
      return true;
    }
    autenticando = false;
    return false;
  }

  Future register(String email, String password, String nombre) async {
    final data = {'email': email, 'password': password, 'nombre': nombre};
    final uri = Uri.parse('${Enviroments.apiUrl}/login/new');
    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    //validamos que la respuesta es correcta
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      this.usuario = registerResponse.usuario;
      await this._guardarToken(registerResponse.token);
      autenticando = false;
      
      return true;
    }
    autenticando = false;
    final resBody = jsonDecode(resp.body);
    return resBody['msg'];
  }



  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    if (token== null) {
      return false;
    }
    final uri = Uri.parse('${Enviroments.apiUrl}/login/renew');
    final resp = await http.get(uri,
        headers: {'Content-Type': 'application/json', 'x-token': token});
    //validamos que la respuesta es correcta
    if (resp.statusCode == 200) {
      final registerResponse = loginResponseFromJson(resp.body);
      usuario = registerResponse.usuario;
      
      await _guardarToken(registerResponse.token);
      autenticando = false;
     
      return true;
    }else{ 
    logout();
    autenticando = false;

    return false;

    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
