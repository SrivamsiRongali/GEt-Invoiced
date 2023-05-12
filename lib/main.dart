// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:invoiced/add-Invoice.dart';

import 'package:invoiced/home.dart';
import 'package:invoiced/login.dart';
import 'package:invoiced/profile.dart';
import 'package:invoiced/registeration.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginScreen(),
    );
  }
}
