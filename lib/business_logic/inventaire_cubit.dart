import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jomar_barcode/business_logic/inventaire_state.dart';
import 'package:jomar_barcode/models/site_data.dart';

class InventaireCubit extends Cubit<InventaireState> {
  InventaireCubit()
      : super(InventaireState(currentInventaire: InventaireItem(id: '', no: '')));

  void setCurrentInventaire(InventaireItem value) {
    emit(InventaireState.copy(state, inventaire: value));
  }
}