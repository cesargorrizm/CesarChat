import 'package:flutter/material.dart';
import 'package:proyectoappcesar/widgets/blue_button.dart';
import 'package:proyectoappcesar/widgets/custom_input.dart';
import 'package:proyectoappcesar/widgets/label.dart';
import 'package:proyectoappcesar/widgets/logo_app.dart';


class RegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height*0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //logo de la aplicación
                Logo(titulo: 'Registro'),
                _FormState(),
                LabelLogin(ruta: 'login',texto: 'Ya tienes cuenta??',textolink: 'Logeate!!!',),

                  
                  
                
              ],
            ),
          ),
        ),
      )
   );
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
  final nombreCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            margin: EdgeInsets.only(top: 10),
      child: Column(
        children:<Widget>[
          
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardtype:TextInputType.text ,
            textController: nombreCtrl,
            ispassword: false,
            ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardtype:TextInputType.emailAddress ,
            textController: emailCtrl,
            ispassword: false,
            ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardtype:TextInputType.text ,
            textController: passCtrl,
            ispassword: true,
            ),
          //crear un boton
           BlueButton(text: 'Ingrese', onPressed: (){
             
           })
        ],
      ),
    );
  }
}


