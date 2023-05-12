// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

import 'home.dart';

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.edit))],
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
      ),
      body: Non_Gst(screensize),
    );
  }
}

Non_Gst(var screensize) {
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
                Text('Bill Image'),
                Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2, color: Color.fromARGB(255, 222, 222, 222)),
                  borderRadius: BorderRadius.circular(5)),
              height: screensize.height * 0.2,
              child: Center(
                child: Text(
                  "Upload Image",
                  style: TextStyle(color: Colors.grey),
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
                Text('Mode of payment'),
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
            SizedBox(
              height: 15,
            ),
            MaterialButton(
              onPressed: () {
                Get.to(homeScreen());
              },
              height: screensize.height * 0.065,
              color: Colors.red,
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
          borderSide:
              BorderSide(width: 2, color: Color.fromARGB(255, 216, 216, 216))),
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
