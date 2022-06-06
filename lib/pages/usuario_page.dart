import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/global/enviroments.dart';
import 'package:proyectoappcesar/models/usuario.dart';
import 'package:proyectoappcesar/pages/meeting_page.dart';
import 'package:proyectoappcesar/services/auth_service.dart';
import 'package:proyectoappcesar/services/chat_service.dart';
import 'package:proyectoappcesar/services/usuarios_service.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

import '../Utils/toast.dart';
import '../models/notificacionLlamada.dart';
import '../services/socket_service.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  List<Usuario> usuarios = [];
  //Refresh controller
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuarioService = UsuariosService();
  late SocketService socketService;

  @override
  void initState() {
    socketService = Provider.of<SocketService>(context, listen: false);
    _cargarUsuarios();
    socketService.socket.on('videollamada-personal', _ecucharNotificacion);
    super.initState();
  }
  
  void _ecucharNotificacion(dynamic data){
    NotificacionLlamada notificacion = NotificacionLlamada(
      desde: data['desde'],
      para: data['para'],
      codigoLlamada: data['codigollamada']);
    
      notificacionVideollamada(notificacion); 
  }
  @override
  Widget build( context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.usuario.nombre,
          style: TextStyle(color: Colors.blue),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon:const Icon(
            Icons.exit_to_app,
            color: Colors.blue,
          ),
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.delete();
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: SmartRefresher(
        enablePullDown: true,
        controller: _refreshController,
        header: WaterDropHeader(
          complete: Icon(Icons.check),
        ),
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed:()async{ unirseLLAmanda();},
      ),
    );
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioListTile(Usuario usuario) {
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

  _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    //  await Future.delayed(Duration(milliseconds: 1000));
    if (mounted) {
      setState(() {});
    }
    _refreshController.refreshCompleted();
  }

  Future unirseLLAmanda() async {
    final textController = new TextEditingController();
    final authService = Provider.of<AuthService>(context,listen: false);
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text('Codigo de la sala'),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                  child: Text('Unisirse'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () async {
                      if (textController.text.length<=0) {
                        toastMsg("Introduce el codigo");
                        return;
                      }
                      if (await validateMeeting(textController.text)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingScreen(
                              meetingId: textController.text,
                              token: Enviroments.AUTH_TOKEN,
                              displayName: authService.usuario.nombre,
                            ),
                          ),
                        );
                      } else {
                        toastMsg("Codigo invalido de sala");
                      }
                    },
                  
                ),
                MaterialButton(
                  child: Text('Cancelar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text('Codigo de la sala'),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Unirse'),
                  isDefaultAction: true,
                  onPressed: null,
                ),
                CupertinoDialogAction(
                  child: Text('Cancelar'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
     Future<bool> validateMeeting(String _meetingId) async {
    final String? _VIDEOSDK_API_ENDPOINT = Enviroments.VIDEOSDK_API;

    final Uri validateMeetingUrl =
        Uri.parse('$_VIDEOSDK_API_ENDPOINT/meetings/$_meetingId');
    final http.Response validateMeetingResponse =
        await http.post(validateMeetingUrl, headers: {
      "Authorization": Enviroments.AUTH_TOKEN,
    });

    return validateMeetingResponse.statusCode == 200;
  }
Future notificacionVideollamada(NotificacionLlamada notificacionLlamada) async {

    final authService = Provider.of<AuthService>(context,listen: false);
    final nombre = notificacionLlamada.desde;
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text(' Te ha invitado a una videoLLamada $nombre'),

              actions: <Widget>[
                MaterialButton(
                  child: Text('Unisirse'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () async {
    
                      if (await validateMeeting(notificacionLlamada.codigoLlamada)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MeetingScreen(
                              meetingId: notificacionLlamada.codigoLlamada,
                              token: Enviroments.AUTH_TOKEN,
                              displayName: authService.usuario.nombre,
                            ),
                          ),
                        );
                      } else {
                        toastMsg("Codigo invalido de sala");
                      }
                    },
                  
                ),
                MaterialButton(
                  child: Text('Cancelar'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
      return showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: Text(' Te ha invitado a una videoLLamada $nombre'),
              
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text('Unirse'),
                  isDefaultAction: true,
                  onPressed: null,
                ),
                CupertinoDialogAction(
                  child: Text('Cancelar'),
                  isDefaultAction: true,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            );
          });
    }
  }

