import 'package:jomar_barcode/models/materiel_barcode.dart';

class SiteData {
  String? site;
  List<BureauData> bureaux = [];

  SiteData({required this.bureaux, this.site});
}

class BureauData {
  String? bureau;
  List<MaterielBarcode> barCodes = [];

  BureauData({this.bureau, required this.barCodes});
}

class Service {
  String? name;
  String? localisation;
  Service({this.name, this.localisation});
}

class InventaireItem {
  String id;
  String no;
  String? date;
  bool? isActive;
  InventaireItem(
      {required this.id, required this.no, this.date, this.isActive});
}

class Inventaire {
  String id;
  String no;
  String? service;
  String? bureau;
  String? scan;
  String? materiel;
  String? utilisateur;
  String? date;
  Inventaire(
      {required this.id,
      required this.no,
      this.service,
      this.bureau,
      this.date,
      this.scan,
      this.materiel,
      this.utilisateur});
}
