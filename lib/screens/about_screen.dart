import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';
import 'package:url_launcher/url_launcher.dart';

import 'last_tracks_screen.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  static final String tokenizationKey = 'sandbox_38brfbbn_ywrkwrt24jhxnrkc';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.primaryColor,
      appBar: AppBar(
        elevation: 0.0,
        leading: Image.asset('assets/appIcon.png'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              child: Container(
                height: MediaQuery.of(context).size.height-200,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.defaultPaddingSize),
                        child: Text(
                          Strings.about.toUpperCase(),
                          style: TextStyle(
                              fontSize: Dimensions.largeTextSize,
                              color: ColorResource.whiteColor
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height-250,
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(left: Dimensions.defaultPaddingSize, right: Dimensions.defaultPaddingSize,),
                                child: Text(
                                  Strings.aboutDetails,
                                  style: TextStyle(
                                      fontSize: Dimensions.defaultTextSize,
                                      color: ColorResource.whiteColor
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          child: Icon(
                              FontAwesomeIcons.instagram,
                            color: ColorResource.blackColor,
                            size: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.instagramUrl);
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.facebook,
                            color: ColorResource.blackColor,
                            size: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.facebookUrl);
                          },
                        ),
                        GestureDetector(
                          child: Image.asset(
                              'assets/tumblr.png',
                            width: 30,
                            height: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.tumblrUrl);
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.twitter,
                            color: ColorResource.blackColor,
                            size: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.twitterUrl);
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.mixcloud,
                            color: ColorResource.blackColor,
                            size: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.mixCloudUrl);
                          },
                        ),
                        GestureDetector(
                          child: Image.asset(
                            'assets/soundcloud.png',
                            width: 30,
                            height: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.soundCloudUrl);
                          },
                        ),
                        GestureDetector(
                          child: Icon(
                            FontAwesomeIcons.spotify,
                            color: ColorResource.blackColor,
                            size: 30,
                          ),
                          onTap: (){
                            _goToUrl(Strings.spotifyUrl);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _goToUrl(String url) async {
    if (canLaunch(url) != null) {
      launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _goToWhatsApp() {
    FlutterOpenWhatsapp.sendSingleMessage(Strings.contactPhone, 'Hello');
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
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),),
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
                        contentPadding: EdgeInsets.all(8)
                      ),
                    )
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      child: RaisedButton(
                          color: Colors.amber,
                        child: Text(
                            '10',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      onPressed: (){
                          setState(() {
                            amountController.text = '10';
                          });
                      }),
                    ),
                    SizedBox(width: 5,),
                    SizedBox(
                      width: 40,
                      child: RaisedButton(
                          color: Colors.amber,
                        child: Text(
                            '20',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      onPressed: (){
                        setState(() {
                          amountController.text = '20';
                        });
                      }),
                    ),
                    SizedBox(width: 5,),
                    SizedBox(
                      width: 40,
                      child: RaisedButton(
                        color: Colors.amber,
                          child: Text(
                              '50',
                            style: TextStyle(
                              color: Colors.white
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              amountController.text = '50';
                            });
                          }),
                    ),
                    SizedBox(width: 5,),
                    SizedBox(
                      width: 60,
                      child: RaisedButton(
                          color: Colors.amber,
                          child: Text(
                              '100',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                          onPressed: (){
                            setState(() {
                              amountController.text = '100';
                            });
                          }),
                    ),
                    SizedBox(width: 5,),
                    RaisedButton(
                        color: Colors.amber,
                        child: Text(
                            'Enter Amount',
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                        onPressed: (){
                          amountController.clear();
                        }),
                  ],
                ),
                FlatButton(
                  child: new Text(Strings.donate),
                  onPressed: (){
                    goToDonate(amountController.text);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    )) ?? false;
  }

  goToDonate(String amount) async{
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
    BraintreeDropInResult result =
    await BraintreeDropIn.start(request);
    if (result != null) {
      showNonce(result.paymentMethodNonce);
    }
  }


}
