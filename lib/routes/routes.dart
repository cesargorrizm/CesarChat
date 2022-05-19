import 'package:flutter/cupertino.dart';
import 'package:proyectoappcesar/pages/chat_page.dart';
import 'package:proyectoappcesar/pages/loading_page.dart';
import 'package:proyectoappcesar/pages/login_page.dart';
import 'package:proyectoappcesar/pages/register_page.dart';
import 'package:proyectoappcesar/pages/usuario_page.dart';

final Map<String,Widget Function(BuildContext)> appRoutes={
  'usuarios':(_)=>UsuariosScreen(),
  'chat':(_)=>ChatScreen(),
  'login':(_)=>LoginScreen(),
  'register':(_)=>RegisterScreen(),
  'loading':(_)=>LoadingScreen(),
};