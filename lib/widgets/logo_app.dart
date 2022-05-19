import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key,required this.titulo}) : super(key: key);
  final String titulo;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        width: 170,
        child: Column(
          children: <Widget>[
            Image(image: AssetImage('assets/tag-logo.png'),),
            Text(titulo,style:TextStyle(fontSize: 30) ,),
          ],
        ),
      ));
  }
}