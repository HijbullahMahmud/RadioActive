import 'package:flutter/material.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset('assets/appIcon.png'),

      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                Strings.showSchedule.toUpperCase(),
                style: TextStyle(
                    fontSize: Dimensions.largeTextSize,
                    color: ColorResource.whiteColor
                ),
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                Strings.time,
                style: TextStyle(
                    fontSize: Dimensions.defaultTextSize,
                    color: Colors.white
                ),
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: ColorResource.whiteColor,
                    size: 30,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    Strings.next.toUpperCase() + ': ' +Strings.nextSchedule.toUpperCase(),
                    style: TextStyle(
                        fontSize: Dimensions.largeTextSize,
                        color: ColorResource.whiteColor
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                Strings.weeklySchedule.toUpperCase(),
                style: TextStyle(
                    fontSize: Dimensions.largeTextSize,
                    color: ColorResource.whiteColor
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
