import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radioactive/model/api_call.dart';
import 'package:radioactive/screens/player_screen.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';

class IntroScreen extends StatefulWidget {
  bool isPlaying;
  IntroScreen(this.isPlaying);

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with WidgetsBindingObserver{
  AppLifecycleState _lastLifecycleState;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    print('initState: ${this.widget.isPlaying}');

    Timer(
        Duration(seconds: 2),
            () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PlayerScreen(this.widget.isPlaying))));
  }

  @override
  void dispose() {
    //WidgetsBinding.instance.removeObserver(this);
    print(' dispose');

    super.dispose();
  }

 /* @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
    print(' destroy');
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            color: ColorResource.primaryColor
        ),
        child: Stack(
          children: [
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(left: Dimensions.defaultPaddingSize, right: Dimensions.defaultPaddingSize),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                          'assets/brand_logo.png',
                        height: 150,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        Strings.welcomeToRadioActive,
                        style: TextStyle(
                            fontSize: Dimensions.extraLargeTextSize,
                            color: ColorResource.whiteColor,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(Dimensions.defaultPaddingSize),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_forward,
                        color: ColorResource.whiteColor,
                        size: Dimensions.defaultPaddingSize,
                      ),
                      onPressed: (){
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PlayerScreen(this.widget.isPlaying)));
                      },
                    ),
                    SizedBox(height: 10.0,),
                    Text(
                      Strings.musicMatters,
                      style: TextStyle(
                          fontSize: Dimensions.largeTextSize,
                          color: ColorResource.whiteColor
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

