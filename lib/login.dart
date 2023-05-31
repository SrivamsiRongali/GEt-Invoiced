// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_constructors, non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoiced/databasehelper.dart';
import 'package:invoiced/home.dart';
import 'package:invoiced/pojoclass.dart';
import 'package:invoiced/registeration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  void initState() {
    super.initState();
    initDynamicLinks();
  }

  flow() async {
    var flow = await DatabaseHelper.instance.getbookkeepermodel();
    if (flow[0]['flow'] == 1) {
      Get.offAll(homeScreen());
    }
  }

  loginapi(
    String email,
    String password,
  ) async {
    var data = json.encode({"email": email, "password": password});
    Map mapresponse;
    print("Login initiated");
    http.Response response = await http.post(
        Uri.parse("http://192.168.0.101:8082/login"),
        headers: {"accept": "*/*", "Content-Type": "application/json"},
        body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);
      if (mapresponse['status'] == "Failed") {
        Get.defaultDialog(
            title: "",
            titlePadding: EdgeInsets.only(top: 10),
            content: Text("Please provide valid email and password"),
            actions: [
              MaterialButton(
                color: Color.fromARGB(255, 91, 171, 94),
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
        print(response.body);
        var result = await DatabaseHelper.instance.add(BookKeeperModel(
            userid: (mapresponse['userId']),
            flow: 1,
            appToken: mapresponse['token'],
            userFirstName: "",
            userMiddleName: "",
            userLastName: "",
            userEmailAddress: "",
            userMobileNumber: "",
            profileImage: "",
            gender: "",
            rolename: "Book Keeper"));
        print("result=$result");
        print("mapresponse=${mapresponse['userId']}");
        print("login successful");
        Get.to(homeScreen());
      }
    } else {
      print("login failed");
    }
  }

  // Future<void> initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData? dynamicLink) async {
  //     final Uri? deepLink = dynamicLink?.link;
  //     if (deepLink != null) {
  //       // Handle the deep link here, e.g., navigate to a specific screen
  //       print('Received dynamic link: $deepLink');
  //     }
  //   }, onError: (e) async {
  //     print('Dynamic Link Failed: ${e.message}');
  //   });

  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri? deepLink = data?.link;
  //   if (deepLink != null) {
  //     // Handle the deep link here, e.g., navigate to a specific screen
  //     print('Received initial dynamic link: $deepLink');
  //   }
  // }

  // Rest of your app's code

  TextEditingController emailctrl = TextEditingController();
  TextEditingController passwordctrl = TextEditingController();

  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  void initDynamicLinks() async {
    final PendingDynamicLinkData? initallink =
        await FirebaseDynamicLinks.instance.getInitialLink();
    // dynamicLinks.onLink.listen((dynamicLinkdata) {});

    if (initallink != null) {
      final Uri dynamiclink = initallink.link;
      List<String> sepreatedLink = [];

      /// osama.link.page/Hellow --> osama.link.page and Hellow
      sepreatedLink.addAll(dynamiclink.path.split('/'));
      print("The Token that i'm interesed in is ${sepreatedLink[1]}");

      Get.to(registration_Screen());
    } else {
      flow();
    }
  }

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
                      Fields("Email", false, emailctrl),
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
                                onPressed: () {
                                  Get.defaultDialog(
                                      title: "",
                                      titlePadding: EdgeInsets.only(top: 10),
                                      content: Text("Comming Soon"),
                                      actions: [
                                        MaterialButton(
                                          color:
                                              Color.fromARGB(255, 255, 123, 0),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            'OK',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ]);
                                },
                                child: Text(
                                  "Forgot your password?",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 29, 134, 182),
                                  ),
                                ))
                          ]),
                      Fields("Password", true, passwordctrl),
                      SizedBox(
                        height: 20,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (emailctrl.text.length == 0) {
                            Get.defaultDialog(
                                title: "",
                                titlePadding: EdgeInsets.only(top: 10),
                                content: Text(
                                    "Please fill all the Mandatory Fields"),
                                actions: [
                                  MaterialButton(
                                    color: Color.fromARGB(255, 91, 171, 94),
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
                                content: Text(
                                    "Please fill all the Mandatory Fields"),
                                actions: [
                                  MaterialButton(
                                    color: Color.fromARGB(255, 91, 171, 94),
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
                            loginapi(emailctrl.text, passwordctrl.text);
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
                                    color: Color.fromARGB(255, 91, 171, 94)),
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

  bool securetext = true;

  Fields(String label, bool ispassword, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: ispassword == true
          ? InputDecoration(
              hintText: label,
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
              hintText: label,
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
