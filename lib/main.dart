import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:radioactive/screens/intro_screen.dart';
import 'package:radioactive/screens/player_screen.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
 // Hive.registerAdapter(PlayerStateAdapter());
  await Hive.openBox("playerState");
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isPlaying;
  var box;

  @override
  void initState()  {
    bool value =   Hive.box("playerState").get("playerState", defaultValue: false);
    setState(() {
      isPlaying = value;
    });
    print('playerState: $isPlaying');

    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ColorResource.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: IntroScreen(isPlaying)
    );
  }
}
