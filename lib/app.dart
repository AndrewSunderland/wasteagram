import 'package:flutter/material.dart';
import 'screens/waste_list_screen.dart';
import 'screens/waste_post_screen.dart';

class App extends StatelessWidget {

  static final routes = {
    WasteListScreen.routeName: (context) => WasteListScreen(),
    WasteListPostScreen.routeName: (context) => WasteListPostScreen(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastegram',
      theme: ThemeData.dark(),
      routes: routes,
    );

  }
}