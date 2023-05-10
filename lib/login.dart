// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors, non_constant_identifier_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoiced/home.dart';
import 'package:invoiced/registeration.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          height: screensize.height,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      "Images/Colorlogo-nobackground.png",
                      height: 100,
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.mail_outline),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "Email address",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Fields("Email"),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.lock_outline),
                                Text(
                                  "Password",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 49, 158, 248),
                                  ),
                                ))
                          ]),
                      Fields("Password"),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          Get.to(homeScreen());
                        },
                        height: screensize.height * 0.065,
                        color: Color.fromARGB(255, 49, 158, 248),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Login',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Text("Don't have an account?"),
                          TextButton(
                              onPressed: () {
                                Get.to(registration_Screen());
                              },
                              child: Text(
                                "Sign up now",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 49, 158, 248)),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Image.asset(
                      "Images/loginscreen_bottom_image.png",
                      height: screensize.height * 0.3,
                      width: screensize.width,
                      fit: BoxFit.fill,
                    )
                  ],
                ),
              ]),
        ),
      ),
    );
  }

  Fields(String label) {
    return TextFormField(
      decoration: InputDecoration(
          labelText: label,
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 49, 158, 248), width: 2)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 216, 216, 216), width: 2))),
    );
  }
}
