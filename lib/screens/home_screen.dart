import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:jomar_barcode/business_logic/inventaire_cubit.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:jomar_barcode/screens/service_screen.dart';
import 'package:jomar_barcode/widgets/app_drawer.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../app_theme.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

import 'add_inventaire_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String idScreen = "HomeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SiteData> sites = [];
  InventaireDatabase db = InventaireDatabase();
  String inventaire = "";
  // late another_progress.ProgressDialog pr;
  late ProgressDialog pr;

  List<InventaireItem> inventaires = [];

  @override
  void initState() {
    super.initState();

    pr = ProgressDialog(context);
    // db.getCurrentInventaireConfig().then((value) {
    //   if (value == null) {
    //     setState(() {
    //       inventaire = "";
    //     });
    //   } else {
    //     inventaire = value['no'];
    //   }
    // });

    db.getInventaires().then((values) {
      for (var val in values) {
        setState(() {
          inventaires.add(InventaireItem(
              id: val['id'], no: val['no'], isActive: val['isActive'] == 1));
        });
        if (val['isActive'] == true) {
          BlocProvider.of<InventaireCubit>(context).setCurrentInventaire(
              InventaireItem(
                  id: val['id'],
                  no: val['no'],
                  isActive: val['isActive'] == 1));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Gestion Inventaire BNI',
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(top: 0.0, left: 0.0, right: 0.0, child: Divider()),
            Positioned(
                top: 20.0,
                left: 5.0,
                right: 5.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "INVENTAIRES",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                                context, AddInventaireScreen.idScreen)
                            .then((value) {
                          if (value == null) {
                            return;
                          }
                          InventaireItem inventaire = value as InventaireItem;
                          var previousList =
                              inventaires.map((e) => e.id).toList();
                          setState(() {
                            inventaires.add(inventaire);
                            BlocProvider.of<InventaireCubit>(context)
                                .setCurrentInventaire(inventaire);
                          });
                          if (previousList.isNotEmpty) {
                            db.archiveInventairesConfig(previousList);
                          }
                        });

                        // Navigator.pushNamed(context, SiteScreen.idScreen)
                        //     .then((value) {
                        //   if (value != null) {
                        //     SiteData siteData = value as SiteData;
                        //     setState(() {
                        //       sites.add(siteData);
                        //     });
                        //   }
                        // });
                      },
                      child: const Icon(Icons.add),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            AppTheme.primaryColor),
                      ),
                    )
                    // BlocBuilder<InventaireCubit, InventaireState>(
                    //     builder: (context, state) {
                    //   return Text(
                    //     state.currentInventaire.no,
                    //     style: const TextStyle(color: Colors.blueGrey),
                    //   );
                    // })
                  ],
                )),
            Positioned(
                top: 60.0,
                left: 5.0,
                right: 5.0,
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: inventaires.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, ServiceScreen.idScreen)
                            .then((value) {
                          if (value != null) {
                            SiteData siteData = value as SiteData;
                            setState(() {
                              sites.add(siteData);
                            });
                          }
                        });

                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => AddInventaireScreen(
                        //             inventaire: inventaires[index],
                        //           )),
                        // ).then((value) {
                        //   if (value == null) {
                        //     return;
                        //   }
                        //   InventaireItem inventaire = value as InventaireItem;
                        //   setState(() {
                        //     inventaires
                        //         .firstWhere(
                        //             (element) => element.id == inventaire.id)
                        //         .no = inventaire.no;
                        //     BlocProvider.of<InventaireCubit>(context)
                        //         .setCurrentInventaire(inventaire);
                        //   });
                        // });
                      },
                      child: Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text(
                              inventaires[index].no,
                            ),
                            dense: true,
                            // tileColor: theme.cardColor,
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  ),
                )
                // child: ElevatedButton(
                //   onPressed: () {
                //     Navigator.pushNamed(context, SiteScreen.idScreen)
                //         .then((value) {
                //       if (value != null) {
                //         SiteData siteData = value as SiteData;
                //         setState(() {
                //           sites.add(siteData);
                //         });
                //       }
                //     });
                //   },
                //   child: const Text('Choisir un service'),
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(AppTheme.primaryColor),
                //   ),
                // )
                ),
            // Positioned(
            //     top: 100.0,
            //     left: 5.0,
            //     right: 5.0,
            //     child: Container(
            //       height: 480,
            //       child: Column(
            //         children: [
            //           Row(
            //             children: const [
            //               Text(
            //                 'LISTE DES SERVICES TRAITÉS',
            //                 style: TextStyle(fontSize: 18),
            //               ),
            //             ],
            //           ),
            //           const SizedBox(
            //             height: 15,
            //           ),
            //           ListView.builder(
            //             physics: const NeverScrollableScrollPhysics(),
            //             itemCount: sites.length,
            //             shrinkWrap: true,
            //             itemBuilder: (context, index) => GestureDetector(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                       builder: (context) => SiteScreen(
            //                             site: sites[index],
            //                           )),
            //                 ).then((value) {
            //                   if (value != null) {
            //                     SiteData siteData = value as SiteData;
            //                     if (sites.any(
            //                         (site) => site.site == siteData.site)) {
            //                       setState(() {
            //                         sites
            //                             .firstWhere((site) =>
            //                                 site.site == siteData.site)
            //                             .bureaux = siteData.bureaux;
            //                       });
            //                     } else {
            //                       setState(() {
            //                         sites.add(siteData);
            //                       });
            //                     }
            //                   }
            //                 });
            //               },
            //               child: Column(
            //                 children: [
            //                   ListTile(
            //                     horizontalTitleGap: 0,
            //                     title: Text(
            //                       sites[index].site ?? '',
            //                     ),
            //                     subtitle: sites[index].bureaux.length == 1
            //                         ? Text(
            //                             "${sites[index].bureaux.length} bureau")
            //                         : Text(
            //                             "${sites[index].bureaux.length} bureaux"),
            //                     dense: true,
            //                     tileColor: theme.cardColor,
            //                   ),
            //                   const Divider()
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     )),
            Positioned(
                bottom: 0.0,
                left: 5.0,
                right: 5.0,
                child: ElevatedButton(
                  onPressed: () async {
                    await exportData();
                    setState(() {
                      sites = [];
                    });
                  },
                  child: const Text('Sauvegarder & Exporter'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red.shade900),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  exportData() async {
    pr.style(
        message: 'Traitement en cours ...',
        borderRadius: 5.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    await pr.show();

    var excel = Excel.createExcel();
    var currentInventaire = await db.getCurrentInventaireConfig();
    List<Inventaire> list = [];

    Sheet sheetObject = excel['Sheet1'];
    CellStyle cellStyle = CellStyle(
        backgroundColorHex: "#1AFF1A",
        fontSize: 20,
        fontFamily: getFontFamily(FontFamily.Calibri));
    cellStyle.underline = Underline.Single; // or Underline.Double
    var cell = sheetObject.cell(CellIndex.indexByString("A1"));
    cell.value = "Gestion Inventaire";
    cell.cellStyle = cellStyle;

    var cell3 = sheetObject.cell(CellIndex.indexByString("A3"));
    cell3.value = "#Inventaire:";
    cell3.cellStyle = CellStyle(fontSize: 16, bold: true);

    var cellb3 = sheetObject.cell(CellIndex.indexByString("B3"));
    cellb3.value = currentInventaire!['no'];

    var cell5 = sheetObject.cell(CellIndex.indexByString("A5"));
    cell5.value = "Sites";
    cell5.cellStyle = CellStyle(fontSize: 16, bold: true);

    var i = 6;
    for (var site in sites) {
      var pos = "A$i";
      var cellbPos = sheetObject.cell(CellIndex.indexByString(pos));
      cellbPos.value = site.site;

      var j = i + 1;
      for (var bureau in site.bureaux) {
        var bureauPos = "A$j";
        var cellbPos = sheetObject.cell(CellIndex.indexByString(bureauPos));
        cellbPos.value = bureau.bureau;

        var barCode = j + 1;
        var cellcodes = sheetObject.cell(CellIndex.indexByString("A$barCode"));
        cellcodes.value = "BarCodes";

        var codes = bureau.barCodes
            .map((e) =>
                'Code: ' +
                e.code +
                ', Materiel: ' +
                e.materiel +
                ', Utilisateur: ' +
                e.utilisateur)
            .join(', ');
        var barCellcodes =
            sheetObject.cell(CellIndex.indexByString("B$barCode"));
        barCellcodes.value = codes;

        j = j + 3;

        for (var bcc in bureau.barCodes) {
          list.add(Inventaire(
              id: const Uuid().v1().toString(),
              no: currentInventaire['no'],
              date: DateTime.now().toString(),
              bureau: bureau.bureau,
              service: site.site,
              scan: bcc.code,
              utilisateur: bcc.utilisateur,
              materiel: bcc.materiel));
        }
      }
      i = i + 3 * site.bureaux.length + 1;
    }

    await db.deleteExistingInventaires(list.map((e) => e.no).toList());
    for (var item in list) {
      await db.addInventaire(item);
    }

    var fileBytes = excel.save();
    if (fileBytes != null) {
      var filePath =
          await getFilePath(currentInventaire['no'] + "_inventaire_.xlsx");

      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);

      var result = await OpenFile.open(filePath);

      pr.hide().then((value) {
        Fluttertoast.showToast(
            textColor: Colors.white,
            backgroundColor: Colors.red,
            msg: result.message,
            toastLength: Toast.LENGTH_LONG);
      });
    } else {
      pr.hide().then((value) {
        Fluttertoast.showToast(
            textColor: Colors.white,
            backgroundColor: Colors.red,
            msg: "Une erreur est survenue",
            toastLength: Toast.LENGTH_LONG);
      });
    }
  }

  Future<String> getFilePath(fileName) async {
    Directory _path = await getApplicationDocumentsDirectory();
    String _localPath = _path.path + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    return '$_localPath/$fileName';
  }
}
