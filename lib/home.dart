// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:invoiced/add-Invoice.dart';
import 'package:invoiced/edit_Non_GST_Invoice.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoiced/databasehelper.dart';
import 'package:invoiced/itemscreen.dart';
import 'package:invoiced/profile.dart';
import 'package:invoiced/vendorscreen.dart';

import 'edit_GST_invoice.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

late ValueNotifier<int> addGSTvendorid;
late ValueNotifier<int> addGSTitemid;
late ValueNotifier<int> addNonGSTvendorid;
late ValueNotifier<int> addNonGSTitemid;
late ValueNotifier<String> addGSTvendor;
late ValueNotifier<String> addGSTitem;
late ValueNotifier<String> addNon_GSTvendor;
late ValueNotifier<String> addNon_GSTitem;
late ValueNotifier<String> editGSTvendor;
late ValueNotifier<String> editGSTitem;

late ValueNotifier<int> editGSTvendorid;
late ValueNotifier<int> editGSTitemid;
late ValueNotifier<int> editNonGSTvendorid;
late ValueNotifier<int> editNonGSTitemid;
late ValueNotifier<String> editNon_GSTvendor;
late ValueNotifier<String> editNon_GSTitem;

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
    _modeofpaymentapi();
    editGSTvendorid = ValueNotifier<int>(0);
    editGSTitemid = ValueNotifier<int>(0);
    editGSTvendor = ValueNotifier<String>("");
    editGSTitem = ValueNotifier<String>("");
    addGSTvendorid = ValueNotifier<int>(0);
    addGSTitemid = ValueNotifier<int>(0);
    addNonGSTvendorid = ValueNotifier<int>(0);
    addNonGSTitemid = ValueNotifier<int>(0);
    addNon_GSTitem = ValueNotifier<String>("");
    addGSTvendor = ValueNotifier<String>("");
    addGSTitem = ValueNotifier<String>("");
    addNon_GSTvendor = ValueNotifier<String>("");
    editNonGSTvendorid = ValueNotifier<int>(0);
    editNonGSTitemid = ValueNotifier<int>(0);
    editNon_GSTvendor = ValueNotifier<String>("");
    editNon_GSTitem = ValueNotifier<String>("");
  }

  List? listresponse;
  Future _modeofpaymentapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("${token[0]["appToken"]}");
    var data = json.encode({
      "minGstAmountSpent": null,
      "maxGstAmountSpent": null,
      "firstDateOfBillCreated": "",
      "lastDateOfBillCreated": ""
    });
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/bills"),
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
      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Invoiced"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
          actions: [
            IconButton(
                onPressed: () {
                  Get.bottomSheet(
                    isScrollControlled: true,
                    elevation: 2,
                    ignoreSafeArea: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    barrierColor: Colors.transparent,
                    StatefulBuilder(
                      builder: (BuildContext context, setState) => Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                              padding:
                                  EdgeInsets.only(top: 50, left: 20, right: 20),
                              child: Column(
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Filter"),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                      Container(
                                        width: 150,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 29, 134, 182),
                                              )),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 216, 216, 216),
                                              ))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: OutlinedButton(
                                        child: Text(
                                          'Search Products',
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          primary:
                                              Color.fromARGB(255, 80, 40, 190),
                                        ),
                                        onPressed: () {},
                                      )),
                                ],
                              ))),
                    ),
                    isDismissible: true,
                  );
                },
                icon: Icon(Icons.filter_alt_outlined))
          ],
        ),
        drawer: Drawer(
          width: 220,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 220,
                    height: 100,
                    child: DrawerHeader(
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 29, 134, 182)),
                        child: Image.asset(
                          "Images/Colorlogo-nobackground-1.png",
                          height: 20,
                          width: 20,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.to(vendorsScreen());
                            },
                            child: Text(
                              "Vendors",
                              style: TextStyle(fontSize: 20),
                            )),
                        TextButton(
                            onPressed: () {
                              Get.to(items());
                            },
                            child:
                                Text("Items", style: TextStyle(fontSize: 20))),
                        TextButton(
                            onPressed: () {
                              Get.to(profilescreen());
                            },
                            child:
                                Text("Profile", style: TextStyle(fontSize: 20)))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Container(
          child: Center(child: home()),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Color.fromARGB(255, 91, 171, 94),
            onPressed: () async {
              await DatabaseHelper.instance.removeGSTmodeofpayment();
              await DatabaseHelper.instance.removenonGSTmodeofpayment();
              Get.to(addInvoiceScreen());
            },
            icon: Icon(Icons.add),
            label: Text("Add")));
  }

  home() {
    return ListView.builder(
        itemCount: listresponse == null ? 1 : listresponse!.length,
        itemBuilder: (context, index) {
          return listresponse == null
              ? Container(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${DateTime.fromMillisecondsSinceEpoch(listresponse![index]['billCreatedOn']).day}/${DateTime.fromMillisecondsSinceEpoch(listresponse![index]['billCreatedOn']).month}/${DateTime.fromMillisecondsSinceEpoch(listresponse![index]['billCreatedOn']).year}"),
                      ListTile(
                        onTap: () async {
                          await DatabaseHelper.instance
                              .removeGSTmodeofpayment();
                          await DatabaseHelper.instance
                              .removenonGSTmodeofpayment();
                          if (listresponse![index]['billType'].toString() ==
                              "gst") {
                            Get.to(editGSTInvoiceScreen(),
                                arguments: listresponse![index]['billId']);
                          } else {
                            Get.to(editNonGSTInvoiceScreen(),
                                arguments: listresponse![index]['billId']);
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(width: 2)),
                        title: Text(
                            "${listresponse![index]['vendorName']}-${listresponse![index]['itemName']}"),
                        trailing: Text(
                            "Amount=${listresponse![index]["amountSpent"]}"),
                      ),
                    ],
                  ),
                );
        });
  }
}
