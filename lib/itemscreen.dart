// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'databasehelper.dart';

class items extends StatefulWidget {
  const items({super.key});

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  void initState() {
    super.initState();
    _itemapi();
  }

  List? itemlistresponse;

  Future _itemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/items"),
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
      itemlistresponse = mapresponse['message'];
      if (itemlistresponse == []) {
        print("vendor response is null");
        setState(() {
          itemlistresponse = [];
        });
      } else {
        setState(() {
          itemlistresponse = mapresponse['message'];
        });
      }

      print("itemlistresponse= ${itemlistresponse}");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Items"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
        ),
        body: Container(
          child: ListView.builder(
              itemCount:
                  itemlistresponse == null ? 1 : itemlistresponse!.length,
              itemBuilder: (context, index) {
                return itemlistresponse == null
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
                                    itemnamectrl.text = itemlistresponse == null
                                        ? ""
                                        : itemlistresponse![index]
                                                    ['itemName'] ==
                                                null
                                            ? ""
                                            : itemlistresponse![index]
                                                ['itemName'];
                                    itemdescriptionctrl.text =
                                        itemlistresponse == null
                                            ? ""
                                            : itemlistresponse![index]
                                                        ['itemDescription'] ==
                                                    null
                                                ? ""
                                                : itemlistresponse![index]
                                                    ['itemDescription'];
                                    unitctrl.text = itemlistresponse == null
                                        ? ""
                                        : itemlistresponse![index]
                                                    ['itemUnit'] ==
                                                null
                                            ? ""
                                            : itemlistresponse![index]
                                                ['itemUnit'];
                                    Get.defaultDialog(
                                        title: "Edit",
                                        content: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, bottom: 10),
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                controller: itemnamectrl,
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 29, 134, 182),
                                                    )),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 216, 216, 216),
                                                    ))),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: itemdescriptionctrl,
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 29, 134, 182),
                                                    )),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 216, 216, 216),
                                                    ))),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              TextFormField(
                                                controller: itemdescriptionctrl,
                                                decoration: InputDecoration(
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                      color: Color.fromARGB(
                                                          255, 29, 134, 182),
                                                    )),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
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
                                                left: 10,
                                                right: 10,
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
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
                                                          "Discard",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    updateitemapi(
                                                        itemnamectrl,
                                                        itemdescriptionctrl,
                                                        unitctrl,
                                                        itemlistresponse![index]
                                                            ['itemId']);
                                                  },
                                                  color: Color.fromARGB(
                                                      255, 91, 171, 94),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          "Edit",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
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
                                  child: Text(
                                      itemlistresponse![index]['itemName']))),
                        ),
                      );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 91, 171, 94),
            onPressed: () async {
              Get.defaultDialog(
                  title: "ADD",
                  content: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: itemnamectrl,
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
                          controller: itemdescriptionctrl,
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
                          controller: itemdescriptionctrl,
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
                              additemapi(
                                  itemnamectrl, itemdescriptionctrl, unitctrl);
                            },
                            color: Color.fromARGB(255, 91, 171, 94),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Save",
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

  TextEditingController itemnamectrl = TextEditingController();
  TextEditingController itemdescriptionctrl = TextEditingController();
  TextEditingController unitctrl = TextEditingController();
  updateitemapi(
      TextEditingController itemnamectrl,
      TextEditingController itemdescriptionctrl,
      TextEditingController unitctrl,
      int itemid) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "itemName": itemnamectrl.text,
      "itemDescription": itemdescriptionctrl.text,
      "itemUnit": unitctrl.text,
      "itemQuantityValue": 0,
      "itemStatus": "active",
      "itemUpdatedOn": "",
      "itemUpdatedBy": ""
    });
    Map mapresponse;

    http.Response response =
        await http.put(Uri.parse("http://192.168.0.101:8082/item/$itemid"),
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

  additemapi(
    TextEditingController itemnamectrl,
    TextEditingController itemdescriptionctrl,
    TextEditingController unitctrl,
  ) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "itemName": itemnamectrl.text,
      "itemDescription": itemdescriptionctrl.text,
      "itemUnit": unitctrl.text,
      "itemQuantityValue": 0,
      "itemStatus": "active",
      "itemUpdatedOn": "2023-05-20",
      "itemUpdatedBy": "John Doe"
    });
    Map mapresponse;

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/item"),
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
