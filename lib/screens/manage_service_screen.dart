import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:jomar_barcode/app_data_provider.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:jomar_barcode/screens/add_service_screen.dart';
import 'package:provider/provider.dart';

class ManageServiceScreen extends StatefulWidget {
  const ManageServiceScreen({Key? key}) : super(key: key);
  static const String idScreen = "ManageServiceScreen";

  @override
  _ManageServiceScreenState createState() => _ManageServiceScreenState();
}

class _ManageServiceScreenState extends State<ManageServiceScreen> {
  TextEditingController inventaireController = TextEditingController();
  // final HDTRefreshController _hdtRefreshController = HDTRefreshController();
  List<Service> services = [];
  InventaireDatabase db = InventaireDatabase();

  @override
  void initState() {
    // inventaireController.text =
    //     Provider.of<AppDataProvider>(context, listen: false).numeroInventaire;
    db.getServices().then((values) {
      values.forEach((val) {
        setState(() {
          services.add(
              Service(name: val['name'], localisation: val['localisation']));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestion des services',
          style: TextStyle(color: theme.primaryColor),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AddServiceScreen.idScreen);
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
            Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  height: 500,
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // child: HorizontalDataTable(
                  //   leftHandSideColumnWidth: 150,
                  //   rightHandSideColumnWidth: 300,
                  //   isFixedHeader: true,
                  //   headerWidgets: _getTitleWidget(),
                  //   leftSideItemBuilder: _generateFirstColumnRow,
                  //   rightSideItemBuilder: _generateRightHandSideColumnRow,
                  //   itemCount: services.length,
                  //   rowSeparatorWidget: const Divider(
                  //     color: Colors.black54,
                  //     height: 1.0,
                  //     thickness: 0.0,
                  //   ),
                  //   leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                  //   rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                  //   verticalScrollbarStyle: const ScrollbarStyle(
                  //     thumbColor: Colors.black,
                  //     isAlwaysShown: true,
                  //     thickness: 4.0,
                  //     radius: Radius.circular(5.0),
                  //   ),
                  //   horizontalScrollbarStyle: const ScrollbarStyle(
                  //     thumbColor: Colors.black,
                  //     isAlwaysShown: true,
                  //     thickness: 4.0,
                  //     radius: Radius.circular(5.0),
                  //   ),
                  //   enablePullToRefresh: false,
                  //   refreshIndicator: const WaterDropHeader(),
                  //   refreshIndicatorHeight: 60,
                  //   // onRefresh: () async {
                  //   //   //Do sth
                  //   //   await Future.delayed(const Duration(milliseconds: 500));
                  //   //   _hdtRefreshController.refreshCompleted();
                  //   // },
                  //   enablePullToLoadNewData: false,
                  //   loadIndicator: const ClassicFooter(),
                  //   // onLoad: () async {
                  //   //   //Do sth
                  //   //   await Future.delayed(const Duration(milliseconds: 500));
                  //   //   _hdtRefreshController.loadComplete();
                  //   // },
                  //   htdRefreshController: _hdtRefreshController,
                  // ),
                  // child: TextFormField(
                  //   controller: inventaireController,
                  //   decoration: const InputDecoration(
                  //     // icon: Icon(Icons.inbox),
                  //     hintText: 'Veuillez saisir le numéro d' 'inventaire',
                  //     labelText: '# inventaire',
                  //   ),
                  // ),
                )),
            // Positioned(
            //     bottom: 0.0,
            //     left: 5.0,
            //     right: 5.0,
            //     child: ElevatedButton(
            //       onPressed: () {
            //         Provider.of<AppDataProvider>(context, listen: false)
            //             .updateNumeroInventaire(inventaireController.text);
            //         Navigator.pop(context);
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

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Service', 200),
      _getTitleItemWidget('Localisation', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text(services[index].name ?? ''),
      width: 100,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    // var codes = current.bureaux![index].barCodes!.join(', ');
    return Row(
      children: <Widget>[
        Container(
          child: Row(
            children: <Widget>[Text(services[index].localisation ?? '')],
          ),
          width: 300,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
