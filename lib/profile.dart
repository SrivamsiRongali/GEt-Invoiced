// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'databasehelper.dart';

class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileapi();
  }

  bool enable = false;

  @override
  List? listresponse;
  Future _profileapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("${token[0]["appToken"]}");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/profile"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token[0]["appToken"]}"
        // "${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      setState(() {
        listresponse = mapresponse['message'];
      });
      firstnamectrl.text = listresponse![0]['firstName'];
      lastnamectrl.text = listresponse![0]['lastName'];
      emailctrl.text = listresponse![0]['email'];
      Mobilectrl.text = listresponse![0]['mobileNumber'].toString();
      designation.text = listresponse![0]['designation'];

      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  Future _updateprofileapi(String firstname, String lastname) async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({"firstName": firstname, "lastName": lastname});
    print("${token[0]["appToken"]}");
    response1 = await http.put(Uri.parse("http://192.168.0.101:8082/profile"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token[0]["appToken"]}"
          // "${token[0]["appToken"]}"
        },
        body: data);
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      Get.back();
      this.setState(() {});
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("My Profile"),
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  enable = !enable;
                });
              },
              icon: Icon(
                Icons.edit,
                color: enable == true
                    ? Color.fromARGB(255, 91, 171, 94)
                    : Colors.white,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: listresponse == null
            ? Container(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              )
            : Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("First name"),
                      fields(firstnamectrl, true, enable),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Last name"),
                      fields(lastnamectrl, true, enable),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Email"),
                      fields(emailctrl, true, false),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Mobile Number"),
                      fields(Mobilectrl, true, false),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Designation"),
                      fields(designation, true, false),
                      SizedBox(
                        height: 15,
                      ),
                      enable == true
                          ? MaterialButton(
                              onPressed: () async {
                                Get.defaultDialog(
                                    title: "",
                                    content: Text(
                                        "Are you sure you want save changes"),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MaterialButton(
                                              onPressed: () async {
                                                _updateprofileapi(
                                                    firstnamectrl.text,
                                                    lastnamectrl.text);
                                                this.setState(() {});
                                              },
                                              color: Color.fromARGB(
                                                  255, 91, 171, 94),
                                              child: Row(
                                                children: const [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              color: Color.fromARGB(
                                                  255, 91, 171, 94),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]);
                                this.setState(() {});
                              },
                              height: screensize.height * 0.065,
                              color: Color.fromARGB(255, 91, 171, 94),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  TextEditingController firstnamectrl = TextEditingController();
  TextEditingController lastnamectrl = TextEditingController();
  TextEditingController emailctrl = TextEditingController();
  TextEditingController Mobilectrl = TextEditingController();
  TextEditingController designation = TextEditingController();
  fields(TextEditingController controller, bool text, bool enable) {
    return Container(
      height: 50,
      child: TextFormField(
        enabled: enable,
        inputFormatters:
            text == true ? [] : [FilteringTextInputFormatter.digitsOnly],
        controller: controller,
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 216, 216, 216),
            )),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 216, 216, 216),
            )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
              width: 2,
              color: Color.fromARGB(255, 29, 134, 182),
            ))),
      ),
    );
  }
}
