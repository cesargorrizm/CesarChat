import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class UsuariosScreen extends StatefulWidget {

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final usuarios = [
    Usuario(
      online: true,
      email: 'test1@email.com',
      nombre: 'Maria',
      uid: '1'),
    Usuario(
      online: true,
      email: 'test2@email.com',
      nombre: 'Jesus',
      uid: '2'),
    Usuario(
      online: false,
      email: 'test2@email.com',
      nombre: 'Cesar',
      uid: '3'),
  ];
  //Refresh controller
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi nombre',style: TextStyle(color: Colors.blue),),
        elevation: 1,
        backgroundColor:Colors.white,
        leading: IconButton(
          icon: Icon(Icons.exit_to_app, color: Colors.blue,),
          onPressed: (){},
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            // child:Icon(Icons.check_circle, color: Colors.blue,) ,
            child:Icon(Icons.offline_bolt, color: Colors.red,) ,
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
      );
  }
   _cargarUsuarios()async{

     await Future.delayed(Duration(milliseconds: 1000));
     _refreshController.refreshCompleted();
     
   }
} 