import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jomar_barcode/models/materiel_barcode.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:jomar_barcode/models/site_data.dart';
import '../app_theme.dart';

class BureauScreen extends StatefulWidget {
  BureauData? bureauData;
  String? site;
  BureauScreen({Key? key, this.bureauData, this.site}) : super(key: key);
  static const String idScreen = "BureauScreen";

  @override
  _BureauScreenState createState() => _BureauScreenState();
}

class _BureauScreenState extends State<BureauScreen> {
  List<MaterielBarcode> barCodes = [];
  String site = '';
  int tag = 0;
  String code = '';

  BureauData bureauData = BureauData(barCodes: []);
  TextEditingController bureauController = TextEditingController();
  TextEditingController materielController = TextEditingController();
  TextEditingController utilisateurController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.bureauData != null) {
      setState(() {
        bureauData = widget.bureauData ?? BureauData(barCodes: [], bureau: '');
        barCodes = bureauData.barCodes;
        bureauController.text = bureauData.bureau!;
        utilisateurController.text =
            barCodes.isNotEmpty ? barCodes[0].utilisateur : '';
        materielController.text =
            barCodes.isNotEmpty ? barCodes[0].materiel : '';
        code = barCodes.isNotEmpty ? barCodes[0].code : '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    String? site = ModalRoute.of(context)!.settings.arguments as String;
    site ??= widget.site;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scanner',
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned(top: 0.0, left: 0.0, right: 0.0, child: Divider()),
            Positioned(
                top: 10.0,
                left: 0.0,
                right: 0.0,
                child: Builder(builder: (BuildContext context) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Container(
                          child: Row(children: [
                            const Text('Service : '),
                            Text(
                              site ?? '',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            )
                          ]),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: bureauController,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.inbox),
                            hintText: 'Bureau',
                            labelText: 'Bureau',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: materielController,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.inbox),
                            hintText: 'Materiel',
                            labelText: 'Materiel',
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: utilisateurController,
                          decoration: const InputDecoration(
                            // icon: Icon(Icons.inbox),
                            hintText: 'Utilisateur',
                            labelText: 'Utilisateur',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        child: Container(
                          child: Row(children: [
                            const Text('Code : '),
                            Text(
                              code ?? '',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red),
                            )
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            alignment: Alignment.center,
                            child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                AppTheme.primaryColor),
                                      ),
                                      onPressed: () async {
                                        if (bureauController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              textColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              msg:
                                                  'Veuillez écrire le nom du bureau !',
                                              toastLength: Toast.LENGTH_LONG);
                                          return;
                                        }
                                        if (utilisateurController
                                            .text.isEmpty) {
                                          Fluttertoast.showToast(
                                              textColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              msg:
                                                  "Veuillez écrire le nom de l'utilisateur !",
                                              toastLength: Toast.LENGTH_LONG);
                                          return;
                                        }
                                        if (materielController.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              textColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              msg:
                                                  "Veuillez écrire le matériel !",
                                              toastLength: Toast.LENGTH_LONG);
                                          return;
                                        }
                                        var bc = await scanBarcodeNormal(
                                            barCodes,
                                            materielController.text,
                                            utilisateurController.text);
                                        setState(() {
                                          barCodes = bc;
                                        });

                                        // setState(() {
                                        //   bureauData.bureau =
                                        //       bureauController.text;
                                        //   bureauData.barCodes = barCodes;
                                        // });
                                        // Navigator.pop(context, bureauData);

                                        if (bc.isNotEmpty) {
                                          setState(() {
                                            barCodes = bc;
                                            // options = barCodes.map((e) {
                                            //   return e;
                                            // }).toList();
                                          });

                                          setState(() {
                                            bureauData.bureau =
                                                bureauController.text;
                                            bureauData.barCodes = barCodes;
                                          });
                                          Navigator.pop(context, bureauData);
                                        } else {
                                          Fluttertoast.showToast(
                                              textColor: Colors.white,
                                              backgroundColor: Colors.red,
                                              msg:
                                                  "Impossible de scanner ce code !",
                                              toastLength: Toast.LENGTH_LONG);
                                        }
                                      },
                                      child: const Text('Scanner'))
                                ])),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 380, // MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: barCodes.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  // ListTile(
                                  //   horizontalTitleGap: 0,
                                  //   title: Text(
                                  //     barCodes[index].code,
                                  //   ),
                                  //   subtitle: Text(barCodes[index].materiel),
                                  //   leading: Text(barCodes[index].utilisateur),
                                  //   dense: true,
                                  //   tileColor: theme.cardColor,
                                  // ),
                                  // const Divider()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
            // Positioned(
            //     bottom: 0.0,
            //     left: 5.0,
            //     right: 5.0,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         setState(() {
            //           bureauData.bureau = bureauController.text;
            //           bureauData.barCodes = barCodes;
            //         });
            //         Navigator.pop(context, bureauData);
            //       },
            //       child: const Text('Enregistrer'),
            //       style: ButtonStyle(
            //         backgroundColor:
            //             MaterialStateProperty.all<Color>(Colors.red.shade900),
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }

  // List<Widget> _getTitleWidget() {
  //   return [
  //     _getTitleItemWidget('Codes', 200),
  //     _getTitleItemWidget(' ', 200),
  //   ];
  // }
  //
  // Widget _getTitleItemWidget(String label, double width) {
  //   return Container(
  //     child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //     width: width,
  //     height: 56,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }
  //
  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   return Container(
  //     child: Text(options[index]),
  //     width: 100,
  //     height: 52,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }
  //
  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         child: Row(
  //           children: const <Widget>[Text('')],
  //         ),
  //         width: 100,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //       ),
  //     ],
  //   );
  // }

  Future<List<MaterielBarcode>> scanBarcodeNormal(
      List<MaterielBarcode> barcodes,
      String materiel,
      String utilisateur) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff7766', 'Terminer', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return [];

    if (!barcodes.contains(barcodeScanRes) && barcodeScanRes != "-1") {
      setState(() {
        barcodes.add(MaterielBarcode(
            code: barcodeScanRes,
            materiel: materiel,
            utilisateur: utilisateur));
        FlutterBeep.beep();
      });
    } else {
      if (barcodeScanRes == "-1") {
        Fluttertoast.showToast(
            textColor: Colors.white,
            backgroundColor: Colors.red,
            msg: "Aucun code trouvé",
            toastLength: Toast.LENGTH_LONG);

        setState(() {
          barcodes.add(MaterielBarcode(
              code: barcodeScanRes,
              materiel: materiel,
              utilisateur: utilisateur));
          FlutterBeep.beep();
        });

        // setState(() {
        //   barcodes.add(barcodeScanRes);
        // });
      }
      // setState(() {
      //   barcodes.add(barcodeScanRes);
      // });
      //
      // Fluttertoast.showToast(
      //     textColor: Colors.white,
      //     backgroundColor: Colors.red,
      //     msg: "Aucun code trouvé",
      //     toastLength: Toast.LENGTH_LONG);
    }

    return barcodes;
  }
}
