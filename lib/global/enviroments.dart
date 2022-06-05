import 'dart:io';

import 'package:flutter/rendering.dart';

class Enviroments {
  
  static String apiUrl=Platform.isAndroid? 'http://192.168.1.28:3000/api': 'http://localhost:3000/api';
  static String soketUrl=Platform.isAndroid? 'http://192.168.1.28:3000': 'http://localhost:3000';
  static String AUTH_TOKEN ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI0Y2Y1ZDVmMi03YmQ4LTRlOGUtYmM1ZC04YWYxYTBlM2I1NTQiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTY1NDM1OTA2NywiZXhwIjoxNjU0OTYzODY3fQ.ptVV3pG3IX1DrzT5iUc4fdl9k6gJoMzo6DxWQLf4wlE';
  static String VIDEOSDK_API='https://api.videosdk.live/v1';
  static Color primaryColor = Color.fromRGBO(17, 120, 248, 1);
  static Color secondaryColor = Color.fromRGBO(33, 32, 50, 1);
  static Color hoverColor = Color.fromRGBO(51, 50, 68, 1);
}