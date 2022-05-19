import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
   CustomInput({Key? key, 
  required this.icon,required this.placeholder,
  required this.textController,
  this.keyboardtype =TextInputType.text,
  this.ispassword=false}) : super(key: key);


  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardtype;
  final bool ispassword;

  @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 5,left: 5,right: 25,bottom: 5),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow:<BoxShadow> [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.05),
                  offset: Offset(0,5),
                  blurRadius: 5
                )
              ]
            ),
            child: TextField(
              obscureText: ispassword,
              controller: textController,
              autocorrect: false,
              keyboardType: keyboardtype,
              decoration: InputDecoration(
                prefixIcon: Icon(icon),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: placeholder,
              ),
            ),
          );
  }
}