// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart' as dds;
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jomar_barcode/app_data_provider.dart';
import 'package:jomar_barcode/pages/gestion_inventaire_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppDataProvider()),
        ],
        child: GestionInventaireApp(),
      ),
    );

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   int currentStep = 0;
//   List<String> barCodes = [];
//   String? site;
//   TextEditingController controller = TextEditingController();
//   TextEditingController bureauController = TextEditingController();
//   int limit = 10;
//   int number = 0;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> scanBarcodeNormal() async {
//     String barcodeScanRes;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Terminer', true, ScanMode.BARCODE);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     if (!barCodes.contains(barcodeScanRes) && barcodeScanRes != "-1") {
//       setState(() {
//         barCodes.add(barcodeScanRes);
//         FlutterBeep.beep();
//       });
//     } else {
//       if(barcodeScanRes == "-1") {
//         Fluttertoast.showToast(
//             textColor: Colors.white,
//             backgroundColor: Colors.red,
//             msg: "Aucun code trouvé",
//             toastLength: Toast.LENGTH_LONG);
//       }
//       // setState(() {
//       //   barCodes.add(barcodeScanRes);
//       // });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//
//     return MaterialApp(
//         theme: AppTheme.lightTheme,
//         home: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.green,
//             title: Text(
//               "GESTION D'INVENTAIRE".toUpperCase(),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           body: SafeArea(
//             child: Stack(
//               children: [
//                 Positioned(
//                     top: 10.0,
//                     left: 30.0,
//                     right: 0.0,
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 8,
//                           backgroundColor: currentStep == 0
//                               ? AppTheme.primaryColor
//                               : AppTheme.starColor,
//                         ),
//                         const Text(
//                           ' - Inventaire -',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         CircleAvatar(
//                           radius: 8,
//                           backgroundColor: currentStep == 1
//                               ? AppTheme.primaryColor
//                               : AppTheme.starColor,
//                         ),
//                         Text(
//                           ' - Scan -',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                         CircleAvatar(
//                           radius: 8,
//                           backgroundColor: currentStep == 2
//                               ? AppTheme.primaryColor
//                               : AppTheme.starColor,
//                         ),
//                         Text(
//                           ' - Sommaire',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     )),
//                 Positioned(
//                   top: 30.0,
//                   left: 0.0,
//                   right: 0.0,
//                   child: buildStepWidget(),
//                 ),
//                 Positioned(
//                   left: 3.0,
//                   right: 3.0,
//                   bottom: 3.0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       currentStep > 0
//                           ? ElevatedButton(
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         AppTheme.primaryColor),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   currentStep--;
//                                 });
//                               },
//                               child: const Text('Prec'))
//                           : Container(),
//                       currentStep == 2 ? Container() : buildLastButton(),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
//
//   Widget buildLastButton() {
//     return currentStep == 1 && barCodes.isEmpty
//         ? Container()
//         : ElevatedButton(
//             style: ButtonStyle(
//               backgroundColor:
//                   MaterialStateProperty.all<Color>(AppTheme.primaryColor),
//             ),
//             onPressed: () async {
//               if (currentStep == 0) {
//                 if (controller.text.isEmpty) {
//                   Fluttertoast.showToast(
//                       textColor: Colors.white,
//                       backgroundColor: Colors.red,
//                       msg: "Veuillez fournir un numero d'inventaire",
//                       toastLength: Toast.LENGTH_LONG);
//
//                   return;
//                 }
//               } else if (currentStep == 1) {
//                 var excel = Excel.createExcel();
//
//                 Sheet sheetObject = excel['Sheet1'];
//                 CellStyle cellStyle = CellStyle(
//                     backgroundColorHex: "#1AFF1A",
//                     fontSize: 20,
//                     fontFamily: getFontFamily(FontFamily.Calibri));
//                 cellStyle.underline = Underline.Single; // or Underline.Double
//                 var cell = sheetObject.cell(CellIndex.indexByString("A1"));
//                 cell.value =
//                     "Gestion Inventaire"; // dynamic values support provided;
//                 cell.cellStyle = cellStyle;
//
//                 var cell3 = sheetObject.cell(CellIndex.indexByString("A3"));
//                 cell3.value = "#Inventaire:";
//                 var cellb3 = sheetObject.cell(CellIndex.indexByString("B3"));
//                 cellb3.value = controller.text;
//
//                 var cell4 = sheetObject.cell(CellIndex.indexByString("A4"));
//                 cell4.value = "Site";
//                 var cellb4 = sheetObject.cell(CellIndex.indexByString("B4"));
//                 cellb4.value = site;
//
//                 var cell5 = sheetObject.cell(CellIndex.indexByString("A5"));
//                 cell5.value = "Bureau";
//                 var cellb5 = sheetObject.cell(CellIndex.indexByString("B5"));
//                 cellb5.value = bureauController.text;
//
//                 var cellcodes = sheetObject.cell(CellIndex.indexByString("A7"));
//                 cellcodes.value = "Codes";
//                 var i = 8;
//                 for (var code in barCodes) {
//                   var cellcodes =
//                       sheetObject.cell(CellIndex.indexByString("A$i"));
//                   cellcodes.value = code;
//                   i++;
//                 }
//                 var fileBytes = excel.save();
//                 if (fileBytes != null) {
//                   var filePath =
//                       await getFilePath(controller.text + "_inventaire_.xlsx");
//                   File(filePath)
//                     ..createSync(recursive: true)
//                     ..writeAsBytesSync(fileBytes);
//
//                   var result = await OpenFile.open(filePath);
//
//                   Fluttertoast.showToast(
//                       textColor: Colors.white,
//                       backgroundColor: Colors.red,
//                       msg: result.message,
//                       toastLength: Toast.LENGTH_LONG);
//                 }
//               }
//
//               setState(() {
//                 currentStep++;
//               });
//             },
//             child: currentStep == 1 ? Text('Finaliser') : Text('Suiv'));
//   }
//
//   Widget buildStepWidget() {
//     if (currentStep == 0) {
//       return Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 15),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: TextFormField(
//               controller: controller,
//               decoration: const InputDecoration(
//                 // icon: Icon(Icons.inbox),
//                 hintText: 'Veuillez saisir le numéro d' 'inventaire',
//                 labelText: 'Inventaire',
//               ),
//             ),
//           ),
//         ],
//       );
//     }
//     if (currentStep == 1) {
//       return Column(
//         children: [
//           Container(
//             // color: theme.backgroundColor,
//             margin: const EdgeInsets.symmetric(vertical: 15),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: dds.DropdownSearch<String>(
//                 onChanged: (value) {
//                   setState(() {
//                     site = value;
//                   });
//                 },
//                 mode: Mode.MENU,
//                 // showSelectedItem: true,
//                 items: sites,
//                 label: "Choisir un site",
//                 hint: "Choisir un site dans la liste",
//                 selectedItem: site),
//           ),
//           site == null
//               ? Container()
//               : Builder(builder: (BuildContext context) {
//                   return Column(
//                     children: [
//                       Container(
//                         margin: const EdgeInsets.symmetric(vertical: 5),
//                         padding: const EdgeInsets.symmetric(horizontal: 20),
//                         child: TextFormField(
//                           controller: bureauController,
//                           decoration: const InputDecoration(
//                             // icon: Icon(Icons.inbox),
//                             hintText: 'Veuillez saisir le bureau',
//                             labelText: 'Bureau',
//                           ),
//                         ),
//                       ),
//                       Container(
//                           alignment: Alignment.center,
//                           child: Flex(
//                               direction: Axis.vertical,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: <Widget>[
//                                 ElevatedButton(
//                                     style: ButtonStyle(
//                                       backgroundColor:
//                                           MaterialStateProperty.all<Color>(
//                                               AppTheme.primaryColor),
//                                     ),
//                                     onPressed: () => scanBarcodeNormal(),
//                                     child: const Text('Scannez'))
//                               ])),
//                       ListBody(
//                         children: barCodes
//                             .map((doc) => Column(
//                                   children: [
//                                     ListTile(
//                                       onTap: () {},
//                                       title: Text(doc),
//                                       trailing: doc == "-1"
//                                           ? GestureDetector(
//                                               onTap: () {},
//                                               child: const Icon(
//                                                   Icons.close_rounded,
//                                                   color: Colors.red),
//                                             )
//                                           : const Icon(Icons.check_box_rounded,
//                                               color: Colors.green),
//                                     ),
//                                     Divider(
//                                       height: 5,
//                                       color: Colors.blueGrey,
//                                     ),
//                                   ],
//                                 ))
//                             .toList(),
//                       ),
//                     ],
//                   );
//                 })
//         ],
//       );
//     }
//     if (currentStep == 2) {
//       return Column(
//         children: [
//           Container(
//             margin: const EdgeInsets.symmetric(vertical: 100),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Text('Terminé'),
//           ),
//           Container(
//               alignment: Alignment.center,
//               child: Flex(
//                   direction: Axis.vertical,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     ElevatedButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStateProperty.all<Color>(
//                               AppTheme.primaryColor),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             currentStep = 0;
//                             controller.text = "";
//                             bureauController.text = "";
//                             barCodes = [];
//                             site = "";
//                           });
//                         },
//                         child: const Text('Recommencer'))
//                   ])),
//         ],
//       );
//     }
//     return Container();
//   }
//
//   Widget buildScanner() {
//     if (currentStep == 0) {
//       return Scrollbar(
//         child: ListView.builder(
//           itemCount: limit,
//           itemBuilder: (context, index) {
//             number++;
//             return ListTile(
//               title: Text(barCodes[index]),
//             );
//           },
//         ),
//       );
//     }
//     return Container();
//   }
//
//   Future<String> getFilePath(fileName) async {
//     Directory _path = await getApplicationDocumentsDirectory();
//     String _localPath = _path.path + Platform.pathSeparator + 'Download';
//     final savedDir = Directory(_localPath);
//     bool hasExisted = await savedDir.exists();
//     if (!hasExisted) {
//       savedDir.create();
//     }
//
//     return '$_localPath/$fileName';
//
//     // Directory appDocumentsDirectory =
//     //     await getTemporaryDirectory(); //await getApplicationDocumentsDirectory();
//     // String appDocumentsPath = appDocumentsDirectory.path; // 2
//     // String filePath = '$appDocumentsPath/$fileNAme'; // 3
//
//     // return filePath;
//   }
// }
//
// final List<String> sites = ['Site 1', 'Site 2', 'Site 3', 'Site 4'];
