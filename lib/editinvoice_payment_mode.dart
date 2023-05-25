// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoiced/databasehelper.dart';
import 'package:invoiced/pojoclass.dart';

import 'addinvoice_payment_mode.dart';
import 'edit_GST_invoice.dart';
import 'edit_Non_GST_Invoice.dart';
import 'home.dart';

class editinvoicepaymentModeScreen extends StatefulWidget {
  const editinvoicepaymentModeScreen({super.key});

  @override
  State<editinvoicepaymentModeScreen> createState() =>
      _editinvoicepaymentModeScreenState();
}

// class select {
//   bool value;
//   int id;
//   TextEditingController numberctrl = TextEditingController();

//   select({
//     required this.value,required this.id
//   });
// }

class _editinvoicepaymentModeScreenState
    extends State<editinvoicepaymentModeScreen> {
  @override
  void initState() {
    super.initState();
    _modeofpaymentapi();
    remainingamount = ValueNotifier<int>(val[0]);
  }

  var modeofpayments;
  Future _modeofpaymentapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var listofmodeofpayments =
        await DatabaseHelper.instance.getmodeofpayments();
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
        modeofpayments = listofmodeofpayments;
      });

      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  var val = Get.arguments;
  List? listresponse;
  List<select> selectedval = List.empty(growable: true);

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
                          id: listresponse![index]["paymentMethodId"]));

                      if (modeofpayments != null) {
                        for (int n = 0; n < val[1].length; n++) {
                          if (listresponse![index]["paymentMethodId"] ==
                              modeofpayments[n]['paymentMethodId']) {
                            setState(() {
                              selectedval[index].numberctrl.text =
                                  modeofpayments[n]['paymentValue'].toString();
                            });
                          }
                        }
                      }

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
                                                  ['paymentMethodName']
                                              .toString()),
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
                                                    (val[0]) - remaining;
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
              MaterialButton(
                color: remainingamount.value == 0
                    ? Color.fromARGB(255, 91, 171, 94)
                    : Color.fromARGB(255, 191, 191, 191),
                onPressed: () async {
                  if (val[1] == true) {
                    if (remainingamount.value == 0) {
                      await DatabaseHelper.instance.removemodeofpayment();
                      for (int n = 0; n < selectedval.length; n++) {
                        if (selectedval[n].value == true) {
                          await DatabaseHelper.instance.addmodeofpayment(
                              Modeofpayment(
                                  modeOfPaymentId: selectedval[n].id,
                                  paymentValue: int.parse(
                                      selectedval[n].numberctrl.text.length == 0
                                          ? "0"
                                          : selectedval[n].numberctrl.text)));
                        }
                      }
                      var data =
                          await DatabaseHelper.instance.getmodeofpayments();
                      print("data=$data");
                    }
                  } else {
                    if (remainingamount.value == 0) {
                      await DatabaseHelper.instance.removemodeofpayment();
                      for (int n = 0; n < selectedval.length; n++) {
                        if (selectedval[n].value == true) {
                          await DatabaseHelper.instance.addmodeofpayment(
                              Modeofpayment(
                                  modeOfPaymentId: selectedval[n].id,
                                  paymentValue: int.parse(
                                      selectedval[n].numberctrl.text.length == 0
                                          ? "0"
                                          : selectedval[n].numberctrl.text)));
                        }
                      }
                      var data =
                          await DatabaseHelper.instance.getmodeofpayments();
                      print("data=$data");
                    }
                  }
                },
                child: Text("Save"),
              )
            ],
          ),
        ),
      ),
    );
  }
}