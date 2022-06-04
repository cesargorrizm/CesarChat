import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/models/mensajes_response.dart';
import 'package:proyectoappcesar/services/auth_service.dart';
import 'package:proyectoappcesar/services/socket_service.dart';
import 'package:proyectoappcesar/widgets/chat_message.dart';

import '../services/chat_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> _messages = [];
  @override
  void initState() {
    super.initState();
    chatService =  Provider.of<ChatService>(context, listen: false);
    socketService =  Provider.of<SocketService>(context, listen: false);
    authService =  Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarMensajes(chatService.usuarioPara.uid);
  }
  void _escucharMensaje(dynamic data){
    ChatMessage message = ChatMessage(
      texto: data['mensaje'], 
      uid: data['de'],
      animationController: AnimationController(vsync: this,duration:Duration(milliseconds: 300) ));
      setState(() {
        _messages.insert(0, message);
      });
      message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Column(
            children:  <Widget>[
              CircleAvatar(
                child: Text(
                  usuarioPara.nombre.substring(0,2),
                  style: TextStyle(fontSize: 12),
                ),
                backgroundColor: Colors.blue,
                maxRadius: 14,
              ),
              SizedBox(
                height: 3,
              ),
              Text(
               usuarioPara.nombre,
                style: TextStyle(color: Colors.blue, fontSize: 12),
              )
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            //Todo Caja de texto
            Container(
              color: Colors.white,
              height: 100,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (String texto) {
                setState(() {
                  if (texto.trim().length > 0) {
                    _estaEscribiendo = true;
                  } else {
                    _estaEscribiendo = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Enviar Mensaje'),
              focusNode: _focusNode,
            ),
          ),
          //boton de enviar
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    print(texto);
    if (texto.trim().length > 0) {
      _textController.clear();
      _focusNode.requestFocus();
      final newMessage = ChatMessage(
        texto: texto,
        uid: authService.usuario.uid ,
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 800),
        ),
      );
      _messages.insert(0, newMessage);
      newMessage.animationController.forward();
      setState(() {
        _estaEscribiendo = false;
      });
      socketService.emit('mensaje-personal',{
        'de':authService.usuario.uid,
        'para':chatService.usuarioPara.uid,
        'mensaje':texto
      });
    }
  }
  @override
  void dispose() {
    //Todo Off del socket

    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _cargarMensajes(String uid)async {
    List<Mensaje>chat = await chatService.getChat(uid);
    final history = chat.map((e) => ChatMessage(
      texto: e.mensaje,
       uid: e.de,
      animationController:  AnimationController(vsync: this,duration:Duration(milliseconds: 0) )..forward()));

      setState(() {
        _messages.insertAll(0, history);
      });
  }
}
