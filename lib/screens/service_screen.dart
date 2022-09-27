import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart' as dds;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/models/site_data.dart';
import 'package:jomar_barcode/screens/bureau_screen.dart';
import '../app_theme.dart';

class ServiceScreen extends StatefulWidget {
  SiteData? site;
  ServiceScreen({Key? key, this.site}) : super(key: key);
  static const String idScreen = "ServiceScreen";

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<String> barCodes = [];
  SiteData current = SiteData(bureaux: [], site: '');
  String site = '';
  // final HDTRefreshController _hdtRefreshController = HDTRefreshController();
  InventaireDatabase db = InventaireDatabase();
  List<Service> services = [];
  @override
  void initState() {
    db.getServices().then((values) {
      for (var val in values) {
        setState(() {
          services.add(
              Service(name: val['name'], localisation: val['localisation']));
        });
      }
    });

    if (widget.site != null) {
      setState(() {
        current = widget.site ?? SiteData(bureaux: [], site: '');
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service',
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: dds.DropdownSearch<String>(
                  onChanged: (value) {
                    current.site = value;
                  },
                  mode: Mode.MENU,
                  showSelectedItems: true,
                  items: services.map((e) => e.name ?? '').toList(),
                  label: "Choisir un service",
                  hint: "Choisir un service dans la liste",
                  selectedItem: current.site,
                  // selectedItem: site
                ),
              ),
            ),
            Positioned(
                top: 80.0,
                left: 30.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (current.site == null || current.site == '') {
                            Fluttertoast.showToast(
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                msg: 'Veuillez choisir un service !',
                                toastLength: Toast.LENGTH_LONG);
                            return;
                          }
                          Navigator.pushNamed(
                            context,
                            BureauScreen.idScreen,
                            arguments: current.site,
                          ).then((value) {
                            if (value != null) {
                              BureauData bureauData = value as BureauData;
                              setState(() {
                                current.bureaux.add(bureauData);
                              });
                            }
                          });
                        },
                        child: const Text('Ajouter un item à scanner'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppTheme.primaryColor),
                        ),
                      )
                    ],
                  ),
                )),
            Positioned(
                top: 130.0,
                left: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 400,
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Liste des items scannés',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: current.bureaux.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BureauScreen(
                                          bureauData: current.bureaux[index],
                                          site: current.site,
                                        )),
                              ).then((value) {
                                if (value != null) {
                                  BureauData bureauData = value as BureauData;
                                  if (current.bureaux.any((element) =>
                                      element.bureau == bureauData.bureau)) {
                                    setState(() {
                                      current.bureaux
                                          .firstWhere((site) =>
                                              site.bureau == bureauData.bureau)
                                          .barCodes = bureauData.barCodes;
                                    });
                                  } else {
                                    setState(() {
                                      current.bureaux.add(bureauData);
                                    });
                                  }
                                }
                                // if (value != null) {

                                //   // SiteData siteData = value as SiteData;
                                //   // if(sites.any((site) => site.site == siteData.site)){
                                //   //   setState(() {
                                //   //     sites.firstWhere((site) => site.site == siteData.site).bureaux = siteData.bureaux ?? [];
                                //   //   });
                                //   // } else{
                                //   //   setState(() {
                                //   //     sites.add(siteData);
                                //   //   });
                                //   // }
                                // }
                              });
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  horizontalTitleGap: 0,
                                  title: Text(
                                    'Bur: ' +
                                        (current.bureaux[index].bureau ?? ''),
                                  ),
                                  subtitle:
                                      current.bureaux[index].barCodes.isEmpty
                                          ? Container()
                                          : Text(current
                                              .bureaux[index].barCodes[0].code),
                                  trailing:
                                      current.bureaux[index].barCodes.isEmpty
                                          ? Container()
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('Mat : ' +
                                                    current.bureaux[index]
                                                        .barCodes[0].materiel),
                                                Text('Uti : ' +
                                                    current
                                                        .bureaux[index]
                                                        .barCodes[0]
                                                        .utilisateur),
                                              ],
                                            ),
                                  // subtitle: current
                                  //             .bureaux[index].barCodes.length <=
                                  //         1
                                  //     ? Text(
                                  //         "${current.bureaux[index].barCodes.length} code")
                                  //     : Text(
                                  //         "${current.bureaux[index].barCodes.length} codes"),
                                  dense: true,
                                  tileColor: theme.cardColor,
                                ),
                                const Divider()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // child: HorizontalDataTable(
                    //   leftHandSideColumnWidth: 100,
                    //   rightHandSideColumnWidth: 600,
                    //   isFixedHeader: true,
                    //   headerWidgets: _getTitleWidget(),
                    //   leftSideItemBuilder: _generateFirstColumnRow,
                    //   rightSideItemBuilder: _generateRightHandSideColumnRow,
                    //   itemCount: current.bureaux!.length,
                    //   rowSeparatorWidget: const Divider(
                    //     color: Colors.black54,
                    //     height: 1.0,
                    //     thickness: 0.0,
                    //   ),
                    //   leftHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                    //   rightHandSideColBackgroundColor: const Color(0xFFFFFFFF),
                    //   verticalScrollbarStyle: const ScrollbarStyle(
                    //     thumbColor: Colors.yellow,
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
                  ),
                )),
            Positioned(
                bottom: 0.0,
                left: 5.0,
                right: 5.0,
                child: ElevatedButton(
                  onPressed: () {
                    // current.site = site;
                    Navigator.pop(context, current);
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

  // List<Widget> _getTitleWidget() {
  //   return [
  //     _getTitleItemWidget('Bureau', 100),
  //     _getTitleItemWidget('Codes', 200),
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
  //     child: Text(
  //         current.bureaux == null ? '' : (current.bureaux[index].bureau!)),
  //     width: 100,
  //     height: 52,
  //     padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //     alignment: Alignment.centerLeft,
  //   );
  // }
  //
  // Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
  //   var codes = current.bureaux[index].barCodes!.join(', ');
  //   return Row(
  //     children: <Widget>[
  //       Container(
  //         child: Row(
  //           children: <Widget>[Text(codes)],
  //         ),
  //         width: 100,
  //         height: 52,
  //         padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
  //         alignment: Alignment.centerLeft,
  //       ),
  //     ],
  //   );
  // }
}
