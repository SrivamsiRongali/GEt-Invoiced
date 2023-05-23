// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class registration_Screen extends StatefulWidget {
  const registration_Screen({super.key});

  @override
  State<registration_Screen> createState() => _registration_ScreenState();
}

class _registration_ScreenState extends State<registration_Screen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var data = Get.arguments;
  @override
  void initState() {
    super.initState();
    orgidctrl.text = data == null ? "" : data.toString();
  }

  registerapi(
      String organizationid,
      String firstname,
      String lastname,
      String email,
      String mobilenumber,
      String password,
      String confirmpassword) async {
    var data = json.encode({
      "firstName": firstname.toString(),
      "lastName": lastname.toString(),
      "email": email.toString(),
      "mobileNumber": mobilenumber.toString(),
      "designation": "bookKeeper",
      "organizationId": "1",
      "password": password.toString(),
      "confirmPassword": confirmpassword.toString()
    });
    Map mapresponse;
    print("register api");

    http.Response response = await http.post(
      Uri.parse("http://192.168.0.101:8082/register"),
      headers: {"accept": "*/*", "Content-Type": "application/json"},
      body: data,
    );
    print(response);
    if (response.statusCode == 200) {
      print(response.body);
      print("registration successful");
      Get.to(loginScreen());
    } else {
      print("Registration failed");
    }
  }

  TextEditingController orgidctrl = TextEditingController();
  TextEditingController fnamectrl = TextEditingController();
  TextEditingController lnamectrl = TextEditingController();
  TextEditingController mobilenumberctrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();
  TextEditingController confirmpasswordctrl = TextEditingController();

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
                    Fields("Organization-ID", orgidctrl, false),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        label("First Name"),
                        SizedBox(
                          height: 5,
                        ),
                        Fields("First Name", fnamectrl, false),
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
                        Fields("Last Name", lnamectrl, false),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    label("Email"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Email", emailctrl, false),
                    SizedBox(
                      height: 10,
                    ),
                    label("Mobile Number"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Mobile Number", mobilenumberctrl, false),
                    SizedBox(
                      height: 10,
                    ),
                    label("Password"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Password", passwordctrl, true),
                    SizedBox(
                      height: 10,
                    ),
                    label("Confirm Password"),
                    SizedBox(
                      height: 5,
                    ),
                    Fields("Confirm Password", confirmpasswordctrl, true),
                    SizedBox(
                      height: 25,
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (orgidctrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (fnamectrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (lnamectrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (emailctrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (passwordctrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (confirmpasswordctrl.text.length == 0) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content:
                                  Text("Please fill all the Mandatory Fields"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else if (confirmpasswordctrl.text !=
                            passwordctrl.text) {
                          Get.defaultDialog(
                              title: "",
                              titlePadding: EdgeInsets.only(top: 10),
                              content: Text("Please Re-check the Password"),
                              actions: [
                                MaterialButton(
                                  color: Color.fromARGB(255, 255, 123, 0),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'OK',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ]);
                        } else {
                          registerapi(
                              orgidctrl.text,
                              fnamectrl.text,
                              lnamectrl.text,
                              emailctrl.text,
                              mobilenumberctrl.text,
                              passwordctrl.text,
                              confirmpasswordctrl.text);
                        }
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

  bool securetext = true;

  Fields(String hinttext, TextEditingController controller, bool ispassword) {
    return TextFormField(
      controller: controller,
      decoration: ispassword == true
          ? InputDecoration(
              hintText: hinttext,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(255, 29, 134, 182),
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(255, 216, 216, 216),
              )),
              suffixIcon: IconButton(
                icon: Icon(securetext
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined),
                onPressed: () {
                  setState(() {
                    securetext = !securetext;
                  });
                },
                color: Colors.grey,
              ),
            )
          : InputDecoration(
              hintText: hinttext,
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(255, 29, 134, 182),
              )),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Color.fromARGB(255, 216, 216, 216),
              ))),
      obscureText: ispassword ? securetext : false,
    );
  }
}
