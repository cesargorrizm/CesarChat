import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';



class LoadingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {

          return  Center(
          child: Text('UsuariosScreen'),
           );
        },
       
      ),
   );
  }
}
Future checkLoginState(BuildContext context)async{
  final authService = Provider.of<AuthService>(context,listen: false);

  final autenticado = await authService.isLoggedIn();
  if (autenticado) {
    //todo conecta al socket server

    // Navigator.pushReplacementNamed(context, 'usuarios');
    
    Navigator.pushReplacementNamed(context, 'usuarios');
  }else{

    Navigator.pushReplacementNamed(context, 'login');
  }

}
