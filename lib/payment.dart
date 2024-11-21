import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:muhallidata/paymentpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './screens/validator.dart';

class CheckoutMethodSelectable extends StatefulWidget {
  String? email;
  CheckoutMethodSelectable({this.email});

  @override
  _CheckoutMethodSelectableState createState() =>
      _CheckoutMethodSelectableState();
}

// Pay public key
class _CheckoutMethodSelectableState extends State<CheckoutMethodSelectable> {
  bool isGeneratingCode = false;
  String amountV = "";
  int amount_Charge = 0;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Widget _entryField(String title, myicon, mykey, String inputvalue,
      TextEditingController controll,
      {dynamic valid, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: controll,
              validator: valid,
              keyboardType: mykey,
              onSaved: (String? val) {
                inputvalue = val!;
              },
              onChanged: (String val) {
                inputvalue = val;
                setState(() {
                  amount_Charge =
                      int.parse(val) + (0.02 * int.parse(val)).round();
                });
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  icon: Icon(myicon),
                  filled: true)),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          setState(() => _isLoading = true);
          await paymentgateway(_amountController.text);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          color: Color(0xff7c0000),
        ),
        child: Text(
          'Pay',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _PaystactfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _entryField("Amount ", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: validateAmount),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Amount to Pay + Charge",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: const EdgeInsets.all(2.0),
                        padding: const EdgeInsets.fromLTRB(10, 15, 100, 15),
                        child: Text(
                          "N$amount_Charge",
                          style: TextStyle(fontSize: 15.0),
                        ),
                        decoration: BoxDecoration(

                            //color: Color(0xfff3f3f4),

                            )),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<dynamic> paymentgateway(amount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://muhallidata.com/api/payment_gateway/';

      Response response = await post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Token ${sharedPreferences.getString("token")}'
              },
              body: jsonEncode(
                  {"amount": int.parse(amount), "medium": "paystack"}))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
        });

        var responseJson = json.decode(response.body);

        print(responseJson["responseBody"]["checkoutUrl"]);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                PaymentPage(url: responseJson["responseBody"]["checkoutUrl"])));
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(26, 35, 126, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        AwesomeDialog(
          context: context,
          animType: AnimType.bottomSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.error,
          title: 'Oops!',
          desc: "Something went wrong could not initialize payment gateway",
          btnCancelOnPress: () {},
          btnCancelText: "ok",
        ).show();
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(26, 35, 126, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } on TimeoutException {
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,request is taking much time to response, please retry",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } on Error catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,Unexpected error occured",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Toast.show('$error',
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("ATM Payment",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        _PaystactfieldsWidget(),
                        SizedBox(
                          height: 20,
                        ),
                        _submitButton(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey.shade200,
                                  offset: Offset(2, 4),
                                  blurRadius: 5,
                                  spreadRadius: 2)
                            ],
                            color: Color.fromARGB(255, 25, 0, 124),
                          ),
                          child: InkWell(
                            onTap: () {
                              // Navigate to the "/profile" page
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Text(
                              'Back',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                          // child: Text(
                          //   'Back',
                          //   style: TextStyle(fontSize: 20, color: Colors.white),
                          // ),
                        ),
                        Center(
                          child: Image.network(
                              'https://thebookmarketng.com/wp-content/uploads/2020/08/paystack-secured-300x147-1.png'),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
