import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jomar_barcode/app_data_provider.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:provider/provider.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);
  static const String idScreen = "AddServiceScreen";

  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  TextEditingController serviceController = TextEditingController();
  TextEditingController localisationController = TextEditingController();
  InventaireDatabase db = InventaireDatabase();

  @override
  void initState() {
    // serviceController.text =
    //     Provider.of<AppDataProvider>(context, listen: false).numeroInventaire;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      // drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(
          'Services',
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
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: serviceController,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.inbox),
                          hintText: 'Veuillez saisir le nom de service',
                          labelText: 'Service',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: localisationController,
                        decoration: const InputDecoration(
                          // icon: Icon(Icons.inbox),
                          hintText: 'Veuillez saisir la localisation',
                          labelText: 'Localisation',
                        ),
                      ),
                    ),
                  ],
                )),
            Positioned(
                bottom: 0.0,
                left: 5.0,
                right: 5.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (serviceController.text.isEmpty) {
                      Fluttertoast.showToast(
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          msg: "Veuillez fournir un nom de service",
                          toastLength: Toast.LENGTH_LONG);
                      return;
                    }
                    db.addService(Service(
                        name: serviceController.text,
                        localisation: localisationController.text));
                    Navigator.pop(context);
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
}
