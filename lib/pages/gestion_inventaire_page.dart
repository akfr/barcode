import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jomar_barcode/business_logic/inventaire_cubit.dart';
import 'package:jomar_barcode/data/inventaire_database.dart';
import 'package:jomar_barcode/screens/add_inventaire_screen.dart';
import 'package:jomar_barcode/screens/add_service_screen.dart';
import 'package:jomar_barcode/screens/bureau_screen.dart';
import 'package:jomar_barcode/screens/home_screen.dart';
import 'package:jomar_barcode/screens/manage_service_screen.dart';
import 'package:jomar_barcode/screens/settings_screen.dart';
import 'package:jomar_barcode/screens/service_screen.dart';
import 'package:jomar_barcode/screens/splash_screen.dart';

import '../app_theme.dart';

class GestionInventaireApp extends StatefulWidget {
  const GestionInventaireApp({Key? key}) : super(key: key);

  @override
  State<GestionInventaireApp> createState() => _GestionInventaireAppState();
}

class _GestionInventaireAppState extends State<GestionInventaireApp> {
  // final RideDetailCubit rideDetailCubit = RideDetailCubit();
  InventaireDatabase database = InventaireDatabase();
  final InventaireCubit inventaireCubit = InventaireCubit();

  @override
  void initState() {
    database.initialiseDatabase();
    super.initState();
  }

  @override
  void dispose() {
    // rideDetailCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      routes: {
        HomeScreen.idScreen: (context) => BlocProvider.value(
              value: inventaireCubit,
              child: HomeScreen(),
            ),
        SettingsScreen.idScreen: (context) => BlocProvider.value(
              value: inventaireCubit,
              child: SettingsScreen(),
            ),
        ServiceScreen.idScreen: (context) => ServiceScreen(),
        BureauScreen.idScreen: (context) => BureauScreen(),
        SplashScreen.idScreen: (context) => const SplashScreen(),
        ManageServiceScreen.idScreen: (context) => const ManageServiceScreen(),
        AddServiceScreen.idScreen: (context) => const AddServiceScreen(),
        AddInventaireScreen.idScreen: (context) => AddInventaireScreen(),
      },
      initialRoute: SplashScreen.idScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
