// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class filterscreen extends StatefulWidget {
  const filterscreen({super.key});

  @override
  State<filterscreen> createState() => _filterscreenState();
}

class _filterscreenState extends State<filterscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 91, 171, 94), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 134, 182), width: 2))),
            ),
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 91, 171, 94), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 134, 182), width: 2))),
            ),
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 91, 171, 94), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 134, 182), width: 2))),
            ),
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 91, 171, 94), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 134, 182), width: 2))),
            ),
            TextFormField(
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 91, 171, 94), width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromARGB(255, 29, 134, 182), width: 2))),
            ),
          ],
        ),
      ),
    );
  }
}
