import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';
import 'package:http/http.dart' as http;
import 'last_tracks_screen.dart';

class ShowScheduleScreen extends StatefulWidget {
  @override
  _ShowScheduleScreenState createState() => _ShowScheduleScreenState();
}

class _ShowScheduleScreenState extends State<ShowScheduleScreen> {

  bool isLoading = false;
  List mondayList = List();
  List tuesdayList = List();
  List wednesdayList = List();
  List thursdayList = List();
  List fridayList = List();
  List saturdayList = List();
  List sundayList = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getData();
    getSchedule();
  }
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: isLoading ? Text(
                  Strings.currentShow.toUpperCase() + ': ' +Strings.nowSchedule.toUpperCase(),
                  style: TextStyle(
                      fontSize: Dimensions.defaultTextSize,
                      color: ColorResource.blackColor
                  ),
                )
                    : CircularProgressIndicator(backgroundColor: Colors.white,)
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
              /*SingleChildScrollView(
                child: Container(
                  height: 1500,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: data.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) => EntryItem(
                      data[index],
                    ),
                  ),
                ),
              ),*/
              scheduleWidget(context),
              SizedBox(height: 50,),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async{
    final response = await http.get('http://radioactivefm.gr/api/zone.php');

    var data = json.decode(response.body);
    Strings.nowSchedule = data['title'];
    print('data: '+data['title'].toString());
  }

  void getSchedule() async {
    final response = await http.get('https://radioactivefm.gr/live/api/zone.php');

    var data = json.decode(response.body);


    setState(() {
      isLoading = true;
    });
    mondayList = data['Monday'];
    tuesdayList = data['Tuesday'];
    wednesdayList = data['Wednesday'];
    thursdayList = data['Thursday'];
    fridayList = data['Friday'];
    saturdayList = data['Saturday'];
    sundayList = data['Sunday'];


    print('data: '+mondayList.toString());
  }

  Widget scheduleWidget(BuildContext context) {
    return isLoading ? Column(
      children: [
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Monday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: mondayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Text(
                                '${mondayList[index]['title']}',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: Dimensions.largeTextSize,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Text(
                                mondayList[index]['desc'],
                                style: GoogleFonts.lato(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: Dimensions.defaultTextSize
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Start: ${mondayList[index]['start']}',
                                    style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: Dimensions.defaultTextSize,
                                    ),
                                  ),
                                  Text(
                                    'End: ${mondayList[index]['end']}',
                                    style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Tuesday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: tuesdayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Text(
                                '${tuesdayList[index]['title']}',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: Dimensions.largeTextSize,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Text(
                                tuesdayList[index]['desc'],
                                style: GoogleFonts.lato(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: Dimensions.defaultTextSize
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child:  ListTile(
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Start: ${tuesdayList[index]['start']}',
                                    style: GoogleFonts.lato(
                                      color: Colors.black,
                                      fontSize: Dimensions.defaultTextSize,
                                    ),
                                  ),
                                  Text(
                                    'End: ${tuesdayList[index]['end']}',
                                    style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Wednesday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: wednesdayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  '${wednesdayList[index]['title']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: Dimensions.largeTextSize,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  wednesdayList[index]['desc'],
                                  style: GoogleFonts.lato(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: Dimensions.defaultTextSize
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start: ${wednesdayList[index]['start']}',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                      ),
                                    ),
                                    Text(
                                      'End: ${wednesdayList[index]['end']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: Dimensions.defaultTextSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Thursday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: thursdayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  '${thursdayList[index]['title']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: Dimensions.largeTextSize,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  thursdayList[index]['desc'],
                                  style: GoogleFonts.lato(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: Dimensions.defaultTextSize
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start: ${thursdayList[index]['start']}',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                      ),
                                    ),
                                    Text(
                                      'End: ${thursdayList[index]['end']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: Dimensions.defaultTextSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Friday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: fridayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  '${fridayList[index]['title']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: Dimensions.largeTextSize,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  fridayList[index]['desc'],
                                  style: GoogleFonts.lato(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: Dimensions.defaultTextSize
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start: ${fridayList[index]['start']}',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                      ),
                                    ),
                                    Text(
                                      'End: ${fridayList[index]['end']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: Dimensions.defaultTextSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Saturday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: saturdayList.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  '${saturdayList[index]['title']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: Dimensions.largeTextSize,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  saturdayList[index]['desc'],
                                  style: GoogleFonts.lato(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: Dimensions.defaultTextSize
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start: ${saturdayList[index]['start']}',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                      ),
                                    ),
                                    Text(
                                      'End: ${saturdayList[index]['end']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: Dimensions.defaultTextSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ]
        ),
        ExpansionTile(
            backgroundColor: ColorResource.lightNeutralColor,
            title: Text(
              'Sunday',
              style: GoogleFonts.lato(
                  color: Colors.black,
                  fontSize: Dimensions.largeTextSize
              ),
            ),
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: sundayList.length,
                  //physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return Card(
                        elevation: 2,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  '${sundayList[index]['title']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.black,
                                    fontSize: Dimensions.largeTextSize,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Text(
                                  sundayList[index]['desc'],
                                  style: GoogleFonts.lato(
                                      color: Colors.black.withOpacity(0.4),
                                      fontSize: Dimensions.defaultTextSize
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child:  ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Start: ${sundayList[index]['start']}',
                                      style: GoogleFonts.lato(
                                        color: Colors.black,
                                        fontSize: Dimensions.defaultTextSize,
                                      ),
                                    ),
                                    Text(
                                      'End: ${sundayList[index]['end']}',
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontSize: Dimensions.defaultTextSize,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                    );
                  },
                ),
              ),
            ]
        ),
      ],
    )
        : CircularProgressIndicator(backgroundColor: Colors.white,);
  }
}

/*
class Entry {
  final String title;
  final List<Entry>
  children; // Since this is an expansion list ...children can be another list of entries
  Entry(this.title, [this.children = const <Entry>[]]);
}

// This is the entire multi-level list displayed by this app
final List<Entry> data = <Entry>[
  Entry(
    'Monday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - RIRIS MUSIC MATTERS LIVE',),
      Entry('2:00pm - HOT-ELECTRIC ZONE',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - ALKALINO RADIOSHOW',),
    ],
  ),
  // Second Row
  Entry('Tuesday',
      <Entry>[
        Entry('12:00am - THE NIGHT OWL',),
        Entry('1:00am - MELLOW ZONE',),
        Entry('7:00am - GOOD MORNING SUNSHINE',),
        Entry('11:00am - RADIOACTIVE GOLD',),
        Entry('12:00pm - RIRIS MUSIC MATTERS LIVE',),
        Entry('2:00pm - HOT-ELECTRIC ZONE',),
        Entry('5:00pm - RADIOACTIVE GOLD',),
        Entry('6:00pm - PARTY DOWN ZONE',),
        Entry('7:00pm - SUNSET BLVD',),
        Entry('8:00pm - FUNK ME ROYAL',),
        Entry('11:00pm - SANFRANDISKO IN THE',),
  ]),
  Entry(
    'Wednesday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - HOT-ELECTRIC ZONE',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - THE FUNK SINATRA SHOW',),
    ],
  ),
  Entry(
    'Thursday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - HOT-ELECTRIC ZONE',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - DJ LAUREL DISCO LOVE',),
    ],
  ),
  Entry(
    'Friday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - HOT LUNCH MIX',),
      Entry('1:00pm - HOT-ELECTRIC ZONE',),
      Entry('2:00pm - HOT-ELECTRIC ZONE',),
      Entry('4:00pm - THE ENDLESS MUSIC',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - THE FUNKBRO SHOW',),
    ],
  ),
  Entry(
    'Saturday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - HOT-ELECTRIC ZONE',),
      Entry('3:00pm - HOT-ELECTRIC ZONE',),
      Entry('4:00pm - THE ENDLESS MUSIC',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - SATURDAY NIGHT FEVER',),
      Entry('10:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - THE NIGHT OWL',),
    ],
  ),
  Entry(
    'Sunday',
    <Entry>[
      Entry('12:00am - THE NIGHT OWL',),
      Entry('1:00am - MELLOW ZONE',),
      Entry('7:00am - GOOD MORNING SUNSHINE',),
      Entry('11:00am - RADIOACTIVE GOLD',),
      Entry('12:00pm - HOT-ELECTRIC ZONE',),
      Entry('1:00pm - UFE',),
      Entry('2:00pm - HOT-ELECTRIC ZONE',),
      Entry('3:00pm - HOT-ELECTRIC ZONE',),
      Entry('4:00pm - THE ENDLESS MUSIC',),
      Entry('5:00pm - RADIOACTIVE GOLD',),
      Entry('6:00pm - PARTY DOWN ZONE',),
      Entry('7:00pm - SUNSET BLVD',),
      Entry('8:00pm - FUNK ME ROYAL',),
      Entry('11:00pm - THE NIGHT OWL',),
    ],
  ),
];

// Create the Widget for the row
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);
  final Entry entry;

  // This function recursively creates the multi-level list rows.
  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty) {
      return ListTile(
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: ColorResource.whiteColor,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                    root.title,
                ),
              ],
            ),
          ),
        ),
      );
    }
    return ExpansionTile(
      key: PageStorageKey<Entry>(root),
      title: Text(
          root.title,
        style: TextStyle(
            fontSize: Dimensions.defaultTextSize,
            color: ColorResource.whiteColor,
        ),
      ),
      children: root.children.map<Widget>(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: _buildTiles(entry));
  }
}*/
