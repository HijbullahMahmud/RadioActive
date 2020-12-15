import 'package:flutter/material.dart';
import 'package:radioactive/screens/player_screen.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';
import 'package:http/http.dart' as http;

class LastTracksScreen extends StatefulWidget {
  @override
  _LastTracksScreenState createState() => _LastTracksScreenState();
}

class _LastTracksScreenState extends State<LastTracksScreen> {
  static String song1 = '', song2 = '', song3 = '', song4 = '', song5 = '', artist1 = '', artist2 = '', artist3 = '', artist4 = '', artist5 = '';
  bool _isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLastFiveSongs();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset('assets/appIcon.png'),
        /*actions: [
          Padding(
            padding: const EdgeInsets.only(right: Dimensions.defaultPaddingSize),
            child: Icon(
              Icons.menu,
              color: ColorResource.darkNeutralColor,
            ),
          )
        ],*/
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(left: Dimensions.defaultPaddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Strings.last5TracksAired.toUpperCase(),
                      style: TextStyle(
                          fontSize: Dimensions.largeTextSize,
                          color: ColorResource.whiteColor
                      ),
                    ),
                    SizedBox(height: 20,),
                    _isLoading ? Container(
                      height: MediaQuery.of(context).size.height-150,
                      child: ListView.builder(
                          itemCount: 1,
                          //physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.asset('assets/chess.png'),
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song1,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                            Text(
                                              artist1,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: ColorResource.darkNeutralColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.asset('assets/chess.png'),
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song2,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                            Text(
                                              artist2,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: ColorResource.darkNeutralColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.asset('assets/chess.png'),
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song3,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                            Text(
                                              artist3,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: ColorResource.darkNeutralColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.asset('assets/chess.png'),
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song4,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                            Text(
                                              artist4,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: ColorResource.darkNeutralColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 5
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                child: Image.asset('assets/chess.png'),
                                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        flex: 4,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              song5,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                            Text(
                                              artist5,
                                              style: TextStyle(
                                                  fontSize: Dimensions.defaultTextSize,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorResource.whiteColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.share,
                                            color: ColorResource.darkNeutralColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                    )
                        : CircularProgressIndicator(backgroundColor: Colors.white,)
                  ],
                ),
              ),
            ),
            /*Positioned(
              bottom: 0,
              child: GestureDetector(
                child: Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: ColorResource.whiteColor
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.nowPlaying,
                              style: TextStyle(
                                  fontSize: Dimensions.largeTextSize,
                                  color: ColorResource.darkNeutralColor
                              ),
                            ),
                            Text(
                              Strings.songName,
                              style: TextStyle(
                                  fontSize: Dimensions.defaultTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResource.primaryColor
                              ),
                            ),
                            Text(
                              Strings.artist,
                              style: TextStyle(
                                  fontSize: Dimensions.defaultTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: ColorResource.darkNeutralColor
                              ),
                            ),
                            Text(
                              Strings.genre,
                              style: TextStyle(
                                  fontSize: Dimensions.defaultTextSize,
                                  color: ColorResource.darkNeutralColor
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              color: ColorResource.lightNeutralColor,
                              borderRadius: BorderRadius.all(Radius.circular(40))
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.pause,
                              size: 35,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PlayerScreen()
                  ));
                },
              ),
            )*/
          ],
        ),
      ),
    );
  }

  getLastFiveSongs() async {
    final response = await http.get('https://radioactivefm.gr/live/rds/last5.txt');
    var data = response.body.toString();
    List list = data.split('\n');

    List list1 = list[0].toString().split(' - ');
    String s1 = list1[0].toString();
    String a1 = list1[1].toString();

    List list2 = list[1].toString().split(' - ');
    String s2 = list2[0].toString();
    String a2 = list2[1].toString();

    List list3 = list[2].toString().split(' - ');
    String s3 = list3[0].toString();
    String a3 = list3[1].toString();

    List list4 = list[3].toString().split(' - ');
    String s4 = list4[0].toString();
    String a4 = list4[1].toString();

    List list5 = list[4].toString().split(' - ');
    String s5 = list5[0].toString();
    String a5 = list5[1].toString();

    setState(() {
      song1 = s1;
      song2 = s2;
      song3 = s3;
      song4 = s4;
      song5 = s5;
      _isLoading = true;
      artist1 = a1;
      artist2 = a2;
      artist3 = a3;
      artist4 = a4;
      artist5 = a5;
    });
    //print('response: '+list[1].toString());
  }
}
