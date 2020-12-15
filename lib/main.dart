import 'package:flutter/material.dart';
import 'package:radioactive/screens/intro_screen.dart';
import 'package:radioactive/screens/player_screen.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String isPlay = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //getSaveData();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: ColorResource.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroScreen()
    );
  }

  void getSaveData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    isPlay = sp.getString('radio');

    print('now radio status: $isPlay');
  }
}

