import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:radioactive/utility/color_resource.dart';
import 'package:radioactive/utility/dimensions.dart';
import 'package:radioactive/utility/strings.dart';

class DonateScreen extends StatefulWidget {
  @override
  _DonateScreenState createState() => _DonateScreenState();
}

class _DonateScreenState extends State<DonateScreen> {

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
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: Dimensions.defaultPaddingSize, top: 50),
                        child: Text(
                          Strings.donate.toUpperCase(),
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
                                  Strings.donateDetails,
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
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 100.0,
                            height: 40,
                            child: TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                      Icons.euro,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(

                                  ),
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(8)
                              ),
                            )
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 50,
                              child: RaisedButton(
                                  color: Colors.amber,
                                  child: Text(
                                    '10',
                                    style: TextStyle(
                                        color: Colors.white,
                                      fontSize: 12
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
                              width: 50,
                              child: RaisedButton(
                                  color: Colors.amber,
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
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
                              width: 50,
                              child: RaisedButton(
                                  color: Colors.amber,
                                  child: Text(
                                    '50',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12
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
                                        color: Colors.white,
                                        fontSize: 12
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
                                      color: Colors.white,
                                      fontSize: 12
                                  ),
                                ),
                                onPressed: (){
                                  amountController.clear();
                                }),
                          ],
                        ),
                        RaisedButton(
                          color: Colors.white,
                          child: new Text(
                              Strings.donate,
                            style: TextStyle(
                              color: ColorResource.primaryColor
                            ),
                          ),
                          onPressed: (){
                            goToDonate(amountController.text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
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
