
   
import 'package:flutter/material.dart';
import 'package:proyectoappcesar/global/enviroments.dart';
import 'package:proyectoappcesar/services/auth_service.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
 late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;


  SocketService(){
    this.connect();
  }

  void connect() async{
    //obtener el token
    final token =await AuthService.getToken();
    
    // Dart client
    this._socket = IO.io(Enviroments.soketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew':true,
      'extraHeaders':{
        'x-token':token
      }
    });

    this._socket.on('connect', (_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.on('disconnect', (_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

  }
  void disconnect(){
    this._socket.disconnect();
  }

}