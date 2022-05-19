import 'package:flutter/material.dart';

class LabelLogin extends StatelessWidget {
  final String ruta;
  final String textolink;
  final String texto;
  const LabelLogin({Key? key,required this.ruta,required this.texto,required this.textolink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>  [
          Text(texto,
          style: TextStyle(color: Colors.black54, fontSize: 15,fontWeight: FontWeight.w300),),
          SizedBox(height: 10,),
          GestureDetector(
            child: Text(textolink, style:  TextStyle(color: Colors.blue,fontSize: 18,fontWeight: FontWeight.bold),),
            onTap: (){
              Navigator.pushReplacementNamed(context, ruta);
            },
            )

        ],
        
      ),
    );
  }
}