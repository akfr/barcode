import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:jomar_barcode/models/site_data.dart';

class AppDataProvider with ChangeNotifier {
  SiteData currentSite = SiteData(bureaux: [], site: '');

  void updateCurrentSite(SiteData siteData) {
    currentSite = siteData;
    notifyListeners();
  }

  String numeroInventaire = '';

  void updateNumeroInventaire(String numero) {
    numeroInventaire = numero;
    notifyListeners();
  }
}
