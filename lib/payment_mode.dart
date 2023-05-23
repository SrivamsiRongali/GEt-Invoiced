// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoiced/databasehelper.dart';

class paymentModeScreen extends StatefulWidget {
  const paymentModeScreen({super.key});

  @override
  State<paymentModeScreen> createState() => _paymentModeScreenState();
}

class select {
  bool value;
  int num;
  TextEditingController numberctrl = TextEditingController();

  select({required this.value, required this.num});
}

class _paymentModeScreenState extends State<paymentModeScreen> {
  @override
  void initState() {
    super.initState();
    _modeofpaymentapi();
    remainingamount = ValueNotifier<int>(total);
  }

  Future _modeofpaymentapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();

    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/paymentMethods"),
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
        listresponse = mapresponse['message'];
      });
      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  List? listresponse;
  List<select> selectedval = List.empty(growable: true);
  int total = 1000;
  late ValueNotifier<int> remainingamount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 29, 134, 182),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Wrap(
                children: [
                  Text("reaminig"),
                  Text(
                    "${remainingamount.value}",
                    style: TextStyle(
                        color: remainingamount.value < 0
                            ? Colors.red
                            : Colors.black),
                  ),
                ],
              ),
              Container(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listresponse == null ? 1 : listresponse!.length,
                    itemBuilder: (context, index) {
                      selectedval.add(select(
                        value: false,
                        num: 0,
                      ));

                      return listresponse == null
                          ? Container(
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10, top: 10),
                              child: Container(
                                height: 40,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Checkbox(
                                              activeColor: Color.fromARGB(
                                                  255, 29, 134, 182),
                                              value: selectedval[index].value,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedval[index].value =
                                                      !selectedval[index].value;
                                                });
                                                if (selectedval[index].value ==
                                                    false) {
                                                  selectedval[index]
                                                      .numberctrl
                                                      .clear();
                                                }
                                              }),
                                          Text(listresponse![index]
                                              ['paymethodName']),
                                        ],
                                      ),
                                      Container(
                                        width: 200,
                                        child: Center(
                                          child: TextFormField(
                                            controller:
                                                selectedval[index].numberctrl,
                                            keyboardType: TextInputType.number,
                                            enabled: selectedval[index].value,
                                            decoration: InputDecoration(
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    196,
                                                                    196,
                                                                    196),
                                                            width: 2)),
                                                focusedBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 91, 171, 94),
                                                        width: 2)),
                                                enabledBorder: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Color.fromARGB(
                                                            255, 29, 134, 182),
                                                        width: 2))),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onChanged: (value) {
                                              int remaining = 0;
                                              for (int n = 0;
                                                  n < selectedval.length;
                                                  n++) {
                                                String num = selectedval[n]
                                                            .numberctrl
                                                            .text ==
                                                        ""
                                                    ? "0"
                                                    : selectedval[n]
                                                        .numberctrl
                                                        .text;
                                                setState(() {
                                                  remaining = remaining +
                                                      int.parse(num);
                                                });
                                              }
                                              setState(() {
                                                remainingamount.value =
                                                    total - remaining;
                                              });
                                              // selectedval[index].num =
                                              //     int.parse(value);

                                              print("numvalue=$remaining");
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
