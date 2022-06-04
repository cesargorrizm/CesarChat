import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:proyectoappcesar/services/auth_service.dart';
import 'package:proyectoappcesar/services/chat_service.dart';
import 'package:proyectoappcesar/services/usuarios_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../services/socket_service.dart';


class UsuariosScreen extends StatefulWidget {

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

   List<Usuario> usuarios = [];
  //Refresh controller
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  final usuarioService = UsuariosService();


  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context );
    return Scaffold(
      appBar: AppBar(
        title: Text(authService.usuario.nombre,style: TextStyle(color: Colors.blue),),
        elevation: 1,
        backgroundColor:Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.blue,),
          onPressed: (){
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.delete();

          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child:( socketService.serverStatus ==ServerStatus.Online)
            ?Icon(Icons.check_circle, color: Colors.blue,) :
            Icon(Icons.offline_bolt, color: Colors.red,) ,
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller:_refreshController ,
        header: WaterDropHeader(
          complete: Icon(Icons.check),
        ),
        onRefresh: _cargarUsuarios,
        child:_listViewUsuarios() ,)
   );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics:BouncingScrollPhysics() ,
      itemBuilder: (_,i)=>_usuarioListTile(usuarios[i]),
      separatorBuilder: (_,i)=>Divider(),
      itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
        title: Text(usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2).toUpperCase()),
        
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: (){
          final chatService = Provider.of<ChatService>(context, listen: false);
          chatService.usuarioPara = usuario;
          Navigator.pushReplacementNamed(context,'chat');
          
        },
      );
  }
   _cargarUsuarios()async{

     
    usuarios =await usuarioService.getUsuarios();
    //  await Future.delayed(Duration(milliseconds: 1000));
    setState(() {
      
    });
     _refreshController.refreshCompleted();
     
   }
} 