import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectoappcesar/helpers/mostrar_alerta.dart';
import 'package:proyectoappcesar/services/auth_service.dart';
import 'package:proyectoappcesar/services/socket_service.dart';
import 'package:proyectoappcesar/widgets/blue_button.dart';
import 'package:proyectoappcesar/widgets/custom_input.dart';
import 'package:proyectoappcesar/widgets/label.dart';
import 'package:proyectoappcesar/widgets/logo_app.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: <Widget>[
                  //logo de la aplicación
                  const Logo(
                    titulo: 'Logueo',
                  ),
                  _FormState(),
                  const LabelLogin(
                    ruta: 'register',
                    textolink: 'Crea una ahora!',
                    texto: 'No tienes cuenta???',
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _FormState extends StatefulWidget {
  _FormState({Key? key}) : super(key: key);

  @override
  State<_FormState> createState() => __FormStateState();
}

class __FormStateState extends State<_FormState> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final autService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context );
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardtype: TextInputType.emailAddress,
            textController: emailCtrl,
            ispassword: false,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardtype: TextInputType.text,
            textController: passCtrl,
            ispassword: true,
          ),
          //crear un boton
          BlueButton(
              text: 'Ingrese',
              onPressed: autService.autenticando
                  ? null
                  : ()async {
                      FocusScope.of(context).unfocus();
                     final loginOK =
                    await autService.login(emailCtrl.text.trim(), passCtrl.text.trim());
                      if (loginOK) {
                        socketService.connect();
                        Navigator.pushReplacementNamed(context, 'usuarios'); 
                      }else{
                         mostrarAlerta(context, 'Login incorrecto ', 'Revise sus credenciales nuevamente');
                      }
                    })
        ],
      ),
    );
  }
}
