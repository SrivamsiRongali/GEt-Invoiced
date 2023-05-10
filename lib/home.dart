// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:invoiced/add-Invoice.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Invoiced"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 49, 158, 248),
        ),
        body: Container(
          child: Column(
            children: [],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 49, 158, 248),
            onPressed: () {
              Get.to(addInvoiceScreen());
            },
            icon: Icon(Icons.add),
            label: Text("Add")));
  }
}
