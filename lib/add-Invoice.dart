// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names, unnecessary_new, unnecessary_null_comparison, unused_local_variable

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
import 'itemscreen.dart';
import 'vendorscreen.dart';
import 'package:intl/intl.dart';

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
          "http://192.168.0.101:8082/searchVendor?vendorName=${addGSTvendorctrl.text}"),
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
          "http://192.168.0.101:8082/searchItem?itemName=${addGSTitemctrl.text}"),
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
          "http://192.168.0.101:8082/searchVendor?vendorName=${addNon_GSTvendorctrl.text}"),
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
          "http://192.168.0.101:8082/searchItem?itemName=${addNon_GSTitemctrl.text}"),
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
      print(addGSTitemctrl.text);
      print(modeofpayments);
      addGSTbillapi(
          1,
          addGSTvendorid.value,
          addGSTvendorctrl.text,
          addGSTitemid.value,
          addGSTitemctrl.text,
          GSTINctrl.text,
          stateid,
          invoicenumberctrl.text,
          "${GSTdate.year}-${GSTdate.month}-${GSTdate.day}",
          double.parse(invoicevaluectrl.text),
          HSN_SACctrl.text,
          GSTgoodsandservicesctrl.text,
          double.parse(taxablevaluectrl.text),
          double.parse(GSTquantityctrl.text),
          GSTunitctrl.text,
          double.parse(IGSTRatectrl.text == "" ? "0" : IGSTRatectrl.text),
          double.parse(IGSTamountctrl.text == "" ? "0" : IGSTamountctrl.text),
          double.parse(SGSTratectrl.text == "" ? "0" : SGSTratectrl.text),
          double.parse(SGSTamountctrl.text == "" ? "0" : SGSTamountctrl.text),
          double.parse(CGSTratectrl.text),
          double.parse(CGSTamountctrl.text),
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
      double invoiceval,
      String HSN_SACcode,
      String good_service_description,
      double taxableval,
      double quantity,
      String unit,
      double igstrate,
      double igstamount,
      double sgstrate,
      double sgstamopuint,
      double cgstrate,
      double cgstamount,
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
          addNonGSTvendorid.value,
          addNon_GSTvendorctrl.text,
          addNonGSTitemid.value,
          addNon_GSTitemctrl.text,
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
      String invoiceNumber,
      String dateOfInvoice,
      int instrumentValue,
      String goodsServiceDescription,
      int taxableValue,
      int quantity,
      String unit,
      int invoiceValue,
      String billImgaePath,
      List modeofPayments) async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
      "organizationId": orgid,
      "vendorId": vendorid,
      "vendorName": vendorname,
      "itemId": itemid,
      "itemName": itemName,
      "invoiceNumber": invoiceNumber,
      "dateOfInvoice": dateOfInvoice,
      "goodsServiceDescription": goodsServiceDescription,
      "taxableValue": taxableValue,
      "quantity": quantity,
      "unit": unit,
      "invoiceValue": invoiceValue,
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
                        ValueListenableBuilder(
                          valueListenable: addGSTvendor,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            addGSTvendorctrl.text = value;
                            return forexample(addGSTvendorctrl, true, true);
                          },
                        ),
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
                        ValueListenableBuilder(
                          valueListenable: addGSTitem,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            addGSTitemctrl.text = value;
                            return forexample(addGSTitemctrl, true, false);
                          },
                        ),
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
                        Column(
                          children: [
                            selectGst == false
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('IGST Rate'),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      gstfields(IGSTRatectrl, false, false),
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
                                      gstfields(IGSTRatectrl, false, false),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text('SGST Rate'),
                                          Text(
                                            "*",
                                            style: TextStyle(color: Colors.red),
                                          )
                                        ],
                                      ),
                                      gstfields(SGSTratectrl, false, false),
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
                                      gstfields(SGSTamountctrl, false, false),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                          ],
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
                        gstfields(CGSTratectrl, true, false),
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
                        gstfields(CGSTamountctrl, true, false),
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
                            if (addGSTvendorctrl.text.isEmpty ||
                                addGSTitemctrl.text.isEmpty ||
                                GSTINctrl.text.isEmpty ||
                                statectrl.text.isEmpty ||
                                invoicenumberctrl.text.isEmpty ||
                                invoicedatectrl.text.isEmpty ||
                                invoicevaluectrl.text.isEmpty ||
                                HSN_SACctrl.text.isEmpty ||
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
                        ValueListenableBuilder(
                          valueListenable: addNon_GSTvendor,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            addNon_GSTvendorctrl.text = addNon_GSTvendor.value;
                            return forexample(
                                addNon_GSTvendorctrl, false, true);
                          },
                        ),
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
                        ValueListenableBuilder(
                          valueListenable: addNon_GSTitem,
                          builder: (BuildContext context, dynamic value,
                              Widget? child) {
                            addNon_GSTitemctrl.text = value;
                            return forexample(addNon_GSTitemctrl, false, false);
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text('Invoice number'),
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
                            Text('Invoice date'),
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
                            Text('Invoice value'),
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
                            if (addNon_GSTvendorctrl.text.isEmpty ||
                                addNon_GSTitemctrl.text.isEmpty ||
                                instrument_referance_numberctrl.text.isEmpty ||
                                instrumentdatectrl.text.isEmpty ||
                                instrument_valuectrl.text.isEmpty ||
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
  gstfields(TextEditingController controller, bool cgst, bool state) {
    return Container(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        enabled: !state,
        onChanged: (value) async {
          print("value add=${value.toUpperCase()}");
          if (selectGst == true) {
            if (value.isNotEmpty) {
              var SGSTamount;
              SGSTamount = (double.parse(taxablevaluectrl.text) / 100) *
                  double.parse(SGSTratectrl.text);
              SGSTamountctrl.text = SGSTamount.toString();
            } else {
              SGSTamountctrl.clear();
            }
          } else {
            if (value.isNotEmpty) {
              var IGSTamount;
              IGSTamount = (double.parse(taxablevaluectrl.text) / 100) *
                  double.parse(IGSTRatectrl.text);
              IGSTamountctrl.text = IGSTamount.toString();
            } else {
              IGSTamountctrl.clear();
            }
          }
          if (cgst == true) {
            if (value.isNotEmpty) {
              var CGSTamount;
              CGSTamount = (double.parse(taxablevaluectrl.text) / 100) *
                  double.parse(CGSTratectrl.text);
              CGSTamountctrl.text = CGSTamount.toString();
            } else {
              CGSTamountctrl.clear();
            }
          }
        },
        inputFormatters: [
          // FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
          TextInputFormatter.withFunction((oldValue, newValue) {
            try {
              final text = newValue.text;
              if (text.isNotEmpty) double.parse(text);
              return newValue;
            } catch (e) {}
            return oldValue;
          }),
        ],
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

  bool selectGst = true;

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
                  val == "TS" ? selectGst = true : selectGst = false;
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
        inputFormatters: text == true
            ? []
            : [
                // FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                TextInputFormatter.withFunction((oldValue, newValue) {
                  try {
                    final text = newValue.text;
                    if (text.isNotEmpty) double.parse(text);
                    return newValue;
                  } catch (e) {}
                  return oldValue;
                }),
              ],
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
              ? invoicedatectrl.text = "${DateFormat('yMMMd').format(GSTdate)}"
              : instrumentdatectrl.text =
                  "${DateFormat('yMMMd').format(NonGSTdate)}";
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
  TextEditingController addGSTitemctrl = TextEditingController();
  TextEditingController addNon_GSTvendorctrl = TextEditingController();
  TextEditingController addNon_GSTitemctrl = TextEditingController();
  TextEditingController addGSTvendorctrl = TextEditingController();

  forexample(TextEditingController controller, bool type, bool names) {
    return Container(
        height: 50,
        child: TextFormField(
          keyboardType: TextInputType.none,
          onTap: () {
            type == true
                ? names == true
                    ? Get.to(vendorsScreen(), arguments: [true, true])
                    : Get.to(items(), arguments: [true, true])
                : names == true
                    ? Get.to(vendorsScreen(), arguments: [true, false])
                    : Get.to(items(), arguments: [true, false]);
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
        ));

    //  ValueListenableBuilder(
    //   valueListenable: type == true
    //       ? names == true
    //           ? GSTvendorslistresponse!
    //           : _GSTitemlistresponse!
    //       : names == true
    //           ? NonGSTvendorslistresponse!
    //           : _NonGSTitemlistresponse!,
    //   builder: (BuildContext context, dynamic value, Widget? child) {
    //     return Container(
    //         child: TypeAheadField(
    //       noItemsFoundBuilder: (context) => const SizedBox(
    //         height: 50,
    //         child: Center(child: Text("Not available")),
    //       ),
    //       suggestionsBoxDecoration: const SuggestionsBoxDecoration(
    //         color: Colors.white,
    //         elevation: 4.0,
    //       ),
    //       suggestionsCallback: (Value) async {
    //         var search = type == true
    //             ? names == true
    //                 ? GSTvendorslistresponse!.value
    //                 : _GSTitemlistresponse!.value
    //             : names == true
    //                 ? NonGSTvendorslistresponse!.value
    //                 : _NonGSTitemlistresponse!.value;

    //         return search;
    //       },
    //       textFieldConfiguration: TextFieldConfiguration(
    //           onTap: () {
    //             type == true
    //                 ? names == true
    //                     ? Get.to(vendorsScreen(), arguments: [true, true])
    //                     : Get.to(items(), arguments: [true, false])
    //                 : names == true
    //                     ? Get.to(vendorsScreen(), arguments: [true, false])
    //                     : Get.to(items(), arguments: [true, false]);
    //           },
    //           onChanged: (value) {
    //             type == true
    //                 ? names == true
    //                     ? _GSTvendorapi()
    //                     : _Nonitemapi()
    //                 : names == true
    //                     ? _NonGSTvendorapi()
    //                     : _NonGSTitemapi();
    //             setState(() {
    //               type == true
    //                   ? names == true
    //                       ? addGSTvendorid.value = 0
    //                       : addGSTitemid.value = 0
    //                   : names == true
    //                       ? addNonGSTvendorid.value = 0
    //                       : addNonGSTitemid.value = 0;
    //             });
    //             print("GST item= ${addGSTitemctrl.text}");
    //             print("id's changed to ZERO");
    //           },
    //           controller: type == true
    //               ? names == true
    //                   ? addGSTvendorctrl
    //                   : addGSTitemctrl
    //               : names == true
    //                   ? addNon_GSTvendorctrl
    //                   : addNon_GSTitemctrl,
    //           decoration: InputDecoration(
    //             focusedBorder: const OutlineInputBorder(
    //               borderSide: BorderSide(
    //                 width: 2,
    //                 color: Color.fromARGB(255, 29, 134, 182),
    //               ),
    //             ),
    //             border: OutlineInputBorder(
    //                 borderRadius: BorderRadius.circular(
    //               10.0,
    //             )),
    //             enabledBorder: const OutlineInputBorder(
    //                 borderRadius: BorderRadius.all(
    //                   Radius.circular(5.0),
    //                 ),
    //                 borderSide: BorderSide(
    //                   width: 2,
    //                   color: Color.fromARGB(255, 216, 216, 216),
    //                 )),
    //             contentPadding: const EdgeInsets.only(top: 4, left: 10),
    //           )),
    //       debounceDuration: const Duration(seconds: 1),
    //       itemBuilder: (context, suggestion) {
    //         // print(sugg);
    //         return Row(
    //           children: [
    //             Flexible(
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Text(
    //                   names == true
    //                       ? suggestion['vendorName'].toString()
    //                       : suggestion['itemName'].toString(),
    //                   maxLines: 1,
    //                   style: TextStyle(color: Colors.black),
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ),
    //             )
    //           ],
    //         );
    //       },
    //       onSuggestionSelected: (suggestion) async {
    //         // String sugg = suggestion.toString();
    //         type == true
    //             ? names == true
    //                 ? addGSTvendorctrl.text =
    //                     suggestion['vendorName'].toString()
    //                 : addGSTitemctrl.text = suggestion['itemName'].toString()
    //             : names == true
    //                 ? addNon_GSTvendorctrl.text =
    //                     suggestion['vendorName'].toString()
    //                 : addNon_GSTitemctrl.text =
    //                     suggestion['itemName'].toString();
    //         String bata;
    //         type == true
    //             ? bata = suggestion['vendorName'].toString()
    //             : bata = suggestion['itemName'].toString();
    //         setState(() {
    //           type == true
    //               ? names == true
    //                   ? addGSTvendorid.value = suggestion["vendorId"]
    //                   : addGSTitemid.value = suggestion["itemId"]
    //               : names == true
    //                   ? addNonGSTvendorid.value = suggestion["vendorId"]
    //                   : addNonGSTitemid.value = suggestion["itemId"];
    //         });
    //         print("addGSTvendorid.value=$addGSTvendorid.value");
    //         print("addGSTitemid.value=$addGSTitemid.value");
    //         print("addNonGSTvendorid.value=$addNonGSTvendorid.value");
    //         print("addNonGSTitemid.value=$addNonGSTitemid.value");

    //         print("bata=$bata");
    //       },
    //     ));
    //   },
    // );
  }
}
