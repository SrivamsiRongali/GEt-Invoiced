// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unnecessary_string_interpolations, unused_import

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
import 'package:invoiced/login.dart';
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

enum switchsearch { gst, nongst }

class _homeScreenState extends State<homeScreen> {
  @override
  void initState() {
    super.initState();
    amountrangevalue = ValueNotifier<RangeValues>(RangeValues(0, 100000));
    Nongstamountvalues = ValueNotifier<RangeValues>(RangeValues(0, 100000));
    gstamountvalues = ValueNotifier<RangeValues>(RangeValues(0, 100000));
    billslist = _getbillsapi();
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

  Future? billslist;
  List? listresponse;
  Future _getbillsapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("${token[0]["appToken"]}");
    var data = json.encode({
      "billType": "",
      "gstType": "",
      "rate": "",
      "minAmountSpent": "",
      "maxAmountSpent": "",
      "firstDateOfBills": "",
      "lastDateOfBills": ""
    });
    response1 = await http.put(Uri.parse("http://192.168.0.101:8082/bills"),
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
      setState(() {
        listresponse = mapresponse['message'];
      });
      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  DateTime firstdate = DateTime.now();
  DateTime lastdate = DateTime.now();

  TextEditingController firstdatectrl = TextEditingController();
  TextEditingController lastdatectrl = TextEditingController();
  TextEditingController minamountctrl = TextEditingController();
  TextEditingController maxamountctrl = TextEditingController();
  TextEditingController gstminamountctrl = TextEditingController();
  TextEditingController gstmaxamountctrl = TextEditingController();
  TextEditingController vendorctrl = TextEditingController();
  TextEditingController itemctrl = TextEditingController();
  late ValueNotifier<RangeValues> gstamountvalues;
  late ValueNotifier<RangeValues> amountrangevalue;
  Widget filtergst() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: gstminamountctrl,
                onChanged: (value) {
                  if (double.parse(gstminamountctrl.text) <
                      double.parse(gstmaxamountctrl.text)) {
                    setState(
                      () {
                        gstamountvalues.value = RangeValues(
                            double.parse(gstminamountctrl.text),
                            double.parse(gstmaxamountctrl.text));
                      },
                    );
                  } else {
                    minamountctrl.text =
                        (double.parse(gstmaxamountctrl.text) - 1).toString();
                    setState(
                      () {
                        gstamountvalues.value = RangeValues(
                            double.parse(minamountctrl.text),
                            double.parse(maxamountctrl.text));
                      },
                    );
                  }
                },
                decoration: InputDecoration(
                    labelText: "Min amount",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 29, 134, 182),
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 216, 216, 216),
                    ))),
              ),
            ),
            Container(
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: gstmaxamountctrl,
                onChanged: (value) {
                  setState(
                    () {
                      gstamountvalues.value = RangeValues(
                          double.parse(gstminamountctrl.text),
                          double.parse(gstmaxamountctrl.text));
                    },
                  );
                },
                decoration: InputDecoration(
                    labelText: "Max amount",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 29, 134, 182),
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 216, 216, 216),
                    ))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
          valueListenable: gstamountvalues,
          builder: (BuildContext context, dynamic value, Widget? child) =>
              RangeSlider(
                  values: gstamountvalues.value,
                  max: 100000,
                  min: 0,
                  divisions: 100,
                  labels: RangeLabels(value.start.round().toString(),
                      value.end.round().toString()),
                  onChangeEnd: (value) {
                    gstminamountctrl.text = value.start.round().toString();
                    gstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      gstamountvalues.value = value;
                    });
                  },
                  onChangeStart: (value) {
                    gstminamountctrl.text = value.start.round().toString();
                    gstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      gstamountvalues.value = value;
                    });
                  },
                  onChanged: (Value) {
                    gstminamountctrl.text = value.start.round().toString();
                    gstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      gstamountvalues.value = Value;
                    });
                  }),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: vendorctrl,
            decoration: InputDecoration(
                labelText: "Vendor",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 29, 134, 182),
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 216, 216, 216),
                ))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: itemctrl,
            decoration: InputDecoration(
                labelText: "Item",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 29, 134, 182),
                )),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromARGB(255, 216, 216, 216),
                ))),
          ),
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  TextEditingController Nongstminamountctrl = TextEditingController();
  TextEditingController Nongstmaxamountctrl = TextEditingController();
  late ValueNotifier<RangeValues> Nongstamountvalues;
  Widget filternongst() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: Nongstminamountctrl,
                onChanged: (value) {
                  if (double.parse(Nongstminamountctrl.text) <
                      double.parse(Nongstmaxamountctrl.text)) {
                    setState(
                      () {
                        Nongstamountvalues.value = RangeValues(
                            double.parse(Nongstminamountctrl.text),
                            double.parse(Nongstmaxamountctrl.text));
                      },
                    );
                  } else {
                    Nongstminamountctrl.text =
                        (double.parse(Nongstmaxamountctrl.text) - 1).toString();
                    setState(
                      () {
                        Nongstamountvalues.value = RangeValues(
                            double.parse(Nongstminamountctrl.text),
                            double.parse(Nongstmaxamountctrl.text));
                      },
                    );
                  }
                },
                decoration: InputDecoration(
                    labelText: "Min amount",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 29, 134, 182),
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 216, 216, 216),
                    ))),
              ),
            ),
            Container(
              width: 150,
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: Nongstmaxamountctrl,
                onChanged: (value) {
                  setState(
                    () {
                      Nongstamountvalues.value = RangeValues(
                          double.parse(Nongstminamountctrl.text),
                          double.parse(Nongstmaxamountctrl.text));
                    },
                  );
                },
                decoration: InputDecoration(
                    labelText: "Max amount",
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 29, 134, 182),
                    )),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(255, 216, 216, 216),
                    ))),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        ValueListenableBuilder(
          valueListenable: Nongstamountvalues,
          builder: (BuildContext context, dynamic value, Widget? child) =>
              RangeSlider(
                  values: Nongstamountvalues.value,
                  max: 100000,
                  min: 0,
                  divisions: 100,
                  labels: RangeLabels(value.start.round().toString(),
                      value.end.round().toString()),
                  onChangeEnd: (value) {
                    Nongstminamountctrl.text = value.start.round().toString();
                    Nongstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      Nongstamountvalues.value = value;
                    });
                  },
                  onChangeStart: (value) {
                    Nongstminamountctrl.text = value.start.round().toString();
                    Nongstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      Nongstamountvalues.value = value;
                    });
                  },
                  onChanged: (Value) {
                    Nongstminamountctrl.text = value.start.round().toString();
                    Nongstmaxamountctrl.text = value.end.round().toString();
                    setState(() {
                      Nongstamountvalues.value = Value;
                    });
                  }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switchsearch selectfilter = switchsearch.gst;
    Widget _selectfilter() {
      switch (selectfilter) {
        case switchsearch.gst:
          return Container(child: filtergst());
        case switchsearch.nongst:
          return Container(child: filternongst());
      }
    }

    Widget _selectgstfilter() {
      switch (selectfilter) {
        case switchsearch.gst:
          return Container(child: filtergst());
        case switchsearch.nongst:
          return Container(child: filternongst());
      }
    }

    List<bool> _selection = [true, false];

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
                    ignoreSafeArea: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                    barrierColor: Colors.white,
                    Container(
                      height: double.maxFinite,
                      color: Colors.white,
                      child: StatefulBuilder(
                        builder: (BuildContext context, setState) =>
                            SingleChildScrollView(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 50, left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      Column(
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
                                                  keyboardType:
                                                      TextInputType.none,
                                                  onTap: () async {
                                                    final DateTime? selectdate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                firstdate,
                                                            firstDate:
                                                                DateTime(1500),
                                                            lastDate:
                                                                DateTime.now());
                                                    if (selectdate != null) {
                                                      setState(() {
                                                        firstdate = selectdate;
                                                      });
                                                      firstdatectrl.text =
                                                          "${selectdate.day}-${selectdate.month}-${selectdate.year}";
                                                    }
                                                  },
                                                  controller: firstdatectrl,
                                                  decoration: InputDecoration(
                                                      labelText: "First date",
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 216, 216, 216),
                                                      )),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 216, 216, 216),
                                                      )),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 29, 134, 182),
                                                      ))),
                                                ),
                                              ),
                                              Container(
                                                width: 150,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.none,
                                                  onTap: () async {
                                                    final DateTime? selectdate =
                                                        await showDatePicker(
                                                            context: context,
                                                            initialDate:
                                                                lastdate,
                                                            firstDate:
                                                                DateTime(1500),
                                                            lastDate:
                                                                DateTime.now());
                                                    if (selectdate != null) {
                                                      setState(() {
                                                        lastdate = selectdate;
                                                      });
                                                      lastdatectrl.text =
                                                          "${selectdate.day}-${selectdate.month}-${selectdate.year}";
                                                    }
                                                  },
                                                  controller: lastdatectrl,
                                                  decoration: InputDecoration(
                                                      labelText: "Last date",
                                                      disabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 216, 216, 216),
                                                      )),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 216, 216, 216),
                                                      )),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                        width: 2,
                                                        color: Color.fromARGB(
                                                            255, 29, 134, 182),
                                                      ))),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: vendorctrl,
                                              decoration: InputDecoration(
                                                  labelText: "Vendor",
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
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: itemctrl,
                                              decoration: InputDecoration(
                                                  labelText: "Item",
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
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 150,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: minamountctrl,
                                                  onChanged: (value) {
                                                    if (double.parse(
                                                            minamountctrl
                                                                .text) <
                                                        double.parse(
                                                            maxamountctrl
                                                                .text)) {
                                                      setState(
                                                        () {
                                                          amountrangevalue
                                                                  .value =
                                                              RangeValues(
                                                                  double.parse(
                                                                      minamountctrl
                                                                          .text),
                                                                  double.parse(
                                                                      maxamountctrl
                                                                          .text));
                                                        },
                                                      );
                                                    } else {
                                                      minamountctrl
                                                          .text = (double.parse(
                                                                  maxamountctrl
                                                                      .text) -
                                                              1)
                                                          .toString();
                                                      setState(
                                                        () {
                                                          amountrangevalue
                                                                  .value =
                                                              RangeValues(
                                                                  double.parse(
                                                                      minamountctrl
                                                                          .text),
                                                                  double.parse(
                                                                      maxamountctrl
                                                                          .text));
                                                        },
                                                      );
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "Min amount",
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
                                              ),
                                              Container(
                                                width: 150,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: maxamountctrl,
                                                  onChanged: (value) {
                                                    if (double.parse(
                                                            minamountctrl
                                                                .text) <
                                                        double.parse(
                                                            maxamountctrl
                                                                .text)) {
                                                      setState(
                                                        () {
                                                          amountrangevalue
                                                                  .value =
                                                              RangeValues(
                                                                  double.parse(
                                                                      minamountctrl
                                                                          .text),
                                                                  double.parse(
                                                                      maxamountctrl
                                                                          .text));
                                                        },
                                                      );
                                                    } else {
                                                      maxamountctrl
                                                          .text = (double.parse(
                                                                  minamountctrl
                                                                      .text) +
                                                              1)
                                                          .toString();
                                                      setState(
                                                        () {
                                                          amountrangevalue
                                                                  .value =
                                                              RangeValues(
                                                                  double.parse(
                                                                      minamountctrl
                                                                          .text),
                                                                  double.parse(
                                                                      maxamountctrl
                                                                          .text));
                                                        },
                                                      );
                                                    }
                                                    setState(
                                                      () {
                                                        amountrangevalue.value =
                                                            RangeValues(
                                                                double.parse(
                                                                    minamountctrl
                                                                        .text),
                                                                double.parse(
                                                                    value));
                                                      },
                                                    );
                                                  },
                                                  decoration: InputDecoration(
                                                      labelText: "Max amount",
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
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: amountrangevalue,
                                            builder: (BuildContext context,
                                                    dynamic value,
                                                    Widget? child) =>
                                                RangeSlider(
                                                    values:
                                                        amountrangevalue.value,
                                                    max: 100000,
                                                    min: 0,
                                                    divisions: 100,
                                                    labels: RangeLabels(
                                                        value.start
                                                            .round()
                                                            .toString(),
                                                        value.end
                                                            .round()
                                                            .toString()),
                                                    onChangeEnd: (value) {
                                                      minamountctrl.text = value
                                                          .start
                                                          .round()
                                                          .toString();
                                                      maxamountctrl.text = value
                                                          .end
                                                          .round()
                                                          .toString();
                                                      setState(() {
                                                        amountrangevalue.value =
                                                            value;
                                                      });
                                                    },
                                                    onChangeStart: (value) {
                                                      minamountctrl.text = value
                                                          .start
                                                          .round()
                                                          .toString();
                                                      maxamountctrl.text = value
                                                          .end
                                                          .round()
                                                          .toString();
                                                      setState(() {
                                                        amountrangevalue.value =
                                                            value;
                                                      });
                                                    },
                                                    onChanged: (Value) {
                                                      minamountctrl.text = value
                                                          .start
                                                          .round()
                                                          .toString();
                                                      maxamountctrl.text = value
                                                          .end
                                                          .round()
                                                          .toString();
                                                      setState(() {
                                                        amountrangevalue.value =
                                                            Value;
                                                      });
                                                    }),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ToggleButtons(
                                            renderBorder: false,
                                            selectedColor: Colors.green,
                                            fillColor: Colors.transparent,
                                            children: [
                                              Container(
                                                height: 50,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 5,
                                                            color: _selection[0]
                                                                ? Colors.green
                                                                : Colors
                                                                    .grey))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25),
                                                  child: Center(
                                                    child: Text(
                                                      'GST',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: 5,
                                                            color: _selection[1]
                                                                ? Colors.green
                                                                : Colors
                                                                    .grey))),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25),
                                                  child: Center(
                                                    child: Text(
                                                      'Non-Gst',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                            isSelected: _selection,
                                            onPressed: (int newindex) {
                                              for (int index = 0;
                                                  index < _selection.length;
                                                  index++) {
                                                if (index == newindex) {
                                                  setState(() {
                                                    _selection[index] = true;
                                                    if (_selection[0] == true) {
                                                      selectfilter =
                                                          switchsearch.gst;
                                                    } else {
                                                      selectfilter =
                                                          switchsearch.nongst;
                                                    }
                                                  });
                                                } else {
                                                  setState(() {
                                                    _selection[index] = false;
                                                  });
                                                }
                                              }
                                            },
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          _selectfilter(),
                                          Align(
                                              alignment: Alignment.bottomCenter,
                                              child: OutlinedButton(
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      'Apply',
                                                    ),
                                                  ],
                                                ),
                                                style: OutlinedButton.styleFrom(
                                                  primary: Color.fromARGB(
                                                      255, 80, 40, 190),
                                                ),
                                                onPressed: () {},
                                              )),
                                        ],
                                      ),
                                    ],
                                  ))),
                        ),
                      ),
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
                            child: Text("Profile",
                                style: TextStyle(fontSize: 20))),
                        SizedBox(
                          height: 20,
                        ),
                        TextButton(
                            onPressed: () async {
                              await DatabaseHelper.instance.remove();
                              Get.offAll(loginScreen());
                            },
                            child:
                                Text("Logout", style: TextStyle(fontSize: 20)))
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
    return FutureBuilder(
      future: billslist,
      builder: (BuildContext context, AsyncSnapshot snapshot) =>
          ListView.builder(
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
                                if (listresponse![index]['billType']
                                        .toString() ==
                                    "gst") {
                                  Get.to(editGSTInvoiceScreen(),
                                      arguments: listresponse![index]
                                          ['billId']);
                                } else {
                                  Get.to(editNonGSTInvoiceScreen(),
                                      arguments: listresponse![index]
                                          ['billId']);
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
              }),
    );
  }
}
