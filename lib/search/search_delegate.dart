import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:proyectoappcesar/services/usuarios_service.dart';

import '../services/chat_service.dart';

class UserSearchDelegate extends SearchDelegate {
  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar usuario por email';

  @override
  List<Widget>? buildActions(BuildContext context) {
    
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
   
    return IconButton(
      onPressed: () {
        close(context, null);
      }
    ,icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Text('buildResults');
  }

    List<Usuario> usuarios = [];
  @override
  Widget buildSuggestions(BuildContext context) {
    
    if (query.isEmpty) {
      return Container(
        child:const Center(
          child: Icon(Icons.supervised_user_circle, color:  Colors.black38,),
        ),
      );
    }else{
    final usuariosService = Provider.of<UsuariosService>(context, listen: false);
    
    return FutureBuilder(
      future: usuariosService.searchUsuario(query),
      builder: (_,AsyncSnapshot<List<Usuario>> snapshot){
        if (!snapshot.hasData) 
         return Container(); 
        
        usuarios = snapshot.data!;
        return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i],context),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
      });
      }
      
  }

  ListTile _usuarioListTile(Usuario usuario, BuildContext context) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2).toUpperCase()),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushReplacementNamed(context, 'chat');
      },
    );
  }
  
}
