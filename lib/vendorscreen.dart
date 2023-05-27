import 'package:flutter/material.dart';

class vendorsScreen extends StatefulWidget {
  const vendorsScreen({super.key});

  @override
  State<vendorsScreen> createState() => _vendorsScreenState();
}

class _vendorsScreenState extends State<vendorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vendors"),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
      ),
      body: Container(),
    );
  }
}
