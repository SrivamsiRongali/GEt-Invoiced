// ignore_for_file: camel_case_types, prefer_const_constructors, file_names, unused_import, prefer_const_literals_to_create_immutables, duplicate_ignore, non_constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 49, 158, 248),
        appBar: AppBar(
          bottom: TabBar(
              indicator: BoxDecoration(color: Color.fromARGB(255, 3, 119, 214)),
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
        body: TabBarView(children: [
          Gst(),
          Container(
            color: Colors.white,
            child: Text('Non-GST'),
          )
        ]),
      ),
    );
  }
}

Gst() {
  return Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            fields(),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Text('Mode of Payment'),
                Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
            fields(),
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
          color: Color.fromARGB(255, 49, 158, 248),
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
        color: Color.fromARGB(255, 49, 158, 248),
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
