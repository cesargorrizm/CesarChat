import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(BuildContext context, String titulo, String subtitulo) {
  if (!Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                MaterialButton(
                    child: Text('Ok'),
                    textColor: Colors.blue,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  } else {
    return showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text(titulo),
              content: Text(subtitulo),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                    child: Text('Ok'),
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }
}
