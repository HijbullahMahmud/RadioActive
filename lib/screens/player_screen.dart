import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'package:intl/intl.dart';
import 'package:radioactive/screens/about_screen.dart';
import 'package:radioactive/screens/last_tracks_screen.dart';
import 'package:radioactive/screens/show_schedule_screen.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml2json/xml2json.dart';

class PlayerScreen extends StatefulWidget {
  var playerState = FlutterRadioPlayer.flutter_radio_paused;
  var volume = 0.8;

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;

  int _currentIndex = 0;
  final List<Widget> _children = [
    new PlayerScreen(),
  ];
  FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();

  static String imageUrl =
          'https://radioactivefm.gr/wp-content/uploads/2019/12/logo_master.png',
      currentTitle = '',
      currentArtist = '';
  List<String> playerList = ['192Kbps', '64Kbps'];
  String selectedPlayer = '';
  String liveAtPlayer = '';
  String day = '';
  String time = '';
  bool _isPlaying = true;
  String dropdownValue = 'One';
  Timer _timer;
  int _start = 2;
  String status = 'hidden';
  String title, artist;
  static final String tokenizationKey = 'sandbox_ndzxvs7r_ywrkwrt24jhxnrkc';
  SharedPreferences sp;
  TextEditingController amountController = TextEditingController();

  void showNonce(BraintreePaymentMethodNonce nonce) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Payment method nonce:'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Nonce: ${nonce.nonce}'),
            SizedBox(height: 16),
            Text('Type label: ${nonce.typeLabel}'),
            SizedBox(height: 16),
            Text('Description: ${nonce.description}'),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    print("initState was called");
    _controller = new AnimationController(vsync: this)
      ..repeat(min: 0.0, max: 1.0, period: const Duration(seconds: 1))
      ..addListener(() {
        // print('animation value ${_controller.value}');
      });

    super.initState();

    getSaveData();
    selectedPlayer = playerList[1].toString();
    liveAtPlayer = '64 aac+';
    startTimer();
    _flutterRadioPlayer.play();
    initRadioService();
  }

  @override
  void dispose() {
    print("dispose was called");
    _controller.dispose();
   // _flutterRadioPlayer.stop();
    super.dispose();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate

    print('deactive appppppppppp');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('Live @ '),
            Text(
              liveAtPlayer,
              style: TextStyle(fontSize: Dimensions.defaultTextSize),
            ),
          ],
        ),
        leading: Image.asset('assets/appIcon.png'),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: ColorResource.primaryColor,
              ),
              child: Center(
                child: Image.asset(
                  'assets/appIcon.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              height: 60,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.audiotrack_outlined,
                        color: ColorResource.primaryColor),
                    Text(
                      'MP3 Stream:',
                      style: TextStyle(color: ColorResource.primaryColor),
                    ),
                    openPlayerDropDown(context)
                  ],
                ),
              ),
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.schedule, color: ColorResource.primaryColor),
              title: Text(
                'Schedule',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ShowScheduleScreen()));
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.history, color: ColorResource.primaryColor),
              title: Text(
                'Last 5 Tracks',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LastTracksScreen()));
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading:
                  Icon(Icons.info_outline, color: ColorResource.primaryColor),
              title: Text(
                'About',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutScreen()));
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.payment, color: ColorResource.primaryColor),
              title: Text(
                'Donate',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                openDonatePopUp();
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.ac_unit, color: ColorResource.primaryColor),
              title: Text(
                'Terms & Conditions',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _goToUrl(Strings.termsNConditionsUrl);
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
            ListTile(
              leading: Icon(Icons.policy, color: ColorResource.primaryColor),
              title: Text(
                'Privacy Policy',
                style: TextStyle(color: ColorResource.primaryColor),
              ),
              onTap: () {
                Navigator.of(context).pop();
                _goToUrl(Strings.privacyUrl);
              },
            ),
            Divider(
              color: ColorResource.primaryColor,
            ),
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              //top: -10,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Positioned(
                      top: -10,
                      bottom: 100,
                      child: Center(
                        child: Container(
                          height: 500,
                          width: MediaQuery.of(context).size.width,
                          decoration: new BoxDecoration(
                            color: Colors.transparent,
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: new NetworkImage(
                                imageUrl,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 60, right: 60),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day + ' ' + time,
                                        style: TextStyle(
                                            fontSize: Dimensions.smallTextSize,
                                            fontWeight: FontWeight.bold,
                                            color: ColorResource.whiteColor),
                                      ),
                                      Text(
                                        Strings.nowSchedule,
                                        style: TextStyle(
                                            fontSize: Dimensions.largeTextSize,
                                            fontWeight: FontWeight.bold,
                                            color: ColorResource.whiteColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 60, right: 60),
                                child: Container(
                                  height: 300,
                                  width: MediaQuery.of(context).size.width,
                                  child: Stack(
                                    children: [
                                      Container(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: ClipRRect(
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.contain,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                          ),
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 60, right: 60),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          currentTitle,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          currentArtist,
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: 18,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      StreamBuilder(
                          stream: _flutterRadioPlayer.isPlayingStream,
                          initialData: widget.playerState,
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            String returnData = snapshot.data;
                            print('radioState: $returnData');

                            switch (returnData) {
                              case FlutterRadioPlayer.flutter_radio_playing:
                              return  FlatButton(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35))),
                                      child: Icon(Icons.stop),
                                    ),
                                    onPressed: () async {
                                      //await initRadioService();
                                      _flutterRadioPlayer.playOrPause();
                                    });
                              case FlutterRadioPlayer.flutter_radio_paused:
                                return FlatButton(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35))),
                                      child: Icon(Icons.play_arrow_outlined),
                                    ),
                                    onPressed: () async {
                                      //await initRadioService();
                                      _flutterRadioPlayer.playOrPause();
                                    });
                              case FlutterRadioPlayer.flutter_radio_stopped:
                                return FlatButton(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35))),
                                      child: Icon(Icons.play_arrow),
                                    ),
                                    onPressed: () async {
                                      await initRadioService();
                                    });
                                break;
                              case FlutterRadioPlayer.flutter_radio_loading:
                                return CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                );
                              case FlutterRadioPlayer.flutter_radio_error:
                                return FlatButton(
                                    child: Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(35))),
                                      child: Icon(Icons.play_arrow),
                                    ),
                                    onPressed: () async {
                                      await initRadioService();
                                    });
                                break;
                              default:
                                return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(35))),
                                          child: snapshot.data ==
                                                  FlutterRadioPlayer
                                                      .flutter_radio_playing
                                              ? IconButton(
                                                  onPressed: () async {
                                                    print(
                                                        "button press data: " +
                                                            snapshot.data
                                                                .toString());
                                                    await _flutterRadioPlayer
                                                        .stop();

                                                    print('radio: ' + 'stop');
                                                    /*if(returnData != 'flutter_radio_paused'){
                                                _flutterRadioPlayer.stop();
                                              }*/
                                                  },
                                                  icon: Icon(Icons.stop))
                                              : IconButton(
                                                  onPressed: () async {
                                                    print(
                                                        "button press data: " +
                                                            snapshot.data
                                                                .toString());
                                                    await _flutterRadioPlayer
                                                        .play();

                                                    print('radio: ' + 'play');
                                                    /*if(returnData != 'flutter_radio_paused'){
                                                _flutterRadioPlayer.stop();
                                              }*/
                                                  },
                                                  icon:
                                                      Icon(Icons.play_arrow))),
                                    ]);
                                break;
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> openDonatePopUp() async {
    return (await showDialog(
          context: context,
          builder: (context) => Container(
            width: MediaQuery.of(context).size.width,
            child: new AlertDialog(
              title: Text(
                '${(Strings.supportRadioActive)}',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Text(
                  Strings.donateDetails,
                  textAlign: TextAlign.justify,
                ),
              ),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 100.0,
                        height: 40,
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.euro),
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding: EdgeInsets.all(8)),
                        )),
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: RaisedButton(
                              color: Colors.amber,
                              child: Text(
                                '10',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  amountController.text = '10';
                                });
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 40,
                          child: RaisedButton(
                              color: Colors.amber,
                              child: Text(
                                '20',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  amountController.text = '20';
                                });
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 40,
                          child: RaisedButton(
                              color: Colors.amber,
                              child: Text(
                                '50',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  amountController.text = '50';
                                });
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                          width: 60,
                          child: RaisedButton(
                              color: Colors.amber,
                              child: Text(
                                '100',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  amountController.text = '100';
                                });
                              }),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        RaisedButton(
                            color: Colors.amber,
                            child: Text(
                              'Enter Amount',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              amountController.clear();
                            }),
                      ],
                    ),
                    FlatButton(
                      child: new Text(Strings.donate),
                      onPressed: () {
                        goToDonate(amountController.text);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        )) ??
        false;
  }

  goToDonate(String amount) async {
    var request = BraintreeDropInRequest(
      tokenizationKey: tokenizationKey,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: amount,
        currencyCode: 'USD',
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(
        amount: amount,
        displayName: 'RadioActive',
      ),
      cardEnabled: true,
    );
    BraintreeDropInResult result = await BraintreeDropIn.start(request);
    if (result != null) {
      showNonce(result.paymentMethodNonce);
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start++;
            print('timer: ' + _start.toString());
            //getSongInfo();
            getImageUrl();
            getData();
            //initRadioService(currentTitle, currentArtist);
            //getLastFiveSongs();
          }
        },
      ),
    );
  }

  getSongInfo() async {
    final response =
        await http.get('https://radioactivefm.gr/live/rds/CurrentSong.txt');
    var data = response.body;
    List list = data.toString().split(' - ');
    String title = list[0].toString();
    String artist = list[1].toString();
    print('title: ' + title);
    setState(() {
      time = DateFormat.jm().format(DateTime.now());
      day = DateFormat('EEEE').format(DateTime.now());
      Strings.time = time;
      currentTitle = title;
      currentArtist = artist;
    });
    //print('response: '+data.toString());
  }

  getImageUrl() async {
    setState(() {
      //imageUrl = 'https://radioactivefm.gr/wp-content/uploads/2019/12/logo_master.png';
    });
    final response =
        await http.get('https://www.radioactivefm.gr/live/api/getCover.php');

    print('response: ' + response.statusCode.toString());

    if (response.statusCode.toString() == '200') {
      var result = response.body;
      Xml2Json xml2json = new Xml2Json();
      xml2json.parse(result);
      var songData = xml2json.toParker();
      var rJson = json.decode(songData);
      String image =
          rJson['cover']['cover_data']['image_url']['cover_data'].toString();
      String metaData = rJson['cover']['cover_data']['song_title'].toString();
      List list = metaData.toString().split(' - ');
      String title = list[0].toString();
      String artist = list[1].toString();
      setState(() {
        currentTitle = title;
        currentArtist = artist;
      });
      print('cover url: ' + image);
      setState(() {
        imageUrl = image;
        currentTitle = title;
        currentArtist = artist;
      });
    } else {
      setState(() {
        imageUrl =
            'https://radioactivefm.gr/wp-content/uploads/2019/12/logo_master.png';
      });
      print('image url: ' + imageUrl);
    }
  }

  void getData() async {
    final response = await http.get('http://radioactivefm.gr/api/zone.php');

    var data = json.decode(response.body);
    Strings.nowSchedule = data['title'];
    print('data: ' + data['title'].toString());
  }

  Widget openPlayerDropDown(BuildContext context) {
    return DropdownButton<String>(
      dropdownColor: ColorResource.primaryColor,
      items: playerList.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      hint: Text(
        selectedPlayer,
        style: TextStyle(color: ColorResource.darkNeutralColor),
      ),
      onChanged: (value) {
        setState(() {
          selectedPlayer = value;
          if (selectedPlayer == '192Kbps') {
            liveAtPlayer = '192 mp3';
            _flutterRadioPlayer.setUrl(Strings.radioUrl192, "true");
          } else {
            liveAtPlayer = '64 acc+';
            _flutterRadioPlayer.setUrl(Strings.radioUrl64, "true");
          }
          print('selectedPlayer: ' + Strings.radioUrl192);
        });
      },
      underline: Container(),
    );
  }

  /*Future<bool> _backPressed() async {
    return (await showDialog(
      barrierColor: Colors.white,
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          'Alert!',
          style: TextStyle(
              color: Colors.red
          ),
        ),
        content: Text(
          'Do you want to exit RadioActive?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          FlatButton(
            onPressed: () {
              _flutterRadioPlayer.stop();
              SystemNavigator.pop();
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }*/

  Future<void> initRadioService() async {
    if(_flutterRadioPlayer != null){
      print('radioState: player is not null');
    }else{
      print('radioState: player is null');
    }
    try {
      await _flutterRadioPlayer.init("$currentTitle", "$currentArtist", Strings.radioUrl64, "true");
    } on PlatformException {
      print("Exception occurred while trying to register the services.");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      print('radioState: app resumed');
    }
  }

  _goToUrl(String url) async {
    if (canLaunch(url) != null) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getSaveData() async {
    sp = await SharedPreferences.getInstance();
  }
}
