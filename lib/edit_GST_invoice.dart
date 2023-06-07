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
import 'package:invoiced/addinvoice_payment_mode.dart';
import 'package:invoiced/pojoclass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'editinvoice_payment_mode.dart';
import 'home.dart';
import 'itemscreen.dart';
import 'vendorscreen.dart';

class editGSTInvoiceScreen extends StatefulWidget {
  const editGSTInvoiceScreen({super.key});

  @override
  State<editGSTInvoiceScreen> createState() => _editGSTInvoiceScreenState();
}

class _editGSTInvoiceScreenState extends State<editGSTInvoiceScreen> {
  @override
  void initState() {
    // TODO: implement initState

    GSTvendorslistresponse = ValueNotifier<List>([]);
    _GSTitemlistresponse = ValueNotifier<List>([]);

    _GSTbillapi();
    _vendorapi();
    _itemapi();
    _stateapi();
    super.initState();
  }

  List? listresponse;
  Future _GSTbillapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("GST bill api request is sent");
    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/gstBill/$billid"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('successful got bill data');
      mapresponse = json.decode(response1.body);
      print(response1.body);
      setState(() {
        listresponse = mapresponse['message'];
        editGSTvendorid.value = listresponse![0]["vendorId"];
        editGSTitemid.value = listresponse![0]["itemId"];
        stateid = listresponse![0]["stateId"];
      });
      var date = DateTime.fromMillisecondsSinceEpoch(
          listresponse![0]["dateOfInvoice"]);
      editGSTvendor.value = listresponse![0]["vendorName"].toString();
      editGSTitem.value = listresponse![0]["itemName"].toString();
      editGSTvendorctrl.text = listresponse![0]["vendorName"].toString();
      editGSTitemctrl.text = listresponse![0]["itemName"].toString();
      GSTINctrl.text = listresponse![0]["gstin"].toString();
      statectrl.text = listresponse![0]["stateName"].toString();
      invoicenumberctrl.text = listresponse![0]["invoiceNumber"].toString();
      invoicedatectrl.text = "${date.day}-${date.month}-${date.year}";
      invoicevaluectrl.text = listresponse![0]["invoiceValue"].toString();
      HSN_SACctrl.text = listresponse![0]["hsnSacCode"].toString();
      goodsandservicesctrl.text =
          listresponse![0]["goodsServiceDescription"].toString();
      taxablevaluectrl.text = listresponse![0]["taxableValue"].toString();
      quantityctrl.text = listresponse![0]["quantity"].toString();
      unitctrl.text = listresponse![0]["unit"].toString();
      IGSTRatectrl.text = listresponse![0]["igstRate"].toString();
      IGSTamountctrl.text = listresponse![0]["igstAmount"].toString();
      SGSTratectrl.text = listresponse![0]["sgstRate"].toString();
      SGSTamountctrl.text = listresponse![0]["sgstAmount"].toString();
      CGSTratectrl.text = listresponse![0]["cgstRate"].toString();
      CGSTamountctrl.text = listresponse![0]["cgstAmount"].toString();
      if (listresponse![0]["modeOfPayments"] != null) {
        for (int n = 0; n < listresponse![0]["modeOfPayments"].length; n++) {
          await DatabaseHelper.instance.addGSTmodeofpayment(Gstmodeofpayment(
            modeOfPaymentId: listresponse![0]["modeOfPayments"][n]
                ['modeOfPaymentId'],
            paymentValue: listresponse![0]["modeOfPayments"][n]['paymentValue'],
            updateForBillPayment: listresponse![0]["modeOfPayments"][n]
                        ['updateForBillPayment'] ==
                    null
                ? 0
                : listresponse![0]["modeOfPayments"][n]['updateForBillPayment'],
            billPaymentId: listresponse![0]["modeOfPayments"][n]
                ['billPaymentId'],
          ));
        }
      }
      print("GST bill = $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  ValueNotifier<List>? GSTvendorslistresponse;

  Future _vendorapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("vendor api request is sent");
    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchVendor?vendorName=${editGSTvendorctrl.text}"),
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
  Future _itemapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("item api request is sent");

    response1 = await http.get(
      Uri.parse(
          "http://192.168.0.101:8082/searchItem?itemName=${editGSTitemctrl.text}"),
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

  uploadGSTimage() async {
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("image is being replaced");
    var stream = http.ByteStream(GSTimage!.openRead());
    stream.cast();
    var length = await GSTimage!.length();
    var request = new http.MultipartRequest(
        "POST", Uri.parse("http://192.168.0.101:8082/addBillImage"));

    // Map<String, String> headers = {
    //   "Accept": "*/*",
    //   "Content-Type": "application/json",
    //   "Authorization": "Bearer ${token[0]["appToken"]}"
    // };
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
      print(res.body);
      print("${val['billImagePath']}");
      var modeofpayments = await DatabaseHelper.instance.getGSTmodeofpayments();

      editGSTbillapi(
          1,
          editGSTvendorid.value,
          editGSTvendorctrl.text,
          editGSTitemid.value,
          editGSTitemctrl.text,
          GSTINctrl.text,
          stateid,
          invoicenumberctrl.text,
          "${GSTdate.year}-${GSTdate.month}-${GSTdate.day}",
          int.parse(invoicevaluectrl.text),
          HSN_SACctrl.text,
          goodsandservicesctrl.text,
          int.parse(taxablevaluectrl.text),
          int.parse(quantityctrl.text),
          unitctrl.text,
          int.parse(IGSTRatectrl.text == "" ? "0" : IGSTRatectrl.text),
          int.parse(IGSTamountctrl.text == "" ? "0" : IGSTamountctrl.text),
          int.parse(SGSTratectrl.text == "" ? "0" : SGSTratectrl.text),
          int.parse(SGSTamountctrl.text == "" ? "0" : SGSTamountctrl.text),
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

  DateTime GSTdate = DateTime.now();
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
              initialDate: GSTdate,
              firstDate: DateTime(1500),
              lastDate: DateTime.now());
          if (selectdate != null) {
            setState(() {
              GSTdate = selectdate;
            });
          }
          invoicedatectrl.text =
              "${GSTdate.day}-${GSTdate.month}-${GSTdate.year}";
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

  editGSTbillapi(
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
    print(dateofinvoice);
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var data = json.encode({
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
      "billCreatedOn": "",
      "billCreatedBy": "",
      "billUpdatedOn": "",
      "billUpdatedBy": "",
      "modeOfPayments": modeofPayments
    });

    Map mapresponse;

    http.Response response =
        await http.put(Uri.parse("http://192.168.0.101:8082/gstBill/$billid"),
            headers: {
              "accept": "*/*",
              "Content-Type": "application/json",
              "Authorization": "Bearer ${token[0]["appToken"]}"
            },
            body: data);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      mapresponse = json.decode(response.body);

      Get.to(homeScreen());
    } else {
      print("Edit Failed");
    }
  }

  bool edit = false;
  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              await DatabaseHelper.instance.removeGSTmodeofpayment();

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
              : GSTvendorslistresponse!.value == null
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
                                Text('Bill Image'),
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
                                            true)))
                                    : Text("not editable");
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 222, 222, 222)),
                                    borderRadius: BorderRadius.circular(5)),
                                height: screensize.height * 0.2,
                                width: screensize.width * 0.9,
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
                              valueListenable: editGSTvendor,
                              builder: (context, value, child) {
                                editGSTvendorctrl.text = value;
                                return Container(
                                    child: forexample(
                                        editGSTvendorctrl, edit, true));
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
                              valueListenable: editGSTitem,
                              builder: (BuildContext context, dynamic value,
                                  Widget? child) {
                                editGSTitemctrl.text = value;
                                return Container(
                                    child: forexample(
                                        editGSTitemctrl, edit, false));
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
                            fields(GSTINctrl, true, false, edit),
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
                            fields(statectrl, true, true, edit),
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
                            fields(invoicenumberctrl, true, false, edit),
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
                            Datefields(invoicedatectrl, true, context, edit),
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
                            fields(invoicevaluectrl, false, false, edit),
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
                            fields(HSN_SACctrl, true, false, edit),
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
                            fields(goodsandservicesctrl, true, false, edit),
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
                            fields(taxablevaluectrl, false, false, edit),
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
                            fields(quantityctrl, false, false, edit),
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
                            fields(unitctrl, true, false, edit),
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
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                                style: TextStyle(
                                                    color: Colors.red),
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
                                                style: TextStyle(
                                                    color: Colors.red),
                                              )
                                            ],
                                          ),
                                          gstfields(
                                              SGSTamountctrl, false, false),
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
                            MaterialButton(
                              onPressed: () {
                                if (listresponse![0]['modeOfPayments'] ==
                                    null) {
                                  Get.defaultDialog(
                                      title: "", content: Text("unavailable"));
                                } else {
                                  Get.to(editinvoicepaymentModeScreen(),
                                      arguments: [
                                        int.parse(invoicevaluectrl.text),
                                        true
                                      ]);
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
                                var modeofpayments = await DatabaseHelper
                                    .instance
                                    .getGSTmodeofpayments();
                                print("modeofpayments=$modeofpayments");
                                if (edit == true) {
                                  if (editGSTvendorctrl.text.isEmpty ||
                                      editGSTitemctrl.text.isEmpty ||
                                      GSTINctrl.text.isEmpty ||
                                      statectrl.text.isEmpty ||
                                      invoicenumberctrl.text.isEmpty ||
                                      invoicedatectrl.text.isEmpty ||
                                      invoicevaluectrl.text.isEmpty ||
                                      HSN_SACctrl.text.isEmpty ||
                                      taxablevaluectrl.text.isEmpty ||
                                      quantityctrl.text.isEmpty ||
                                      unitctrl.text.isEmpty ||
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
                                        content: Text(
                                            "Please provide mode of payment"));
                                  } else {
                                    editGSTvendorid == null
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
                                        : editGSTitemid == null
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
                                                          child: Text("Cancel"),
                                                        ),
                                                        MaterialButton(
                                                          onPressed: () {},
                                                          child: Text("Ok"),
                                                        )
                                                      ],
                                                    )
                                                  ])
                                            : uploadGSTimage();
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
                                    'Save Changes',
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
                                _DeleteGSTbillapi();
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
    );
  }

  var billid = Get.arguments;

  Future _DeleteGSTbillapi() async {
    Map mapresponse;
    http.Response response1;

    var token = await DatabaseHelper.instance.getbookkeepermodel();
    print("Non GST bill api request is sent");
    response1 = await http.delete(
      Uri.parse("http://192.168.0.101:8082/gstBill/$billid"),
      headers: {
        "accept": "*/*",
        "Content-Type": "application/json",
        "Authorization": "Bearer ${token[0]["appToken"]}"
      },
    );
    if (response1.statusCode == 200) {
      print('Deleted successful');
      mapresponse = json.decode(response1.body);
      Get.offAll(homeScreen());
      print(response1.body);
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  gstfields(TextEditingController controller, bool cgst, bool state) {
    return Container(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        enabled: !state,
        onChanged: (value) async {
          print("value add=${value.toUpperCase()}");
          if (selectGst == true) {
            if (value.isNotEmpty) {
              var SGSTamount;
              SGSTamount = (int.parse(taxablevaluectrl.text) / 100) *
                  int.parse(SGSTratectrl.text);
              SGSTamountctrl.text = SGSTamount.toString();
            } else {
              SGSTamountctrl.clear();
            }
          } else {
            if (value.isNotEmpty) {
              var IGSTamount;
              IGSTamount = (int.parse(taxablevaluectrl.text) / 100) *
                  int.parse(IGSTRatectrl.text);
              IGSTamountctrl.text = IGSTamount.toString();
            } else {
              IGSTamountctrl.clear();
            }
          }
          if (cgst == true) {
            if (value.isNotEmpty) {
              var CGSTamount;
              CGSTamount = (int.parse(taxablevaluectrl.text) / 100) *
                  int.parse(CGSTratectrl.text);
              CGSTamountctrl.text = CGSTamount.toString();
            } else {
              CGSTamountctrl.clear();
            }
          }
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                    takeGSTPhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("camera")),
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () {
                    takeGSTPhoto(ImageSource.gallery);
                  },
                  icon: Icon(Icons.image),
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  var stateid;

  fields(TextEditingController controller, bool text, bool state, bool enable) {
    return Container(
      height: 50,
      child: TextFormField(
        enabled: !state == true ? enable : !state,
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
  TextEditingController editGSTvendorctrl = TextEditingController();
  TextEditingController editGSTitemctrl = TextEditingController();
  forexample(TextEditingController controller, bool enable, bool names) {
    return ValueListenableBuilder(
      valueListenable:
          names == true ? GSTvendorslistresponse! : _GSTitemlistresponse!,
      builder: (BuildContext context, dynamic value, Widget? child) {
        return Container(
            height: 50,
            child: TextFormField(
              keyboardType: TextInputType.none,
              enabled: enable,
              onTap: () {
                names == true
                    ? Get.to(vendorsScreen(), arguments: [false, true])
                    : Get.to(items(), arguments: [
                        false,
                        true,
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
            ));
        // Container(
        //     child: TypeAheadField(
        //   // noItemsFoundBuilder: (context) => const SizedBox(
        //   //   height: 50,
        //   //   child: Center(
        //   //     child: Text(names==true?"No Vendor Found" :'No Item Found'),
        //   //   ),
        //   // ),
        //   suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        //     color: Colors.white,
        //     elevation: 4.0,
        //   ),
        //   suggestionsCallback: (Value) async {
        //     var search = names == true
        //         ? GSTvendorslistresponse!.value
        //         : _GSTitemlistresponse!.value;
        //     print(search);
        //     return search;
        //   },
        //   textFieldConfiguration: TextFieldConfiguration(
        //       onTap: () {
        //         names == true
        //             ? Get.to(vendorsScreen(), arguments: [false, true])
        //             : Get.to(items(), arguments: [false, true]);
        //       },
        //       onChanged: (value) {
        //         names == true ? _vendorapi() : _itemapi();
        //         setState(() {
        //           names == true
        //               ? editGSTvendorid.value = 0
        //               : editGSTitemid.value = 0;
        //         });
        //       },
        //       enabled: enable,
        //       controller: names == true ? editGSTvendorctrl : editGSTitemctrl,
        //       decoration: InputDecoration(
        //         disabledBorder: const OutlineInputBorder(
        //             borderRadius: BorderRadius.all(
        //               Radius.circular(5.0),
        //             ),
        //             borderSide: BorderSide(
        //               width: 2,
        //               color: Color.fromARGB(255, 216, 216, 216),
        //             )),
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
        //         ? editGSTvendorctrl.text = suggestion['vendorName'].toString()
        //         : editGSTitemctrl.text = suggestion['itemName'].toString();

        //     String bata;
        //     names == true
        //         ? bata = suggestion['vendorName'].toString()
        //         : bata = suggestion['itemName'].toString();
        //     setState(() {
        //       names == true
        //           ? editGSTvendorid.value = suggestion["vendorId"]
        //           : editGSTitemid.value = suggestion["itemId"];
        //     });

        //     print("bata=$bata");
        //   },
        // ));
      },
    );
  }
}
