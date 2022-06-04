import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/routes/routes.dart';
import 'package:proyectoappcesar/services/auth_service.dart';
import 'package:proyectoappcesar/services/chat_service.dart';
import 'package:proyectoappcesar/services/socket_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthService()),
        ChangeNotifierProvider(create: (_)=> SocketService()),
        ChangeNotifierProvider(create: (_)=> ChatService())
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}