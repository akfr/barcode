
import 'package:jomar_barcode/models/site_data.dart';

class InventaireState {
  InventaireItem currentInventaire;

  InventaireState(
      {required this.currentInventaire,});

  InventaireState.copy(InventaireState copy,
      {required InventaireItem inventaire})
      : this(
      currentInventaire: inventaire
  );
}
