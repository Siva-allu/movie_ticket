import 'package:flutter/material.dart';
import 'package:movie_ticket/adminhome.dart';
import 'package:movie_ticket/loginadmin.dart';
import 'package:movie_ticket/loginuser.dart';
import 'package:movie_ticket/userhome.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginUser(),
    );
  }
}
