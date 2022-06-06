import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/socket_service.dart';



class LoadingScreen extends StatefulWidget {

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Timer(const Duration(seconds: 4), () {
      checkLoginState(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Image.asset('assets/logo.png'),
          ),
          
        ],
      ),
    );
  }
}
Future checkLoginState(BuildContext context)async{
  final authService = Provider.of<AuthService>(context,listen: false);
  final socketService = Provider.of<SocketService>(context,listen: false );

  final autenticado = await authService.isLoggedIn();
  if (autenticado) {
    socketService.connect();
    // Navigator.pushReplacementNamed(context, 'usuarios');
    
    Navigator.pushReplacementNamed(context, 'usuarios');
  }else{

    Navigator.pushReplacementNamed(context, 'login');
  }

}
