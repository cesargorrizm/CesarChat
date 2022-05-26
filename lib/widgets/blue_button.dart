import 'package:flutter/material.dart';
 
class BlueButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;
 
  const BlueButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          primary: Colors.blue,
          shape: const StadiumBorder(),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}