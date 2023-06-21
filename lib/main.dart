import 'package:flutter/material.dart';
import 'Home/Home_Page.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Screen',
      home: HomePage(),
    );
  }
}
