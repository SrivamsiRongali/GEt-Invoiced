// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_if_null_operators, unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'databasehelper.dart';
import 'home.dart';

class items extends StatefulWidget {
  const items({super.key});

  @override
  State<items> createState() => _itemsState();
}

class _itemsState extends State<items> {
  @override
  void initState() {
    super.initState();
    itemlist = _itemapi();
  }

  Future? itemlist;
  List? itemlistresponse;
  TextEditingController itemctrl = TextEditingController();
  Future _itemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("item api request is sent");

    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchItem?itemName=${itemctrl.text}"),
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

      setState(() {
        itemlistresponse = mapresponse['message'];
      });

      print("itemlistresponse= ${itemlistresponse}");
      return itemlistresponse;
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  var val = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Items"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: itemlist,
            builder: (context, snapshot) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: itemctrl,
                    onChanged: (Value) {
                      setState(() {
                        itemlist = _itemapi();
                      });
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_outlined),
                        hintText: "Search",
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
                ),
                Container(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: itemlistresponse == null
                          ? 1
                          : itemlistresponse!.length,
                      itemBuilder: (context, index) {
                        return itemlistresponse == null
                            ? Container(
                                child:
                                    Center(child: CircularProgressIndicator()),
                                height: 300,
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            val[0] == true
                                                ? val[1] == true
                                                    ? addGSTitemid.value =
                                                        itemlistresponse![index]
                                                            ['itemId']
                                                    : addNonGSTitemid.value =
                                                        itemlistresponse![index]
                                                            ['itemId']
                                                : val[1] == true
                                                    ? editGSTitemid.value =
                                                        itemlistresponse![index]
                                                            ['itemId']
                                                    : editNonGSTitemid.value =
                                                        itemlistresponse![index]
                                                            ['itemId'];
                                            val[0] == true
                                                ? val[1] == true
                                                    ? addGSTitem.value =
                                                        itemlistresponse![index]
                                                            ['itemName']
                                                    : addNon_GSTitem.value =
                                                        itemlistresponse![index]
                                                            ['itemName']
                                                : val[1] == true
                                                    ? editGSTitem.value =
                                                        itemlistresponse![index]
                                                            ['itemName']
                                                    : editNon_GSTitem.value =
                                                        itemlistresponse![index]
                                                                ['itemName']
                                                            .toString();
                                            print(editNon_GSTvendor.value);
                                            print(
                                                "${editGSTvendorid.value}${itemlistresponse![index]['itemId']}");

                                            Get.back();
                                          },
                                          child: Text(itemlistresponse![index]
                                              ['itemName'])),
                                      Container(
                                        width: 100,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    itemlist = null;
                                                  });
                                                  edititemnamectrl
                                                      .text = itemlistresponse ==
                                                          null
                                                      ? ""
                                                      : itemlistresponse![index]
                                                                  [
                                                                  'itemName'] ==
                                                              null
                                                          ? ""
                                                          : itemlistresponse![
                                                                  index]
                                                              ['itemName'];
                                                  edititemdescriptionctrl
                                                      .text = itemlistresponse ==
                                                          null
                                                      ? ""
                                                      : itemlistresponse![index]
                                                                  [
                                                                  'itemDescription'] ==
                                                              null
                                                          ? ""
                                                          : itemlistresponse![
                                                                  index][
                                                              'itemDescription'];
                                                  editunitctrl
                                                      .text = itemlistresponse ==
                                                          null
                                                      ? ""
                                                      : itemlistresponse![index]
                                                                  [
                                                                  'itemUnit'] ==
                                                              null
                                                          ? ""
                                                          : itemlistresponse![
                                                                  index]
                                                              ['itemUnit'];
                                                  Get.defaultDialog(
                                                      title: "Edit",
                                                      content: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10,
                                                                bottom: 10),
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller:
                                                                  edititemnamectrl,
                                                              decoration: InputDecoration(
                                                                  label: Text("Item Name"),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            29,
                                                                            134,
                                                                            182),
                                                                  )),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216),
                                                                  ))),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  edititemdescriptionctrl,
                                                              decoration: InputDecoration(
                                                                  label: Text("Description"),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            29,
                                                                            134,
                                                                            182),
                                                                  )),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216),
                                                                  ))),
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextFormField(
                                                              controller:
                                                                  editunitctrl,
                                                              decoration: InputDecoration(
                                                                  label: Text("Unit"),
                                                                  focusedBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            29,
                                                                            134,
                                                                            182),
                                                                  )),
                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216),
                                                                  ))),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                  updateitemapi(
                                                                      edititemnamectrl,
                                                                      edititemdescriptionctrl,
                                                                      editunitctrl,
                                                                      itemlistresponse![
                                                                              index]
                                                                          [
                                                                          'itemId']);
                                                                },
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        91,
                                                                        171,
                                                                        94),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Save",
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
                                                                  edititemnamectrl
                                                                      .clear();
                                                                  edititemdescriptionctrl
                                                                      .clear();
                                                                  editunitctrl
                                                                      .clear();
                                                                  Get.back();
                                                                },
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        91,
                                                                        171,
                                                                        94),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Discard",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]);
                                                },
                                                icon: Icon(
                                                  Icons.edit_outlined,
                                                )),
                                            IconButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    itemlist = null;
                                                  });
                                                  Get.defaultDialog(
                                                      title: "",
                                                      content: Text(
                                                          "Are you sure you want to delete"),
                                                      actions: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 10),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              MaterialButton(
                                                                onPressed:
                                                                    () async {
                                                                  deleteitemapi(
                                                                      itemlistresponse![
                                                                              index]
                                                                          [
                                                                          'itemId']);
                                                                  this.setState(
                                                                      () {});
                                                                },
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        91,
                                                                        171,
                                                                        94),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "Yes",
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
                                                                  Get.back();
                                                                },
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        91,
                                                                        171,
                                                                        94),
                                                                child: Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Text(
                                                                        "No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]);
                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                ),
                              );
                      }),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 91, 171, 94),
            onPressed: () async {
              setState(() {
                itemlist = null;
              });
              Get.defaultDialog(
                  title: "ADD",
                  content: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: additemnamectrl,
                          decoration: InputDecoration(
                              label: Text("Item Name"),
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
                          controller: additemdescriptionctrl,
                          decoration: InputDecoration(
                              label: Text("Description"),
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
                          controller: addunitctrl,
                          decoration: InputDecoration(
                              label: Text("Unit"),
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
                              additemapi(additemnamectrl,
                                  additemdescriptionctrl, addunitctrl);
                              this.setState(() {});
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
                          ),
                          MaterialButton(
                            onPressed: () {
                              additemnamectrl.clear();
                              additemdescriptionctrl.clear();
                              addunitctrl.clear();
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
                        ],
                      ),
                    )
                  ]);
              this.setState(() {});
            },
            icon: Icon(Icons.add),
            label: Text("Add")));
  }

  TextEditingController edititemnamectrl = TextEditingController();
  TextEditingController edititemdescriptionctrl = TextEditingController();
  TextEditingController editunitctrl = TextEditingController();
  updateitemapi(
      TextEditingController edititemnamectrl,
      TextEditingController edititemdescriptionctrl,
      TextEditingController editunitctrl,
      int itemid) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "itemName": edititemnamectrl.text,
      "itemDescription": edititemdescriptionctrl.text,
      "itemUnit": editunitctrl.text,
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
      _itemapi();
      setState(() {});
    } else {
      print("edit failed");
    }
  }

  TextEditingController additemnamectrl = TextEditingController();
  TextEditingController additemdescriptionctrl = TextEditingController();
  TextEditingController addunitctrl = TextEditingController();
  additemapi(
    TextEditingController additemnamectrl,
    TextEditingController additemdescriptionctrl,
    TextEditingController addunitctrl,
  ) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "itemName": additemnamectrl.text,
      "itemDescription": additemdescriptionctrl.text,
      "itemUnit": addunitctrl.text,
      "itemQuantityValue": 0,
      "itemStatus": "active",
      "itemUpdatedOn": "",
      "itemUpdatedBy": ""
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
      _itemapi();
      this.setState(() {});
    } else {
      print("add failed");
    }
  }

  deleteitemapi(int itemid) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();

    Map mapresponse;
    print("delete request is sent");
    http.Response response = await http.delete(
      Uri.parse("http://192.168.0.101:8082/item/$itemid"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token[0]["appToken"]}"
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);
      _itemapi();
      print(response.body);
      this.setState(() {});
      Get.back();
    } else {
      print("delete failed");
    }
  }
}
