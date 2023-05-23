// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names, unnecessary_new

import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:invoiced/databasehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:invoiced/payment_mode.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'home.dart';

class addInvoiceScreen extends StatefulWidget {
  const addInvoiceScreen({super.key});

  @override
  State<addInvoiceScreen> createState() => _addInvoiceScreenState();
}

class _addInvoiceScreenState extends State<addInvoiceScreen> {
  late TabController tabcontroller;
  @override
  void initState() {
    // TODO: implement initState
    print("api request is enter");
    _vendorapi();
    _itemapi();
    _stateapi();
    super.initState();
  }

  List? vendorslistresponse;

  Future _vendorapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/vendors/1"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      setState(() {
        vendorslistresponse = mapresponse['message'];
      });
      print("vendorslistresponse= $vendorslistresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  List? _itemlistresponse;
  Future _itemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("item api request is sent");

    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/items/1"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      setState(() {
        _itemlistresponse = mapresponse['message'];
      });
      print("vendorslistresponse= $_itemlistresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  List? _statelistresponse;
  Future _stateapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();

    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/states"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      setState(() {
        _statelistresponse = mapresponse['message'];
      });
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  File? GSTimage;
  ImagePicker _GSTpicker = ImagePicker();
  File? NonGSTimage;
  ImagePicker _NonGSTpicker = ImagePicker();
  void takeGSTPhoto(ImageSource source) async {
    var pickedFile = await _GSTpicker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        // GSTimage = imagepermanent;
        GSTimage = File(pickedFile.path);
      });
    }
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

  uploadGSTimage() async {
    var stream = http.ByteStream(GSTimage!.openRead());
    stream.cast();
    var length = await GSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    Map<String, String> headers = {
      "Accept": "*/*",
    };
    String filename = GSTimage!.path.split("/").last;
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
      addGSTbillapi(
          1,
          GSTvendorid,
          GSTvendorctrl.text,
          GSTitemid,
          GSTitemctrl.text,
          GSTINctrl.text,
          stateid,
          invoicenumberctrl.text,
          invoicedatectrl.text,
          int.parse(invoicevaluectrl.text),
          HSN_SACctrl.text,
          goodsandservicesctrl.text,
          int.parse(taxablevaluectrl.text),
          int.parse(quantityctrl.text),
          unitctrl.text,
          int.parse(IGSTRatectrl.text),
          int.parse(IGSTamountctrl.text),
          int.parse(SGSTratectrl.text),
          int.parse(SGSTamountctrl.text),
          int.parse(CGSTratectrl.text),
          int.parse(CGSTamountctrl.text),
          val['billImagePath'],
          1);
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

  addGSTbillapi(
      int orgid,
      int vendorid,
      String vendorname,
      int itemid,
      String itemName,
      String gstin,
      int stateid,
      String invoicenum,
      String dateofinvoice,
      int invoiceval,
      String HSN_SACcode,
      String good_service_description,
      int taxableval,
      int quantity,
      String unit,
      int igstrate,
      int igstamount,
      int sgstrate,
      int sgstamopuint,
      int cgstrate,
      int cgstamount,
      String billImgaePath,
      var modeofPayment) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "organizationId": orgid,
      "vendorId": vendorid,
      "vendorName": vendorname,
      "itemId": itemid,
      "itemName": itemName,
      "gstin": gstin,
      "stateId": stateid,
      "invoiceNumber": invoicenum,
      "dateOfInvoice": dateofinvoice,
      "invoiceValue": invoiceval,
      "hsnSacCode": HSN_SACcode,
      "goodsServiceDescription": good_service_description,
      "taxableValue": taxableval,
      "quantity": quantity,
      "unit": unit,
      "igstRate": igstrate,
      "igstAmount": igstamount,
      "sgstRate": sgstrate,
      "sgstAmount": sgstamopuint,
      "cgstRate": cgstrate,
      "cgstAmount": cgstamount,
      "billImagePath": billImgaePath,
      "modeOfPaymentId": 1
    });
    Map mapresponse;

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/gstBill"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "${token[0]["appToken"]}"
            },
            body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);

      Get.to(homeScreen());
    } else {
      print("login failed");
    }
  }

  uploadNonGSTimage() async {
    var stream = http.ByteStream(NonGSTimage!.openRead());
    stream.cast();
    var length = await NonGSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    Map<String, String> headers = {
      "Accept": "*/*",
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
      addNonGSTbillapi(
          1,
          NonGSTvendorid,
          Non_GSTvendorctrl.text,
          NonGSTitemid,
          Non_GSTitemctrl.text,
          instrument_referance_numberctrl.text,
          instrumentdatectrl.text,
          int.parse(instrument_valuectrl.text),
          goods_servicesctrl.text,
          int.parse(NonGSTtaxablevalctrl.text),
          int.parse(quantity_ctrl.text),
          NonGSTunitctrl.text,
          int.parse(instrumenttotalvaluectrl.text),
          val['billImagePath'],
          1);
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

  addNonGSTbillapi(
      int orgid,
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
      var modeofPayment) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "organizationId": orgid,
      "vendorId": 123,
      "vendorName": vendorname,
      "itemId": 456,
      "itemName": itemName,
      "instrumentReferenceNumber": "REF-001",
      "instrumentDate": "2023-05-20",
      "instrumentValue": 1000,
      "goodsServiceDescription": "Description of goods/services",
      "taxableValue": 900,
      "quantity": 10,
      "unit": "Piece",
      "instrumentTotalValue": 1200,
      "billImagePath": "path/to/bill/image.jpg",
      "modeOfPaymentId": 1
    });
    Map mapresponse;

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/gstBill"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "${token[0]["appToken"]}"
            },
            body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);

      Get.to(homeScreen());
    } else {
      print("login failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
          bottom: TabBar(
              indicator: BoxDecoration(
                color: Color.fromARGB(255, 33, 167, 228),
              ),
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                Tab(
                  child: Text("GST"),
                ),
                Tab(
                  child: Text("Non-GST"),
                ),
              ]),
        ),
        body: TabBarView(
            children: [Gst(screensize, context), Non_Gst(screensize, context)]),
      ),
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
                    type == true
                        ? takeGSTPhoto(ImageSource.camera)
                        : takeNONGSTPhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("camera")),
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () {
                    type == true
                        ? takeGSTPhoto(ImageSource.gallery)
                        : takeNONGSTPhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  Gst(var screensize, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: vendorslistresponse == null
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _itemlistresponse == null
                  ? Container(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Vendor"),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        forexample(vendorslistresponse!, true, true),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Item Name'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        forexample(_itemlistresponse!, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('GSTIN'),
                                Text(
                                  "*",
                                  style: TextStyle(color: Colors.red),
                                )
                              ],
                            ),
                          ],
                        ),
                        fields(GSTINctrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('State Name'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(statectrl, true, true),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Invoice Number'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(invoicenumberctrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Date of Invoice'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(invoicedatectrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Invoice Value'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(invoicevaluectrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('HSN/SAC Code'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(HSN_SACctrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Goods/Service Description'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(goodsandservicesctrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Taxable Value'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(taxablevaluectrl, false, false),
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
                        fields(quantityctrl, false, false),
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
                        fields(unitctrl, true, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('IGST Rate'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(IGSTRatectrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('IGST Amount'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(IGSTamountctrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('SGST Rate'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(SGSTratectrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('SGST Amount'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(SGSTamountctrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('CGST Rate'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(CGSTratectrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('CGST Amount'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        fields(CGSTamountctrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Bill Image'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(
                                  screensize.height, screensize.width, true)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromARGB(255, 222, 222, 222)),
                                borderRadius: BorderRadius.circular(5)),
                            height: screensize.height * 0.2,
                            width: screensize.width * 0.7,
                            child: Center(
                              child: GSTimage == null
                                  ? Text(
                                      "Upload Image",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Image.file(GSTimage!),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.to(paymentModeScreen());
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
                          onPressed: () {
                            uploadGSTimage();
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
                      ],
                    ),
        ),
      ),
    );
  }

  Non_Gst(var screensize, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: vendorslistresponse == null
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _itemlistresponse == null
                  ? Container(
                      height: 300,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Vendor"),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        forexample(vendorslistresponse!, false, true),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Item Name'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        forexample(_itemlistresponse!, false, false),
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
                        fields(instrument_referance_numberctrl, true, false),
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
                        fields(instrumentdatectrl, true, false),
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
                        fields(instrument_valuectrl, false, false),
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
                        fields(goods_servicesctrl, true, false),
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
                        fields(quantity_ctrl, false, false),
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
                        fields(instrumentunitctrl, true, false),
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
                        fields(instrumenttotalvaluectrl, false, false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: [
                            Text('Bill Image'),
                            Text(
                              "*",
                              style: TextStyle(color: Colors.red),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => bottomSheet(
                                  screensize.height, screensize.width, false)),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2,
                                    color: Color.fromARGB(255, 222, 222, 222)),
                                borderRadius: BorderRadius.circular(5)),
                            height: screensize.height * 0.2,
                            width: screensize.width * 0.7,
                            child: Center(
                              child: GSTimage == null
                                  ? Text(
                                      "Upload Image",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Image.file(GSTimage!),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.to(paymentModeScreen());
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
                          onPressed: () {
                            uploadNonGSTimage();
                          },
                          height: screensize.height * 0.065,
                          color: Color.fromARGB(255, 10, 31, 11),
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
                      ],
                    ),
        ),
      ),
    );
  }

  var stateid;
  var GSTvendorid;
  var GSTitemid;
  var NonGSTvendorid;
  var NonGSTitemid;
  fields(TextEditingController controller, bool text, bool state) {
    return Container(
      height: 50,
      child: TextFormField(
        enabled: !state,
        onChanged: (value) async {
          print("value add=${value.toUpperCase()}");

          if (GSTINctrl.text.length >= 2) {
            String val =
                "${GSTINctrl.text[0].toUpperCase()}${GSTINctrl.text[1].toUpperCase()}";
            print("val-$val");
            for (int n = 0; n < _statelistresponse!.length; n++) {
              print("selecting value");

              if (val == _statelistresponse![n]['stateCode'].toString()) {
                statectrl.text = _statelistresponse![n]['StateName'].toString();
                setState(() {
                  stateid = _statelistresponse![n]["stateId"];
                });

                print("State is selected");
                break;
              } else {
                statectrl.clear();
              }
            }
          } else {
            statectrl.clear();
          }
        },
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

  TextEditingController GSTINctrl = TextEditingController();
  TextEditingController statectrl = TextEditingController();
  TextEditingController invoicenumberctrl = TextEditingController();
  TextEditingController invoicedatectrl = TextEditingController();
  TextEditingController invoicevaluectrl = TextEditingController();
  TextEditingController HSN_SACctrl = TextEditingController();
  TextEditingController goodsandservicesctrl = TextEditingController();
  TextEditingController taxablevaluectrl = TextEditingController();
  TextEditingController quantityctrl = TextEditingController();
  TextEditingController unitctrl = TextEditingController();
  TextEditingController IGSTRatectrl = TextEditingController();
  TextEditingController IGSTamountctrl = TextEditingController();
  TextEditingController SGSTratectrl = TextEditingController();
  TextEditingController SGSTamountctrl = TextEditingController();
  TextEditingController CGSTratectrl = TextEditingController();
  TextEditingController CGSTamountctrl = TextEditingController();
  TextEditingController instrument_referance_numberctrl =
      TextEditingController();
  TextEditingController instrumentdatectrl = TextEditingController();
  TextEditingController instrument_valuectrl = TextEditingController();
  TextEditingController goods_servicesctrl = TextEditingController();
  TextEditingController quantity_ctrl = TextEditingController();
  TextEditingController NonGSTunitctrl = TextEditingController();
  TextEditingController NonGSTtaxablevalctrl = TextEditingController();
  TextEditingController instrumentunitctrl = TextEditingController();
  TextEditingController instrumenttotalvaluectrl = TextEditingController();

  TextEditingController GSTvendorctrl = TextEditingController();
  TextEditingController GSTitemctrl = TextEditingController();
  TextEditingController Non_GSTvendorctrl = TextEditingController();
  TextEditingController Non_GSTitemctrl = TextEditingController();
  forexample(List option, bool type, bool names) {
    return Container(
        child: TypeAheadField(
      // noItemsFoundBuilder: (context) => const SizedBox(
      //   height: 50,
      //   child: Center(
      //     child: Text(names==true?"No Vendor Found" :'No Item Found'),
      //   ),
      // ),
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        color: Colors.white,
        elevation: 4.0,
      ),
      suggestionsCallback: (Value) async {
        var search = option;
        print(search);
        return search;
      },
      textFieldConfiguration: TextFieldConfiguration(
          controller: type == true
              ? names == true
                  ? GSTvendorctrl
                  : GSTitemctrl
              : names == true
                  ? Non_GSTvendorctrl
                  : Non_GSTitemctrl,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Color.fromARGB(255, 29, 134, 182),
              ),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
              10.0,
            )),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(
                  width: 2,
                  color: Color.fromARGB(255, 216, 216, 216),
                )),
            contentPadding: const EdgeInsets.only(top: 4, left: 10),
          )),
      debounceDuration: const Duration(seconds: 1),
      itemBuilder: (context, suggestion) {
        // print(sugg);
        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  names == true
                      ? suggestion['vendorName'].toString()
                      : suggestion['itemName'].toString(),
                  maxLines: 1,
                  style: TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
          ],
        );
      },
      onSuggestionSelected: (suggestion) async {
        // String sugg = suggestion.toString();
        type == true
            ? names == true
                ? GSTvendorctrl.text = suggestion['vendorName'].toString()
                : GSTitemctrl.text = suggestion['itemName'].toString()
            : names == true
                ? Non_GSTvendorctrl.text = suggestion['vendorName'].toString()
                : Non_GSTitemctrl.text = suggestion['itemName'].toString();
        String bata;
        type == true
            ? bata = suggestion['vendorName'].toString()
            : bata = suggestion['itemName'].toString();
        setState(() {
          type == true
              ? names == true
                  ? GSTvendorid = suggestion["vendorId"]
                  : GSTitemid = suggestion["itemId"]
              : names == true
                  ? NonGSTvendorid = suggestion["vendorId"]
                  : NonGSTitemid = suggestion["itemId"];
        });

        print("bata=$bata");
      },
    ));
  }
}
