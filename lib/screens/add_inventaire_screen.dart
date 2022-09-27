import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jomar_barcode/app_data_provider.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddInventaireScreen extends StatefulWidget {
  InventaireItem? inventaire;

  AddInventaireScreen({Key? key, this.inventaire}) : super(key: key);
  static const String idScreen = "AddInventaireScreen";

  @override
  _AddInventaireScreenState createState() => _AddInventaireScreenState();
}

class _AddInventaireScreenState extends State<AddInventaireScreen> {
  TextEditingController inventaireController = TextEditingController();
  InventaireDatabase db = InventaireDatabase();
  InventaireItem? inventaireSetting = InventaireItem(id: "", no: "");
  List<Inventaire> inventaires = [];

  @override
  void initState() {
    // inventaireController.text =
    //     Provider.of<AppDataProvider>(context, listen: false).numeroInventaire;
    //db.get
    print(widget.inventaire);
    if (widget.inventaire != null) {
      db.getInventaire(widget.inventaire?.no ?? '').then((values) {
        values.forEach((value) {
          var inventaire = Inventaire(id: value['id'], no: value['no']);
          inventaire.bureau = value['bureau'];
          inventaire.date = value['date'];
          inventaire.id = value['id'];
          inventaire.scan = value['barcode'];
          inventaire.service = value['service'];
          setState(() {
            inventaires.add(inventaire);
          });
        });
      });
      setState(() {
        inventaireController.text = widget.inventaire!.no;
        inventaireSetting = widget.inventaire;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          "NUMÉRO D'INVENTAIRE",
          style: TextStyle(color: theme.primaryColor),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: inventaireController,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.inbox),
                          hintText: 'Veuillez saisir le numéro d' 'inventaire',
                          labelText: '# inventaire',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: inventaires.map((inventaire) {
                          var displayTitle =
                              "${inventaire.service} (${inventaire.bureau})";
                          var displaySubTitle = "${inventaire.scan}";
                          var date = inventaire.date ?? '';
                          return Column(
                            children: [
                              ListTile(
                                horizontalTitleGap: 0,
                                title: Text(
                                  displayTitle,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                subtitle: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatDate(DateTime.parse(date))),
                                    Text(displaySubTitle),
                                  ],
                                ),
                                dense: true,
                                tileColor: theme.cardColor,
                              ),
                              const Divider()
                            ],
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )),
            Positioned(
                bottom: 0.0,
                left: 5.0,
                right: 5.0,
                child: ElevatedButton(
                  onPressed: () async {
                    inventaireSetting!.no = inventaireController.text;
                    inventaireSetting!.isActive = true;
                    if (inventaireSetting!.id.isEmpty) {
                      inventaireSetting!.id = const Uuid().v1().toString();
                      await db.addInventaireConfig(inventaireSetting!);
                    } else {
                      await db.updateInventaireConfig(inventaireSetting!);
                    }
                    Navigator.pop(context, inventaireSetting);
                  },
                  child: const Text('Enregistrer'),
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

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MMM-yyyy');
    return formatter.format(date);
  }
}
