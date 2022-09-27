import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:jomar_barcode/business_logic/inventaire_cubit.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:jomar_barcode/screens/add_inventaire_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String idScreen = "SettingsScreen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController inventaireController = TextEditingController();
  List<InventaireItem> inventaires = [];
  InventaireDatabase db = InventaireDatabase();

  @override
  void initState() {
    db.getInventaires().then((values) {
      values.forEach((val) {
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
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "NUMÉROS D'INVENTAIRE",
          style:
              TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AddInventaireScreen.idScreen)
                  .then((value) {
                if (value == null) {
                  return;
                }
                InventaireItem inventaire = value as InventaireItem;
                var previousList = inventaires.map((e) => e.id).toList();
                setState(() {
                  inventaires.add(inventaire);
                  BlocProvider.of<InventaireCubit>(context)
                      .setCurrentInventaire(inventaire);
                });
                if (previousList.isNotEmpty) {
                  db.archiveInventairesConfig(previousList);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(builder: (context) {
                return const Icon(
                  Icons.add,
                  size: 40,
                );
              }),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Positioned(top: 0.0, left: 0.0, right: 0.0, child: Divider()),
            Positioned(
                top: 10.0,
                left: 0.0,
                right: 0.0,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddInventaireScreen(
                                    inventaire: inventaires[index],
                                  )),
                        ).then((value) {
                          if (value == null) {
                            return;
                          }
                          InventaireItem inventaire = value as InventaireItem;
                          setState(() {
                            inventaires
                                .firstWhere(
                                    (element) => element.id == inventaire.id)
                                .no = inventaire.no;
                            BlocProvider.of<InventaireCubit>(context)
                                .setCurrentInventaire(inventaire);
                          });
                        });
                      },
                      child: Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 0,
                            title: Text(
                              inventaires[index].no,
                            ),
                            dense: true,
                            tileColor: theme.cardColor,
                          ),
                          const Divider()
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  // List<Widget> _getTitleWidget() {
  //   return [
  //     _getTitleItemWidget('No', 300),
  //     _getTitleItemWidget('', 0),
  //   ];
  // }

  // Widget _getTitleItemWidget(String label, double width) {
  //   return Container(
  //     child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
  //     width: width,
  //     height: 56,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }

  // Widget _generateFirstColumnRow(BuildContext context, int index) {
  //   return Container(
  //     child: Text(inventaires[index].no),
  //     width: 100,
  //     height: 52,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }
  //
  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   // var codes = current.bureaux![index].barCodes!.join(', ');
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         child: Row(
  //           children: <Widget>[Text(inventaires[index].isActive.toString())],
  //         ),
  //         width: 300,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //       ),
  //     ],
  //   );
  // }
}
