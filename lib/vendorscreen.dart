// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'databasehelper.dart';

class vendorsScreen extends StatefulWidget {
  const vendorsScreen({super.key});

  @override
  State<vendorsScreen> createState() => _vendorsScreenState();
}

class _vendorsScreenState extends State<vendorsScreen> {
  @override
  void initState() {
    super.initState();
    _vendorapi();
  }

  List? vendorslistresponse;

  Future _vendorapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/vendors"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      vendorslistresponse = mapresponse['message'];
      if (vendorslistresponse == []) {
        print("vendor response is null");
        setState(() {
          vendorslistresponse = [];
        });
      } else {
        setState(() {
          vendorslistresponse = mapresponse['message'];
        });
      }

      print("vendorslistresponse= ${vendorslistresponse}");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Vendors"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
        ),
        body: Container(
            child: ListView.builder(
                itemCount: vendorslistresponse == null
                    ? 1
                    : vendorslistresponse!.length,
                itemBuilder: (context, index) {
                  return vendorslistresponse == null
                      ? Container(
                          child: Center(child: CircularProgressIndicator()),
                          height: 300,
                        )
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Center(
                                child: TextButton(
                              onPressed: () async {
                                editvendornamectrl.text = vendorslistresponse ==
                                        null
                                    ? ""
                                    : vendorslistresponse![index]['vendorName'];
                                editvendordescriptionctrl.text =
                                    vendorslistresponse == null
                                        ? ""
                                        : vendorslistresponse![index]
                                            ['vendorDescription'];
                                Get.defaultDialog(
                                    title: "Edit",
                                    content: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10, bottom: 10),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: editvendornamectrl,
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 29, 134, 182),
                                                )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 216, 216, 216),
                                                ))),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller:
                                                editvendordescriptionctrl,
                                            decoration: InputDecoration(
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 29, 134, 182),
                                                )),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 216, 216, 216),
                                                ))),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                editvendornamectrl.clear();
                                                editvendordescriptionctrl
                                                    .clear();
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
                                                      "Discard",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () {
                                                print("vendor edites");
                                                updatevendorapi(
                                                    editvendornamectrl,
                                                    editvendordescriptionctrl,
                                                    vendorslistresponse![index]
                                                        ['vendorId']);
                                              },
                                              color: Color.fromARGB(
                                                  255, 91, 171, 94),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Edit",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ]);
                                this.setState(() {});
                              },
                              child: Text(
                                  vendorslistresponse![index]['vendorName']),
                            )),
                          ),
                        );
                })),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 91, 171, 94),
            onPressed: () async {
              Get.defaultDialog(
                  title: "Add",
                  content: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: addvendornamectrl,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 29, 134, 182),
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 216, 216, 216),
                              ))),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: addvendordescriptionctrl,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 29, 134, 182),
                              )),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: Color.fromARGB(255, 216, 216, 216),
                              ))),
                        )
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              addvendornamectrl.clear();
                              addvendordescriptionctrl.clear();
                              Get.back();
                            },
                            color: Color.fromARGB(255, 91, 171, 94),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Discard",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              addvendorapi(
                                  addvendornamectrl, addvendordescriptionctrl);
                            },
                            color: Color.fromARGB(255, 91, 171, 94),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Edit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ]);
            },
            icon: Icon(Icons.add),
            label: Text("Add")));
  }

  TextEditingController editvendornamectrl = TextEditingController();
  TextEditingController editvendordescriptionctrl = TextEditingController();
  updatevendorapi(TextEditingController editvendornamectrl,
      TextEditingController editvendordescriptionctrl, int vendorid) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "vendorName": editvendornamectrl.text,
      "vendorDescription": editvendordescriptionctrl.text,
      "vendorStatus": "draft",
      "vendorCreatedOn": "",
      "vendorCreatedBy": ""
    });
    print("api is hit");
    Map mapresponse;

    http.Response response =
        await http.put(Uri.parse("http://192.168.0.101:8082/vendor/$vendorid"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${token[0]["appToken"]}"
            },
            body: data);
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
      mapresponse = json.decode(response.body);
      Get.back();
      this.setState(() {});
    } else {
      print("login failed");
    }
  }

  TextEditingController addvendornamectrl = TextEditingController();
  TextEditingController addvendordescriptionctrl = TextEditingController();

  addvendorapi(TextEditingController addvendornamectrl,
      TextEditingController addvendordescriptionctrl) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "vendorName": addvendornamectrl.text,
      "vendorDescription": addvendordescriptionctrl.text,
      "vendorStatus": "draft",
      "vendorCreatedOn": "",
      "vendorCreatedBy": ""
    });
    Map mapresponse;

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/vendor"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${token[0]["appToken"]}"
            },
            body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);
      print(response.body);
      Get.back();
      this.setState(() {});
    } else {
      print("login failed");
    }
  }
}
