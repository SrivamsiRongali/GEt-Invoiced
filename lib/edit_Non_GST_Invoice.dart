// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names

import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:invoiced/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoiced/addinvoice_payment_mode.dart';
import 'package:invoiced/pojoclass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'editinvoice_payment_mode.dart';
import 'home.dart';
import 'itemscreen.dart';
import 'vendorscreen.dart';

class editNonGSTInvoiceScreen extends StatefulWidget {
  const editNonGSTInvoiceScreen({super.key});

  @override
  State<editNonGSTInvoiceScreen> createState() =>
      _editNonGSTInvoiceScreenState();
}

class _editNonGSTInvoiceScreenState extends State<editNonGSTInvoiceScreen> {
  late TabController tabcontroller;
  @override
  void initState() {
    // TODO: implement initState
    NonGSTvendorslistresponse = ValueNotifier<List>([]);
    _NonGSTitemlistresponse = ValueNotifier<List>([]);

    print("api request is enter");

    billdata = _NonGSTbillapi();
    _NonGSTvendorapi();
    _NonGSTitemapi();

    super.initState();
  }

  Future? billdata;

  var billid = Get.arguments;
  List? listresponse;
  Future? _NonGSTbillapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("Non GST bill api request is sent");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/nonGstBill/$billid"),
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
      setState(() {
        listresponse = mapresponse['message'];
      });

      editNonGSTvendorid.value = listresponse![0]["vendorId"] as int;
      editNonGSTitemid.value = listresponse![0]["itemId"];

      var date = DateTime.fromMillisecondsSinceEpoch(
          listresponse![0]["instrumentDate"]);
      editNon_GSTvendorctrl.text = listresponse![0]["vendorName"].toString();
      editNon_GSTvendor.value = listresponse![0]["vendorName"].toString();
      editNon_GSTitemctrl.text = listresponse![0]["itemName"].toString();
      instrument_referance_numberctrl.text =
          listresponse![0]["instrumentReferenceNumber"].toString();
      instrumentdatectrl.text = "${date.day}-${date.month}-${date.year}";
      goods_servicesctrl.text =
          listresponse![0]["goodsServiceDescription"].toString();
      instrument_valuectrl.text =
          listresponse![0]["instrumentValue"].toString();
      quantity_ctrl.text = listresponse![0]["quantity"].toString();
      instrumentunitctrl.text = listresponse![0]["unit"].toString();
      instrumenttotalvaluectrl.text =
          listresponse![0]["instrumentTotalValue"].toString();
      if (listresponse![0]["modeOfPayments"] != null) {
        for (int n = 0; n < listresponse![0]["modeOfPayments"].length; n++) {
          await DatabaseHelper.instance.addNonGSTmodeofpayment(
            Nongstmodeofpayment(
              modeOfPaymentId: listresponse![0]["modeOfPayments"][n]
                  ['modeOfPaymentId'],
              paymentValue: listresponse![0]["modeOfPayments"][n]
                  ['paymentValue'],
              billPaymentId: listresponse![0]["modeOfPayments"][n]
                  ['billPaymentId'],
              updateForBillPayment: listresponse![0]["modeOfPayments"][n]
                          ['updateForBillPayment'] ==
                      null
                  ? 0
                  : listresponse![0]["modeOfPayments"][n]
                      ['updateForBillPayment'],
            ),
          );
        }
      }

      print("Non GST bill = $listresponse");
      return listresponse;
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  ValueNotifier<List>? NonGSTvendorslistresponse;

  Future _NonGSTvendorapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchVendor?vendorName=${editNon_GSTvendorctrl.value.text}"),
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
      NonGSTvendorslistresponse?.value = mapresponse['message'];

      setState(() {
        NonGSTvendorslistresponse?.value = mapresponse['message'];
      });

      print("NonGSTvendorslistresponse= ${NonGSTvendorslistresponse?.value}");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  ValueNotifier<List>? _NonGSTitemlistresponse;
  Future _NonGSTitemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("item api request is sent");

    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchItem?itemName=${editNon_GSTitemctrl.value.text}"),
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
      setState(() {
        _NonGSTitemlistresponse?.value = mapresponse['message'];
      });

      print("itemlistresponse= ${_NonGSTitemlistresponse?.value}");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  // List? _statelistresponse;
  // Future _stateapi() async {
  //   Map mapresponse;
  //   http.Response response1;
  //   var token = await DatabaseHelper.instance.getbookkeepermodel();

  //   response1 = await http.get(
  //     Uri.parse("http://192.168.0.101:8082/states"),
  //     headers: {
  //       "accept": "*/*",
  //       "Content-Type": "application/json",
  //       "Authorization": "${token[0]["appToken"]}"
  //     },
  //   );
  //   if (response1.statusCode == 200) {
  //     print('successful');
  //     mapresponse = json.decode(response1.body);
  //     print(response1.body);
  //     setState(() {
  //       _statelistresponse = mapresponse['message'];
  //     });
  //   } else {
  //     print(response1.body);
  //     print('fetch unsuccessful');
  //   }
  // }

  File? NonGSTimage;
  ImagePicker _NonGSTpicker = ImagePicker();
  bool edit = false;
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await DatabaseHelper.instance.removenonGSTmodeofpayment();
              Get.offAll(homeScreen());
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  edit = !edit;
                });
              },
              icon: Icon(
                Icons.edit,
                color: edit == true
                    ? Color.fromARGB(255, 91, 171, 94)
                    : Colors.white,
              ))
        ],
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
      ),
      body: Non_Gst(screensize, context),
    );
  }

  Widget bottomSheet(double screenheight, double screenwidth, bool type) {
    return Container(
      height: screenheight * 0.15,
      width: screenwidth,
      margin: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        children: <Widget>[
          Text(
            "Choose profile photo",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
          // ignore: deprecated_member_use
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () {
                    takeNONGSTPhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("camera")),
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () {
                    takeNONGSTPhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  Non_Gst(var screensize, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: listresponse == null
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : NonGSTvendorslistresponse!.value == null
                  ? Container(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _NonGSTitemlistresponse!.value == null
                      ? Container(
                          height: 300,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : FutureBuilder(
                          future: billdata,
                          builder: (context, snapshot) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Bill Image"),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  edit == true
                                      ? showModalBottomSheet(
                                          context: context,
                                          builder: ((builder) => bottomSheet(
                                              screensize.height,
                                              screensize.width,
                                              false)),
                                        )
                                      : Container();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: Color.fromARGB(
                                              255, 222, 222, 222)),
                                      borderRadius: BorderRadius.circular(5)),
                                  height: screensize.height * 0.2,
                                  width: screensize.width * 0.9,
                                  child: Center(
                                    child: NonGSTimage == null
                                        ? Text(
                                            "Upload Image",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Image.file(NonGSTimage!),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text("Vendor Name"),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              ValueListenableBuilder(
                                  valueListenable: editNon_GSTvendor,
                                  builder: (BuildContext context, dynamic value,
                                      Widget? child) {
                                    print("value-$value");

                                    print(editNonGSTvendorid.value);
                                    editNon_GSTvendorctrl.text = value;
                                    return forexample(
                                        editNon_GSTvendorctrl, edit, true);
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              ValueListenableBuilder(
                                  valueListenable: editNon_GSTitem,
                                  builder: (context, value, child) {
                                    editNon_GSTitemctrl.text = value;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Item Name'),
                                            Text(
                                              "*",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          ],
                                        ),
                                        forexample(
                                            editNon_GSTitemctrl, edit, false),
                                      ],
                                    );
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Instrument reference number'),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              fields(
                                  instrument_referance_numberctrl, true, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Instrument date'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              Datefields(
                                  instrumentdatectrl, true, context, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Instrument value'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              fields(instrument_valuectrl, false, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Good/Service description'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              fields(goods_servicesctrl, true, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Quantity'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              fields(quantity_ctrl, false, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Unit'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              fields(instrumentunitctrl, true, edit),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Text('Instrument total value'),
                                  Text(
                                    "*",
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
                              fields(instrumenttotalvaluectrl, false, edit),
                              SizedBox(
                                height: 15,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Get.to(editinvoicepaymentModeScreen(),
                                      arguments: [
                                        int.parse(
                                            instrumenttotalvaluectrl.text),
                                        false
                                      ]);
                                },
                                height: screensize.height * 0.065,
                                color: Color.fromARGB(255, 91, 171, 94),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Select Mode of Payment',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  if (edit == true) {
                                    setState(() {});
                                    var modeofpayments = await DatabaseHelper
                                        .instance
                                        .getNonGSTmodeofpayments();
                                    print("modeofpayments=$modeofpayments");
                                    if (editNon_GSTvendorctrl
                                            .value.text.isEmpty ||
                                        editNon_GSTitemctrl.text.isEmpty ||
                                        instrument_referance_numberctrl
                                            .text.isEmpty ||
                                        instrumentdatectrl.text.isEmpty ||
                                        instrument_valuectrl.text.isEmpty ||
                                        goods_servicesctrl.text.isEmpty ||
                                        quantity_ctrl.text.isEmpty ||
                                        instrumentunitctrl.text.isEmpty ||
                                        instrumenttotalvaluectrl.text.isEmpty ||
                                        NonGSTimage == null) {
                                      Get.defaultDialog(
                                          title: "",
                                          content: Text(
                                              "Please fill all the mandatory fields"));
                                    } else if (modeofpayments == null) {
                                      Get.defaultDialog(
                                          title: "",
                                          content: Text(
                                              "Please provide mode of payment"));
                                    } else {
                                      editNonGSTvendorid == null
                                          ? Get.defaultDialog(
                                              title: "Vendor not available",
                                              content: Text(
                                                  "Please add vendor before saving the bill"),
                                              actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      MaterialButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      MaterialButton(
                                                        onPressed: () {},
                                                        child: Text("Ok"),
                                                      )
                                                    ],
                                                  )
                                                ])
                                          : editNonGSTitemid == null
                                              ? Get.defaultDialog(
                                                  title: "Item not available",
                                                  content: Text(
                                                      "Please add Item before saving the bill"),
                                                  actions: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          MaterialButton(
                                                            onPressed: () {
                                                              Get.back();
                                                            },
                                                            child:
                                                                Text("Cancel"),
                                                          ),
                                                          MaterialButton(
                                                            onPressed: () {},
                                                            child: Text("Ok"),
                                                          )
                                                        ],
                                                      )
                                                    ])
                                              : uploadNonGSTimage();
                                    }
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
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  _DeleteNonGSTbillapi();
                                },
                                height: screensize.height * 0.065,
                                color: Colors.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(7)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }

  Future _DeleteNonGSTbillapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("Non GST bill api request is sent");
    response1 = await http.delete(
      Uri.parse("http://192.168.0.101:8082/nonGstBill/$billid"),
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
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  DateTime NonGSTdate = DateTime.now();
  Datefields(TextEditingController controller, bool type, BuildContext context,
      bool enable) {
    return Container(
      height: 50,
      child: TextFormField(
        enabled: enable,
        keyboardType: TextInputType.none,
        onTap: () async {
          final DateTime? selectdate = await showDatePicker(
              context: context,
              initialDate: NonGSTdate,
              firstDate: DateTime(1500),
              lastDate: DateTime.now());
          if (selectdate != null) {
            setState(() {
              NonGSTdate = selectdate;
            });
          }
          instrumentdatectrl.text =
              "${NonGSTdate.day}-${NonGSTdate.month}-${NonGSTdate.year}";
        },
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

  void takeNONGSTPhoto(ImageSource source) async {
    var pickedFile = await _NonGSTpicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // GSTimage = imagepermanent;
        NonGSTimage = File(pickedFile.path);
      });
    }
  }

  uploadNonGSTimage() async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var stream = http.ByteStream(NonGSTimage!.openRead());
    stream.cast();
    var length = await NonGSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    Map<String, String> headers = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token[0]["appToken"]}"
    };
    String filename = NonGSTimage!.path.split("/").last;
    var multiport = new http.MultipartFile("billImagePath", stream, length,
        filename: filename);
    request.files.add(multiport);

    // request.headers[headers];
    // request.headers['accept'] = '*/*';
    // request.headers['Content-Type'] = "application/json";
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
      var res = await http.Response.fromStream(response);
      var val = json.decode(res.body);
      var modeofpayments = await DatabaseHelper.instance.getGSTmodeofpayments();

      editNonGSTbillapi(
          editNonGSTvendorid.value,
          editNon_GSTvendorctrl.value.text,
          editNonGSTitemid.value,
          editNon_GSTitemctrl.text,
          instrument_referance_numberctrl.text,
          "${NonGSTdate.year}-${NonGSTdate.month}-${NonGSTdate.day}",
          int.parse(instrument_valuectrl.text),
          goods_servicesctrl.text,
          0,
          int.parse(quantity_ctrl.text),
          instrumentunitctrl.text,
          int.parse(instrumenttotalvaluectrl.text),
          val['billImagePath'],
          modeofpayments);
    } else {
      Get.defaultDialog(
          title: "Unable to uploaded",
          content: Text("Please try again after some time"),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.back();
              },
              child: Text("ok"),
            )
          ]);
    }
  }

  editNonGSTbillapi(
      int vendorid,
      String vendorname,
      int itemid,
      String itemName,
      String instrumentReferenceNumber,
      String instrumentDate,
      int instrumentValue,
      String goodsServiceDescription,
      int taxableValue,
      int quantity,
      String unit,
      int instrumentTotalValue,
      String billImgaePath,
      var modeofPayments) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "vendorId": vendorid,
      "vendorName": vendorname,
      "itemId": itemid,
      "itemName": itemName,
      "instrumentReferenceNumber": instrumentReferenceNumber,
      "instrumentDate": instrumentDate,
      "instrumentValue": instrumentValue,
      "goodsServiceDescription": goodsServiceDescription,
      "taxableValue": taxableValue,
      "quantity": quantity,
      "unit": unit,
      "instrumentTotalValue": instrumentTotalValue,
      "billImagePath": billImgaePath,
      "billCreatedOn": "",
      "billCreatedBy": "",
      "billUpdatedOn": "",
      "billUpdatedBy": "",
      "modeOfPayments": modeofPayments
    });
    Map mapresponse;
    print("NonGSt edit api is hit");

    http.Response response = await http.put(
        Uri.parse("http://192.168.0.101:8082/nonGstBill/$billid"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "Authorization": "Bearer ${token[0]["appToken"]}"
        },
        body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);
      print(response.body);
      await DatabaseHelper.instance.removenonGSTmodeofpayment();
      Get.to(homeScreen());
    } else {
      print("login failed");
    }
  }

  var stateid;

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

  TextEditingController instrument_referance_numberctrl =
      TextEditingController();
  TextEditingController instrumentdatectrl = TextEditingController();
  TextEditingController instrument_valuectrl = TextEditingController();
  TextEditingController goods_servicesctrl = TextEditingController();
  TextEditingController quantity_ctrl = TextEditingController();
  TextEditingController NonGSTtaxablevalctrl = TextEditingController();
  TextEditingController instrumentunitctrl = TextEditingController();
  TextEditingController instrumenttotalvaluectrl = TextEditingController();
  TextEditingController editNon_GSTvendorctrl = TextEditingController();
  TextEditingController editNon_GSTitemctrl = TextEditingController();
  forexample(TextEditingController controller, bool enable, bool names) {
    return Container(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.none,
        enabled: enable,
        onTap: () {
          names == true
              ? Get.to(vendorsScreen(), arguments: [false, false])
              : Get.to(items(), arguments: [
                  false,
                  false,
                ]);
        },
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
      //     TypeAheadField(
      //   noItemsFoundBuilder: (context) => const SizedBox(
      //     height: 50,
      //     child: Center(
      //       child: Text('No Item Found'),
      //     ),
      //   ),
      //   suggestionsBoxDecoration: const SuggestionsBoxDecoration(
      //     color: Colors.white,
      //     elevation: 4.0,
      //   ),
      //   suggestionsCallback: (Value) async {
      //     var search = names == true
      //         ? NonGSTvendorslistresponse!.value
      //         : _NonGSTitemlistresponse!.value;
      //     print(search);
      //     return search;
      //   },
      //   textFieldConfiguration: TextFieldConfiguration(
      //       onTap: () {
      //         names == true
      //             ? Get.to(vendorsScreen(), arguments: [false, true])
      //             : Get.to(items(), arguments: [false, false]);
      //       },
      //       // onChanged: (value) {
      //       //   names == true ? _NonGSTvendorapi() : _NonGSTitemapi();
      //       //   setState(() {
      //       //     names == true ? editNonGSTvendorid = null : editNonGSTitemid = null;
      //       //   });
      //       //   print("id's changed to ZERO");
      //       // },
      //       enabled: enable,
      //       controller: controller,
      //       decoration: InputDecoration(
      //         focusedBorder: const OutlineInputBorder(
      //           borderSide: BorderSide(
      //             width: 2,
      //             color: Color.fromARGB(255, 29, 134, 182),
      //           ),
      //         ),
      //         border: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(
      //           10.0,
      //         )),
      //         disabledBorder: const OutlineInputBorder(
      //             borderRadius: BorderRadius.all(
      //               Radius.circular(5.0),
      //             ),
      //             borderSide: BorderSide(
      //               width: 2,
      //               color: Color.fromARGB(255, 216, 216, 216),
      //             )),
      //         enabledBorder: const OutlineInputBorder(
      //             borderRadius: BorderRadius.all(
      //               Radius.circular(5.0),
      //             ),
      //             borderSide: BorderSide(
      //               width: 2,
      //               color: Color.fromARGB(255, 216, 216, 216),
      //             )),
      //         contentPadding: const EdgeInsets.only(top: 4, left: 10),
      //       )),
      //   debounceDuration: const Duration(seconds: 1),
      //   itemBuilder: (context, suggestion) {
      //     // print(sugg);
      //     return Row(
      //       children: [
      //         Flexible(
      //           child: Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: Text(
      //               names == true
      //                   ? suggestion['vendorName'].toString()
      //                   : suggestion['itemName'].toString(),
      //               maxLines: 1,
      //               style: TextStyle(color: Colors.black),
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //           ),
      //         )
      //       ],
      //     );
      //   },
      //   onSuggestionSelected: (suggestion) async {
      //     // String sugg = suggestion.toString();
      //     names == true
      //         ? editNon_GSTvendorctrl.value.text =
      //             suggestion['vendorName'].toString()
      //         : editNon_GSTitemctrl.value.text =
      //             suggestion['itemName'].toString();
      //     String bata;
      //     names == true
      //         ? bata = suggestion['vendorName'].toString()
      //         : bata = suggestion['itemName'].toString();
      //     setState(() {
      //       names == true
      //           ? editNonGSTvendorid.value = suggestion["vendorId"]
      //           : editNonGSTitemid.value = suggestion["itemId"];
      //     });

      //     print("bata=$bata");
      //   },
      // )
    );
  }
}
