// ignore_for_file: prefer_const_constructors, unused_import

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
    paymentdata = ValueNotifier<List>(List.empty());
  }

  var modeofpayments;
  Future _modeofpaymentapi() async {
    Map mapresponse;
    http.Response response1;
    var token = await DatabaseHelper.instance.getbookkeepermodel();
    var listofmodeofpayments = val[1] == true
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
        print("$listofmodeofpayments");
        listresponse = mapresponse['message'];
        modeofpayments = listofmodeofpayments;
        if (modeofpayments != []) {
          // print("final mode of payment");
          for (int index = 0; index < listresponse!.length; index++) {
            selectedval.add(select(
                value: false,
                id: listresponse![index]["paymentMethodId"],
                update: false,
                billPaymentId: null,
                updateForBillPayment: 0));

            for (int n = 0; n < modeofpayments.length; n++) {
              // print("final mode of payment");
              if (listresponse![index]["paymentMethodId"] ==
                  modeofpayments[n]['modeOfPaymentId']) {
                print("final mode of payment");
                selectedval[index].value = true;
                selectedval[index].billPaymentId =
                    modeofpayments[n]['billPaymentId'];
                selectedval[index].updateForBillPayment =
                    modeofpayments[n]['updateForBillPayment'];
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

      print("listresponse= $listresponse");
    } else {
      print(response1.body);
      print('fetch unsuccessful');
    }
  }

  var val = Get.arguments;
  List? listresponse;
  List<select> selectedval = List.empty(growable: true);
  late ValueNotifier<List> paymentdata;
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
                  Text("remainig"),
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
                                                  if (selectedval[index]
                                                          .value ==
                                                      false) {
                                                    selectedval[index]
                                                        .numberctrl
                                                        .clear();
                                                  }
                                                });

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
                                                selectedval[index].value == true
                                                    ? selectedval[index].billPaymentId !=
                                                                null &&
                                                            selectedval[index]
                                                                    .billPaymentId! >=
                                                                0
                                                        ? selectedval[index]
                                                                .billPaymentId =
                                                            selectedval[index]
                                                                .billPaymentId
                                                        : selectedval[index]
                                                            .billPaymentId = 0
                                                    : selectedval[index].billPaymentId !=
                                                                null &&
                                                            selectedval[index]
                                                                    .billPaymentId! >
                                                                0
                                                        ? selectedval[index]
                                                                .billPaymentId =
                                                            selectedval[index]
                                                                .billPaymentId
                                                        : selectedval[index]
                                                                .billPaymentId =
                                                            null;
                                                print("chnaged value");
                                                print(selectedval[index]
                                                    .billPaymentId
                                                    .toString());
                                                print("chnaged value");

                                                setState(() {
                                                  remainingamount.value =
                                                      (val[0]) - remaining;

                                                  // selectedval[index].billPaymentId ==
                                                  //         -1
                                                  //     ? selectedval[index]
                                                  //                 .value ==
                                                  //             true
                                                  //         ? selectedval[index]
                                                  //             .billPaymentId = 0
                                                  //         : selectedval[index]
                                                  //                 .billPaymentId =
                                                  //             -1
                                                  //     : selectedval[index]
                                                  //                 .billPaymentId ==
                                                  //             0
                                                  //         ? selectedval[index]
                                                  //                     .value ==
                                                  //                 true
                                                  //             ? selectedval[
                                                  //                         index]
                                                  //                     .billPaymentId =
                                                  //                 0
                                                  //             : selectedval[
                                                  //                         index]
                                                  //                     .billPaymentId =
                                                  //                 -1
                                                  //         : selectedval[index]
                                                  //                 .billPaymentId =
                                                  //             selectedval[index]
                                                  //                 .billPaymentId;
                                                });
                                                print(selectedval[index]
                                                    .billPaymentId);
                                                print(selectedval[index].id);
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
                      paymentdata.value =
                          await DatabaseHelper.instance.getGSTmodeofpayments();
                      print("outer data = ${paymentdata.value}");
                      for (int n = 0; n < selectedval.length; n++) {
                        // print("local data = $paymentdata");

                        for (int m = 0; m < paymentdata.value.length; m++) {
                          paymentdata.value = await DatabaseHelper.instance
                              .getGSTmodeofpayments();
                          print("local data = $paymentdata");
                          if ((selectedval[n].billPaymentId ==
                                  paymentdata.value[m]['billPaymentId']) &&
                              (selectedval[n].numberctrl.text !=
                                  paymentdata.value[m]['paymentValue']
                                      .toString()) &&
                              (selectedval[n].id ==
                                  paymentdata.value[m]['modeOfPaymentId']) &&
                              selectedval[n].billPaymentId! > 0) {
                            await DatabaseHelper.instance
                                .updateGSTmodeofpayment(
                              1,
                              selectedval[n].billPaymentId as int,
                              selectedval[n].id,
                              int.parse(
                                  selectedval[n].numberctrl.text.length == 0
                                      ? "0"
                                      : selectedval[n].numberctrl.text),
                            );
                            selectedval[n].update = true;
                            break;
                          } else if ((selectedval[n].billPaymentId ==
                                  paymentdata.value[m]['billPaymentId']) &&
                              (selectedval[n].numberctrl.text.isEmpty) &&
                              (selectedval[n].id ==
                                  paymentdata.value[m]['modeOfPaymentId']) &&
                              (selectedval[n].value == false) &&
                              selectedval[n].billPaymentId! > 0) {
                            await DatabaseHelper.instance
                                .updateGSTmodeofpayment(
                              1,
                              selectedval[n].billPaymentId as int,
                              selectedval[n].id,
                              0,
                            );
                            selectedval[n].update = true;
                            break;
                          } else if (selectedval[n]
                                  .numberctrl
                                  .text
                                  .isNotEmpty &&
                              (selectedval[n].value == true) &&
                              selectedval[n].billPaymentId == 0 &&
                              selectedval[n].update == true &&
                              selectedval[n].id ==
                                  paymentdata.value[m]['modeOfPaymentId']) {
                            print("updated");
                            await DatabaseHelper.instance
                                .updateGSTmodeofpayment(
                              0,
                              0,
                              selectedval[n].id,
                              int.parse(
                                  selectedval[n].numberctrl.text.length == 0
                                      ? "0"
                                      : selectedval[n].numberctrl.text),
                            );
                            selectedval[n].update = true;
                            break;
                          } else if (selectedval[n]
                                  .numberctrl
                                  .text
                                  .isNotEmpty &&
                              (selectedval[n].value == true) &&
                              selectedval[n].update == false &&
                              selectedval[n].billPaymentId == 0 &&
                              selectedval[n].id !=
                                  paymentdata.value[m]['modeOfPaymentId']) {
                            print("added once");
                            await DatabaseHelper.instance.addGSTmodeofpayment(
                                Gstmodeofpayment(
                                    modeOfPaymentId: selectedval[n].id,
                                    paymentValue: int.parse(
                                        selectedval[n].numberctrl.text.length ==
                                                0
                                            ? "0"
                                            : selectedval[n].numberctrl.text),
                                    updateForBillPayment: 0,
                                    billPaymentId: 0));
                            selectedval[n].update = true;
                            break;
                          } else if (selectedval[n].numberctrl.text.isEmpty &&
                              ((selectedval[n].value == true) ||
                                  (selectedval[n].value == false)) &&
                              selectedval[n].billPaymentId == null &&
                              selectedval[n].update == true &&
                              selectedval[n].id ==
                                  paymentdata.value[m]['modeOfPaymentId']) {
                            print("updated");
                            await DatabaseHelper.instance
                                .deleteGSTmodeofpayment(
                              selectedval[n].id,
                            );
                            selectedval[n].update = true;
                            break;
                          }
                        }

                        print("billpaymentid=${selectedval[n].billPaymentId}");
                        print("modeofpaymentid=${selectedval[n].id}");
                      }
                      var data =
                          await DatabaseHelper.instance.getGSTmodeofpayments();
                      print("data=$data");
                      Get.back();
                    }
                  } else {
                    paymentdata.value =
                        await DatabaseHelper.instance.getNonGSTmodeofpayments();
                    print("outer data = ${paymentdata.value}");
                    for (int n = 0; n < selectedval.length; n++) {
                      // print("local data = $paymentdata");

                      for (int m = 0; m < paymentdata.value.length; m++) {
                        paymentdata.value = await DatabaseHelper.instance
                            .getNonGSTmodeofpayments();
                        print("local data = $paymentdata");
                        if ((selectedval[n].billPaymentId ==
                                paymentdata.value[m]['billPaymentId']) &&
                            (selectedval[n].numberctrl.text !=
                                paymentdata.value[m]['paymentValue']
                                    .toString()) &&
                            (selectedval[n].id ==
                                paymentdata.value[m]['modeOfPaymentId']) &&
                            selectedval[n].billPaymentId! > 0) {
                          await DatabaseHelper.instance
                              .updateNonGSTmodeofpayment(
                            1,
                            selectedval[n].billPaymentId as int,
                            selectedval[n].id,
                            int.parse(selectedval[n].numberctrl.text.length == 0
                                ? "0"
                                : selectedval[n].numberctrl.text),
                          );
                          setState(() {
                            selectedval[n].update = true;
                          });

                          break;
                        } else if ((selectedval[n].billPaymentId ==
                                paymentdata.value[m]['billPaymentId']) &&
                            (selectedval[n].numberctrl.text.isEmpty) &&
                            (selectedval[n].id ==
                                paymentdata.value[m]['modeOfPaymentId']) &&
                            (selectedval[n].value == false) &&
                            selectedval[n].billPaymentId! > 0) {
                          await DatabaseHelper.instance
                              .updateNonGSTmodeofpayment(
                            1,
                            selectedval[n].billPaymentId as int,
                            selectedval[n].id,
                            0,
                          );
                          setState(() {
                            selectedval[n].update = true;
                          });
                          break;
                        } else if (selectedval[n].numberctrl.text.isNotEmpty &&
                            (selectedval[n].value == true) &&
                            selectedval[n].billPaymentId == 0 &&
                            selectedval[n].update == true &&
                            selectedval[n].id ==
                                paymentdata.value[m]['modeOfPaymentId']) {
                          print("updated");
                          await DatabaseHelper.instance
                              .updateNonGSTmodeofpayment(
                            0,
                            0,
                            selectedval[n].id,
                            int.parse(selectedval[n].numberctrl.text.length == 0
                                ? "0"
                                : selectedval[n].numberctrl.text),
                          );
                          setState(() {
                            selectedval[n].update = true;
                          });
                          break;
                        } else if (selectedval[n].numberctrl.text.isNotEmpty &&
                            (selectedval[n].value == true) &&
                            selectedval[n].update == false &&
                            selectedval[n].billPaymentId == 0 &&
                            selectedval[n].id !=
                                paymentdata.value[m]['modeOfPaymentId']) {
                          print("added once");
                          await DatabaseHelper.instance.addNonGSTmodeofpayment(
                              Nongstmodeofpayment(
                                  modeOfPaymentId: selectedval[n].id,
                                  paymentValue: int.parse(
                                      selectedval[n].numberctrl.text.length == 0
                                          ? "0"
                                          : selectedval[n].numberctrl.text),
                                  updateForBillPayment: 0,
                                  billPaymentId: 0));
                          setState(() {
                            selectedval[n].update = true;
                          });
                          break;
                        } else if (selectedval[n].numberctrl.text.isEmpty &&
                            ((selectedval[n].value == true) ||
                                (selectedval[n].value == false)) &&
                            selectedval[n].billPaymentId == null &&
                            selectedval[n].update == true &&
                            selectedval[n].id ==
                                paymentdata.value[m]['modeOfPaymentId']) {
                          print("updated");
                          await DatabaseHelper.instance
                              .deleteNonGSTmodeofpayment(
                            selectedval[n].id,
                          );
                          print("Deleted");

                          selectedval[n].update = false;

                          break;
                        }
                      }

                      print("billpaymentid=${selectedval[n].billPaymentId}");
                      print("modeofpaymentid=${selectedval[n].id}");
                    }
                    var data =
                        await DatabaseHelper.instance.getNonGSTmodeofpayments();
                    print("data=$data");
                    // Get.back();
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
