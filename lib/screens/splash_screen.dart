import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jomar_barcode/app_theme.dart';
import 'package:jomar_barcode/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String idScreen = "SplashScreen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => {_loadScreen()});
  }

  _loadScreen() {
    Navigator.of(context).pushNamed(HomeScreen.idScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        // color: kColorDarkBlue,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(
                        Icons.add,
                        // color: kColorPink,
                        size: 48,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Gestion',
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const TextSpan(
                              text: 'Inventaires',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 150,
              height: 2,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.orange,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}
