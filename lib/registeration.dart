// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'login.dart';

class registration_Screen extends StatefulWidget {
  const registration_Screen({super.key});

  @override
  State<registration_Screen> createState() => _registration_ScreenState();
}

class _registration_ScreenState extends State<registration_Screen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formkey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    label("Organization-ID"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Organization-ID"),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        label("First Name"),
                        SizedBox(
                          height: 5,
                        ),
                        Fields("First Name"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        label("Last Name"),
                        SizedBox(
                          height: 5,
                        ),
                        Fields("Last Name"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    label("Email"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Email"),
                    SizedBox(
                      height: 10,
                    ),
                    label("Mobile Number"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Mobile Number"),
                    SizedBox(
                      height: 10,
                    ),
                    label("Password"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Password"),
                    SizedBox(
                      height: 10,
                    ),
                    label("Confirm Password"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Confirm Password"),
                    SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Get.to(loginScreen());
                      },
                      height: screensize.height * 0.065,
                      color: Color.fromARGB(255, 91, 171, 94),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  label(String label) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Text(
        "$label",
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      Text(
        "*",
        style: TextStyle(color: Colors.red),
      )
    ]);
  }

  Fields(String hinttext) {
    return TextFormField(
      decoration: InputDecoration(
          hintText: hinttext,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromARGB(255, 29, 134, 182),
          )),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Color.fromARGB(255, 216, 216, 216),
          ))),
    );
  }
}
