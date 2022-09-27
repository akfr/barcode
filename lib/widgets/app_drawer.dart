import 'package:animation_wrappers/Animations/faded_slide_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jomar_barcode/screens/manage_service_screen.dart';
import 'package:jomar_barcode/screens/settings_screen.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer();
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Builder(builder: (BuildContext context) {
      return Drawer(
        child: FadedSlideAnimation(
          ListView(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                color: theme.scaffoldBackgroundColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.close),
                        color: theme.primaryColor,
                        iconSize: 28,
                        onPressed: () => Navigator.pop(context)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
                      child: Row(
                        children: [
                          // ClipRRect(
                          //   borderRadius: BorderRadius.circular(12),
                          //   child: Image.asset(
                          //     Assets.User,
                          //     height: 72,
                          //     width: 72,
                          //   ),
                          // ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.7,
                                child: Text('Gestion Inventaire BNI',
                                    style: theme.textTheme.headline6),
                              ),
                              const SizedBox(height: 6),
                              const SizedBox(height: 4),
                              /*  Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppTheme.ratingsColor,
                              ),
                              child: Row(
                                children: [
                                  Text('4.2', style: TextStyle(fontSize: 12)),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.star,
                                    color: AppTheme.starColor,
                                    size: 10,
                                  )
                                ],
                              ),
                            ),*/
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              ListTile(
                leading:
                    Icon(Icons.settings, color: theme.primaryColor, size: 24),
                title: Text(
                  "Inventaire",
                  style: theme.textTheme.headline5,
                ),
                onTap: () {
                  Navigator.pushNamed(context, SettingsScreen.idScreen);
                },
              ),
              SizedBox(
                height: 12,
              ),
              ListTile(
                leading: Icon(Icons.business_outlined,
                    color: theme.primaryColor, size: 24),
                title: Text(
                  "Services",
                  style: theme.textTheme.headline5,
                ),
                onTap: () {
                  Navigator.pushNamed(context, ManageServiceScreen.idScreen);
                },
              ),
            ],
          ),
          beginOffset: const Offset(0, 0),
          endOffset: const Offset(0, 0),
          slideCurve: Curves.linearToEaseOut,
        ),
      );
    });
  }

  ListTile buildListTile(BuildContext context, IconData icon, String title) {
    var theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.primaryColor, size: 24),
      title: Text(
        title,
        style: theme.textTheme.headline5,
      ),
      // onTap: onTap as void Function(),
    );
  }
}
