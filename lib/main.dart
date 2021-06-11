import 'package:flutter/material.dart';
import 'package:transcribe/pages/home.dart';
import 'package:transcribe/pages/sttpage.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => Home(),
      '/STTpage': (context) => STTPage(),
    },
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      accentColor: Colors.blue[600],
    ),
  ));
}
