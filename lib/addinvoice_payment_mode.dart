// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:invoiced/add-Invoice.dart';
import 'package:invoiced/databasehelper.dart';
import 'package:invoiced/pojoclass.dart';

class addinvoicepaymentModeScreen extends StatefulWidget {
  const addinvoicepaymentModeScreen({super.key});

  @override
  State<addinvoicepaymentModeScreen> createState() =>
      _addinvoicepaymentModeScreenState();
}

class select {
  bool value;
  int id;
  TextEditingController numberctrl = TextEditingController();

  select({required this.value, required this.id});
}

class _addinvoicepaymentModeScreenState
    extends State<addinvoicepaymentModeScreen> {
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
    var listofmodeofpayments = val[1] == null
        ? await DatabaseHelper.instance.getGSTmodeofpayments()
        : await DatabaseHelper.instance.getNonGSTmodeofpayments();

    response1 = await http.get(
      Uri.parse("http://192.168.0.101:8082/paymentMethods"),
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
        modeofpayments = listofmodeofpayments;
        if (modeofpayments != []) {
          // print("final mode of payment");
          for (int index = 0; index < listresponse!.length; index++) {
            selectedval.add(select(
                value: false, id: listresponse![index]["paymentMethodId"]));

            for (int n = 0; n < modeofpayments.length; n++) {
              // print("final mode of payment");
              if (listresponse![index]["paymentMethodId"] ==
                  modeofpayments[n]['modeOfPaymentId'] as int) {
                print("final mode of payment");
                selectedval[index].value = true;

                selectedval[index].numberctrl.text =
                    modeofpayments[n]['paymentValue'].toString();
              }
            }
          }
        }
        int remaining = 0;
        for (int n = 0; n < selectedval.length; n++) {
          String num = selectedval[n].numberctrl.text == ""
              ? "0"
              : selectedval[n].numberctrl.text;
          setState(() {
            remaining = remaining + int.parse(num);
          });
        }
        setState(() {
          remainingamount.value = (val[0]) - remaining;
        });
      });
      print("modeofpayment=$modeofpayments");
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
    final screensize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 29, 134, 182),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Text("Total"),
                      Text(
                        "${val[0]}",
                        style: TextStyle(
                            color: remainingamount.value < 0
                                ? Colors.red
                                : Colors.black),
                      ),
                    ],
                  ),
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
                        itemCount:
                            listresponse == null ? 0 : listresponse!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
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
                                              FocusScope.of(context).unfocus();
                                            }),
                                        Text(listresponse![index]
                                                ['paymentMethodName']
                                            .toString()),
                                      ],
                                    ),
                                    Container(
                                      width: 100,
                                      child: Center(
                                        child: TextFormField(
                                          onTapOutside: (event) {},
                                          controller:
                                              selectedval[index].numberctrl,
                                          keyboardType: TextInputType.number,
                                          enabled: selectedval[index].value,
                                          decoration: InputDecoration(
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Color.fromARGB(
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
                                                remaining =
                                                    remaining + int.parse(num);
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
                          await DatabaseHelper.instance
                              .removeGSTmodeofpayment();
                          for (int n = 0; n < selectedval.length; n++) {
                            if (selectedval[n].value == true) {
                              await DatabaseHelper.instance.addGSTmodeofpayment(
                                  Gstmodeofpayment(
                                      modeOfPaymentId: selectedval[n].id,
                                      paymentValue: int.parse(selectedval[n]
                                                  .numberctrl
                                                  .text
                                                  .length ==
                                              0
                                          ? "0"
                                          : selectedval[n].numberctrl.text)));
                            }
                          }
                          var data = await DatabaseHelper.instance
                              .getGSTmodeofpayments();
                          var result = json.encode(data);
                          print(result);

                          Get.back();
                        }
                      } else {
                        if (remainingamount.value == 0) {
                          await DatabaseHelper.instance
                              .removenonGSTmodeofpayment();
                          for (int n = 0; n < selectedval.length; n++) {
                            if (selectedval[n].value == true) {
                              await DatabaseHelper.instance
                                  .addNonGSTmodeofpayment(Nongstmodeofpayment(
                                      modeOfPaymentId: selectedval[n].id,
                                      paymentValue: int.parse(selectedval[n]
                                                  .numberctrl
                                                  .text
                                                  .length ==
                                              0
                                          ? "0"
                                          : selectedval[n].numberctrl.text)));
                            }
                          }

                          Get.back();
                        }
                      }
                    },
                    height: screensize.height * 0.065,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
