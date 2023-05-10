// // ignore_for_file: prefer_const_constructors

// import 'package:autocomplete_textfield/autocomplete_textfield.dart';
// import 'package:flutter/material.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(),
//         body: Container(
//           child: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 FirstPage(vendorctrl, "Vendor"),
//                 // Container(
//                 //   height: 200,
//                 //   child: FirstPage(itemctrl, "Item Name"),
//                 // )
//                 AutoCompleteTextField(itemSubmitted: itemSubmitted, key: key, suggestions: suggestions, itemBuilder: itemBuilder, itemSorter: itemSorter, itemFilter: itemFilter)
//               ],
//             ),
//           ),
//         ));
//   }

//   String currentText = "";

//   TextEditingController vendorctrl = TextEditingController();
//   TextEditingController itemctrl = TextEditingController();
//   FirstPage(TextEditingController ctrl, String label) {
//     return AutoCompleteTextField(
//       key: key,
//       decoration: InputDecoration(
//           label: Text(label),
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.blue)),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(width: 2, color: Colors.blue))),
//       controller: ctrl,
//       textChanged: (text) => currentText = text,
//       suggestions: suggestions,
//       clearOnSubmit: true,
//     );
//   }

//   GlobalKey<AutoCompleteTextFieldState<String>> key = GlobalKey();
//   List<String> suggestions = [
//     "Apple",
//     "Armidillo",
//     "Actual",
//     "Actuary",
//     "America",
//     "Argentina",
//     "Australia",
//     "Antarctica",
//     "Blueberry",
//     "Cheese",
//     "Danish",
//     "Eclair",
//     "Fudge",
//     "Granola",
//     "Hazelnut",
//     "Ice Cream",
//     "Jely",
//     "Kiwi Fruit",
//     "Lamb",
//     "Macadamia",
//     "Nachos",
//     "Oatmeal",
//     "Palm Oil",
//     "Quail",
//     "Rabbit",
//     "Salad",
//     "T-Bone Steak",
//     "Urid Dal",
//     "Vanilla",
//     "Waffles",
//     "Yam",
//     "Zest"
//   ];
// }
