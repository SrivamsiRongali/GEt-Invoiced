// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names, unnecessary_new, unnecessary_null_comparison

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
    GSTvendorslistresponse = ValueNotifier<List>([]);
    _GSTitemlistresponse = ValueNotifier<List>([]);
    NonGSTvendorslistresponse = ValueNotifier<List>([]);
    _NonGSTitemlistresponse = ValueNotifier<List>([]);
    print("api request is enter");

    _GSTvendorapi();
    _Nonitemapi();
    _NonGSTvendorapi();
    _NonGSTitemapi();
    _stateapi();

    super.initState();
  }

  ValueNotifier<List>? GSTvendorslistresponse;

  Future _GSTvendorapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchVendor?vendorName=${GSTvendorctrl.text}"),
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
      GSTvendorslistresponse?.value = mapresponse['message'];
      if (GSTvendorslistresponse?.value == []) {
        print("vendor response is null");
        setState(() {
          GSTvendorslistresponse?.value = [];
        });

        // Get.defaultDialog(
        //     title: "Vendor Does Not exist",
        //     content: Text("Please add Vendor before adding the bill"),
        //     actions: [
        //       MaterialButton(
        //         onPressed: () {
        //           Get.back();
        //         },
        //         child: Text("ok"),
        //       ),
        //     ]);
      } else {
        setState(() {
          GSTvendorslistresponse?.value = mapresponse['message'];
        });
      }

      print("GSTvendorslistresponse= ${GSTvendorslistresponse?.value}");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  ValueNotifier<List>? _GSTitemlistresponse;
  Future _Nonitemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("item api request is sent");

    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchItem?itemName=${GSTitemctrl.text}"),
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
        _GSTitemlistresponse?.value = mapresponse['message'];
      });

      print("itemlistresponse= ${_GSTitemlistresponse?.value}");
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
          "http://192.168.0.101:8082/searchVendor?vendorName=${Non_GSTvendorctrl.text}"),
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
      if (NonGSTvendorslistresponse?.value == []) {
        print("vendor response is null");
        setState(() {
          NonGSTvendorslistresponse?.value = [];
        });

        // Get.defaultDialog(
        //     title: "Vendor Does Not exist",
        //     content: Text("Please add Vendor before adding the bill"),
        //     actions: [
        //       MaterialButton(
        //         onPressed: () {
        //           Get.back();
        //         },
        //         child: Text("ok"),
        //       ),
        //     ]);
      } else {
        setState(() {
          NonGSTvendorslistresponse?.value = mapresponse['message'];
        });
      }

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
          "http://192.168.0.101:8082/searchItem?itemName=${Non_GSTitemctrl.text}"),
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
        "Authorization": "Bearer ${token[0]["appToken"]}"
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
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var stream = http.ByteStream(GSTimage!.openRead());
    stream.cast();
    var length = await GSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    Map<String, String> headers = {
      "Accept": "*/*",
      "Content-Type": "application/json",
      "Authorization": "Bearer ${token[0]["appToken"]}"
    };
    String filename = GSTimage!.path.split("/").last;
    var multiport = new http.MultipartFile("billImagePath", stream, length,
        filename: filename);
    request.files.add(multiport);

    // request.headers[headers];
    // request.headers['accept'] = '*/*';
    request.headers["Authorization"] = "Bearer ${token[0]["appToken"]}";
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
      var res = await http.Response.fromStream(response);
      var val = json.decode(res.body);
      print("val=$val");
      var modeofpayments = await DatabaseHelper.instance.getGSTmodeofpayments();
      print(GSTitemctrl.text);
      print(modeofpayments);
      addGSTbillapi(
          1,
          GSTvendorid == null ? 0 : GSTvendorid,
          GSTvendorctrl.text,
          GSTitemid == null ? 0 : GSTitemid,
          GSTitemctrl.text,
          GSTINctrl.text,
          stateid,
          invoicenumberctrl.text,
          "${GSTdate.year}-${GSTdate.month}-${GSTdate.day}",
          int.parse(invoicevaluectrl.text),
          HSN_SACctrl.text,
          GSTgoodsandservicesctrl.text,
          int.parse(taxablevaluectrl.text),
          int.parse(GSTquantityctrl.text),
          GSTunitctrl.text,
          int.parse(IGSTRatectrl.text == "" ? "1" : IGSTRatectrl.text),
          int.parse(IGSTamountctrl.text == "" ? "1" : IGSTamountctrl.text),
          int.parse(SGSTratectrl.text == "" ? "1" : SGSTratectrl.text),
          int.parse(SGSTamountctrl.text == "" ? "1" : SGSTamountctrl.text),
          int.parse(CGSTratectrl.text),
          int.parse(CGSTamountctrl.text),
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
      var modeofPayments) async {
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
      "modeOfPayments": modeofPayments,
      "billCreatedOn": "",
      "billCreatedBy": "",
      "billUpdatedOn": "",
      "billUpdatedBy": "",
    });
    print(data);
    Map mapresponse;

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/gstBill"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${token[0]["appToken"]}"
            },
            body: data);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);
      await DatabaseHelper.instance.removeGSTmodeofpayment();
      Get.to(homeScreen());
    } else {
      print("login failed");
    }
  }

  uploadNonGSTimage() async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var stream = http.ByteStream(NonGSTimage!.openRead());
    stream.cast();
    var length = await NonGSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    // Map<String, String> headers = {
    //   "Accept": "*/*",
    //   "Content-Type": "application/json",
    //   "Authorization": "Bearer ${token[0]["appToken"]}"
    // };
    String filename = NonGSTimage!.path.split("/").last;
    var multiport = new http.MultipartFile("billImagePath", stream, length,
        filename: filename);
    request.files.add(multiport);

    // request.headers[headers];
    request.headers["Authorization"] = "Bearer ${token[0]["appToken"]}";
    // request.headers['Content-Type'] = "application/json";
    var response = await request.send();
    if (response.statusCode == 200) {
      print("Image Uploaded");
      var res = await http.Response.fromStream(response);
      var val = json.decode(res.body);
      print(val);
      var modeofpayments =
          await DatabaseHelper.instance.getNonGSTmodeofpayments();
      addNonGSTbillapi(
          1,
          NonGSTvendorid == null ? 0 : NonGSTvendorid,
          Non_GSTvendorctrl.text,
          NonGSTitemid == null ? 0 : NonGSTitemid,
          Non_GSTitemctrl.text,
          instrument_referance_numberctrl.text,
          "${NonGSTdate.year}-${NonGSTdate.month}-${NonGSTdate.day}",
          int.parse(instrument_valuectrl.text),
          NonGST_goods_servicesctrl.text,
          0,
          int.parse(NonGSTquantity_ctrl.text),
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
      List modeofPayments) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "organizationId": orgid,
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

    http.Response response =
        await http.post(Uri.parse("http://192.168.0.101:8082/nonGstBill"),
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

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                await DatabaseHelper.instance.removeGSTmodeofpayment();
                await DatabaseHelper.instance.removenonGSTmodeofpayment();
                Get.offAll(homeScreen());
              },
              icon: Icon(Icons.arrow_back)),
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

  DateTime GSTdate = DateTime.now();
  DateTime NonGSTdate = DateTime.now();

  Gst(var screensize, BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GSTvendorslistresponse!.value == null
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _GSTitemlistresponse!.value == null
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
                        forexample(GSTvendorslistresponse!.value, true, true),
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
                        forexample(_GSTitemlistresponse!.value, true, false),
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
                        Datefields(invoicedatectrl, true, context),
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
                        fields(GSTgoodsandservicesctrl, true, false),
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
                        fields(GSTquantityctrl, false, false),
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
                        fields(GSTunitctrl, true, false),
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
                            Get.to(addinvoicepaymentModeScreen(), arguments: [
                              int.parse(invoicevaluectrl.text),
                              true
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
                            setState(() {});
                            var modeofpayments = await DatabaseHelper.instance
                                .getGSTmodeofpayments();
                            print("modeofpayments=$modeofpayments");
                            if (GSTvendorctrl.text.isEmpty ||
                                GSTitemctrl.text.isEmpty ||
                                GSTINctrl.text.isEmpty ||
                                statectrl.text.isEmpty ||
                                invoicenumberctrl.text.isEmpty ||
                                invoicedatectrl.text.isEmpty ||
                                invoicevaluectrl.text.isEmpty ||
                                HSN_SACctrl.text.isEmpty ||
                                GSTgoodsandservicesctrl.text.isEmpty ||
                                taxablevaluectrl.text.isEmpty ||
                                GSTquantityctrl.text.isEmpty ||
                                GSTunitctrl.text.isEmpty ||
                                ((IGSTRatectrl.text.isEmpty ||
                                        IGSTamountctrl.text.isEmpty) &&
                                    (SGSTratectrl.text.isEmpty ||
                                        SGSTamountctrl.text.isEmpty)) ||
                                CGSTratectrl.text.isEmpty ||
                                CGSTamountctrl.text.isEmpty ||
                                GSTimage == null) {
                              Get.defaultDialog(
                                  title: "",
                                  content: Text(
                                      "Please fill all the mandatory fields"));
                            } else if (modeofpayments == null) {
                              Get.defaultDialog(
                                  title: "",
                                  content:
                                      Text("Please provide mode of payment"));
                            } else {
                              uploadGSTimage();
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
          child: GSTvendorslistresponse == null
              ? Container(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _GSTitemlistresponse == null
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
                        forexample(GSTvendorslistresponse!.value, false, true),
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
                        forexample(_GSTitemlistresponse!.value, false, false),
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
                        Datefields(instrumentdatectrl, false, context),
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
                        fields(NonGST_goods_servicesctrl, true, false),
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
                        fields(NonGSTquantity_ctrl, false, false),
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
                              child: NonGSTimage == null
                                  ? Text(
                                      "Upload Image",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  : Image.file(NonGSTimage!),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        MaterialButton(
                          onPressed: () {
                            Get.to(addinvoicepaymentModeScreen(), arguments: [
                              int.parse(instrumenttotalvaluectrl.text),
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
                            setState(() {});
                            var modeofpayments = await DatabaseHelper.instance
                                .getNonGSTmodeofpayments();
                            print("modeofpayments=$modeofpayments");
                            if (Non_GSTvendorctrl.text.isEmpty ||
                                Non_GSTitemctrl.text.isEmpty ||
                                instrument_referance_numberctrl.text.isEmpty ||
                                instrumentdatectrl.text.isEmpty ||
                                instrument_valuectrl.text.isEmpty ||
                                NonGST_goods_servicesctrl.text.isEmpty ||
                                NonGSTquantity_ctrl.text.isEmpty ||
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
                                  content:
                                      Text("Please provide mode of payment"));
                            } else {
                              uploadNonGSTimage();
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
        keyboardType: text == true ? TextInputType.text : TextInputType.number,
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

  Datefields(
      TextEditingController controller, bool type, BuildContext context) {
    return Container(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.none,
        onTap: () async {
          print("date is about select");
          final DateTime? selectdate = await showDatePicker(
              context: context,
              initialDate: type == true ? GSTdate : NonGSTdate,
              firstDate: DateTime(1500),
              lastDate: DateTime.now());
          if (selectdate != null) {
            setState(() {
              type == true ? GSTdate = selectdate : NonGSTdate = selectdate;
            });
          }
          type == true
              ? invoicedatectrl.text =
                  "${GSTdate.day}-${GSTdate.month}-${GSTdate.year}"
              : instrumentdatectrl.text =
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

  TextEditingController GSTINctrl = TextEditingController();
  TextEditingController statectrl = TextEditingController();
  TextEditingController invoicenumberctrl = TextEditingController();
  TextEditingController invoicedatectrl = TextEditingController();
  TextEditingController invoicevaluectrl = TextEditingController();
  TextEditingController HSN_SACctrl = TextEditingController();
  TextEditingController GSTgoodsandservicesctrl = TextEditingController();
  TextEditingController taxablevaluectrl = TextEditingController();
  TextEditingController GSTquantityctrl = TextEditingController();
  TextEditingController GSTunitctrl = TextEditingController();
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
  TextEditingController NonGST_goods_servicesctrl = TextEditingController();
  TextEditingController NonGSTquantity_ctrl = TextEditingController();
  TextEditingController NonGSTtaxablevalctrl = TextEditingController();
  TextEditingController instrumentunitctrl = TextEditingController();
  TextEditingController instrumenttotalvaluectrl = TextEditingController();

  TextEditingController GSTvendorctrl = TextEditingController();
  TextEditingController GSTitemctrl = TextEditingController();
  TextEditingController Non_GSTvendorctrl = TextEditingController();
  TextEditingController Non_GSTitemctrl = TextEditingController();
  forexample(List option, bool type, bool names) {
    String novendormessage = "No Vendor found";
    String noitemmessage = "No Item found";
    return ValueListenableBuilder(
      valueListenable: type == true
          ? names == true
              ? GSTvendorslistresponse!
              : _GSTitemlistresponse!
          : names == true
              ? NonGSTvendorslistresponse!
              : _NonGSTitemlistresponse!,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
            child: TypeAheadField(
          noItemsFoundBuilder: (context) => const SizedBox(
            height: 50,
            child: Center(child: Text("Not available")),
          ),
          suggestionsBoxDecoration: const SuggestionsBoxDecoration(
            color: Colors.white,
            elevation: 4.0,
          ),
          suggestionsCallback: (Value) async {
            var search = type == true
                ? names == true
                    ? GSTvendorslistresponse!.value
                    : _GSTitemlistresponse!.value
                : names == true
                    ? NonGSTvendorslistresponse!.value
                    : _NonGSTitemlistresponse!.value;

            return search;
          },
          textFieldConfiguration: TextFieldConfiguration(
              onChanged: (value) {
                type == true
                    ? names == true
                        ? _GSTvendorapi()
                        : _Nonitemapi()
                    : names == true
                        ? _NonGSTvendorapi()
                        : _NonGSTitemapi();
                setState(() {
                  type == true
                      ? names == true
                          ? GSTvendorid = null
                          : GSTitemid = null
                      : names == true
                          ? NonGSTvendorid = null
                          : NonGSTitemid = null;
                });
                print("GST item= ${GSTitemctrl.text}");
                print("id's changed to ZERO");
              },
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
                    ? Non_GSTvendorctrl.text =
                        suggestion['vendorName'].toString()
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
            print("GSTvendorid=$GSTvendorid");
            print("GSTitemid=$GSTitemid");
            print("NonGSTvendorid=$NonGSTvendorid");
            print("NonGSTitemid=$NonGSTitemid");

            print("bata=$bata");
          },
        ));
      },
    );
  }
}
