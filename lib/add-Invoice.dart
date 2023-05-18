// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names

import 'dart:io';

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

    super.initState();
  }

  PickedFile? _imageFile;
  File? image;
  ImagePicker _picker = ImagePicker();
  void takePhoto(ImageSource source) async {
    var pickedFile = await _picker.getImage(source: source);

    setState(() {
      // image = imagepermanent;
      image = File(pickedFile!.path);
    });

    print(image);
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

  Widget bottomSheet(double screenheight, double screenwidth) {
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
                    takePhoto(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera),
                  label: Text("camera")),
              // ignore: deprecated_member_use
              TextButton.icon(
                  onPressed: () {
                    takePhoto(ImageSource.gallery);
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
          child: Column(
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
              forexample(cities),
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
              forexample(itemNames),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
                    builder: ((builder) =>
                        bottomSheet(screensize.height, screensize.width)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 222, 222, 222)),
                      borderRadius: BorderRadius.circular(5)),
                  height: screensize.height * 0.2,
                  width: screensize.width * 0.7,
                  child: Center(
                    child: image == null
                        ? Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(image!),
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  Get.to(homeScreen());
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
          child: Column(
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
              forexample(cities),
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
              forexample(itemNames),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
              fields(),
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
                    builder: ((builder) =>
                        bottomSheet(screensize.height, screensize.width)),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2, color: Color.fromARGB(255, 222, 222, 222)),
                      borderRadius: BorderRadius.circular(5)),
                  height: screensize.height * 0.2,
                  width: screensize.width * 0.7,
                  child: Center(
                    child: image == null
                        ? Text(
                            "Upload Image",
                            style: TextStyle(color: Colors.grey),
                          )
                        : Image.file(image!),
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              MaterialButton(
                onPressed: () {
                  Get.to(homeScreen());
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
                      style: TextStyle(color: Colors.white, fontSize: 20),
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

  fields() {
    return TextFormField(
      decoration: InputDecoration(
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
    );
  }

  forexample(List<String> option) {
    return InputDecorator(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 4),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
          width: 2,
          color: Color.fromARGB(255, 29, 134, 182),
        )),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                width: 2, color: Color.fromARGB(255, 216, 216, 216))),
      ),
      child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue texteditingvalue) {
        if (texteditingvalue.text == "") {
          return Iterable.empty();
        } else {
          return option
              .where((element) => element
                  .toLowerCase()
                  .contains(texteditingvalue.text.toLowerCase()))
              .toList();
        }
      }),
    );
  }

  final List<String> itemNames = [
    'Biryani',
    'Milk',
    'Tissues',
    'Sanitizers',
    'Electricity',
    'Paper Plates',
  ];

  final List<String> cities = [
    'Amazon',
    'Flipkart',
    'Tea Point',
    'T-ruchi',
    'Zomato',
    'Insta Mart',
    'Swigy',
  ];
}
