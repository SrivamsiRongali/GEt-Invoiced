import 'package:flutter/material.dart';

class items extends StatefulWidget {
  const items({super.key});

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Items"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
      ),
      body: Container(),
    );
  }
}
