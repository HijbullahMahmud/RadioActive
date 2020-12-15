import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:radioactive/utility/strings.dart';
import 'package:xml2json/xml2json.dart';

class ApiCall{
  static startTimer() async{
    //print('object');
    Timer _timer;
    int _start = 10;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) =>
            () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start++;
            print('timer: '+_start.toString());
            getSongInfo();
          }
        },
    );
  }

  static getLastFiveSongs() async {
    final response = await http.get('https://radioactivefm.gr/live/rds/last5.txt');
    var data = response.body.toString();
    List list = data.split('\n');

    List list1 = list[0].toString().split(' - ');
    Strings.song1 = list1[0].toString();
    Strings.artist1 = list1[1].toString();

    List list2 = list[1].toString().split(' - ');
    Strings.song2 = list2[0].toString();
    Strings.artist2 = list2[1].toString();

    List list3 = list[2].toString().split(' - ');
    Strings.song3 = list3[0].toString();
    Strings.artist3 = list3[1].toString();

    List list4 = list[3].toString().split(' - ');
    Strings.song4 = list4[0].toString();
    Strings.artist4 = list4[1].toString();

    List list5 = list[4].toString().split(' - ');
    Strings.song5 = list5[0].toString();
    Strings.artist5 = list5[1].toString();

    //print('response: '+list[1].toString());
  }

  static getSongInfo() async {
    final response = await http.get('https://radioactivefm.gr/live/rds/CurrentSong.txt');
    var data = response.body;
    List list = data.toString().split(' - ');
    Strings.songName = list[0].toString();
    Strings.artist = list[1].toString();
    //print('response: '+data.toString());
  }

  static getImageUrl() async {
    final response = await http.get('https://www.radioactivefm.gr/live/api/getCover.php');

    var result = response.body;

    Xml2Json xml2json = new Xml2Json();
    xml2json.parse(result);
    var songData = xml2json.toParker();
    var rJson = json.decode(songData);
    Strings.imageUrl = rJson['cover']['cover_data']['image_url']['cover_data'].toString();

    //print(rJson['cover']['cover_data']['image_url']['cover_data'].toString());

  }
}