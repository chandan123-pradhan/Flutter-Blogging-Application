import 'package:blogging/LoginRegisterPage.dart';
import 'package:flutter/material.dart';
import 'Mapping.dart';
import 'HomePage.dart';
import 'Authentication.dart';

void main() {
  runApp(new BlogApp());
}

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MappinPage(auth: Auth(),),
    );
  }
}

