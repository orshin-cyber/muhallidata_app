import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Bottom_pin extends StatefulWidget {
  final String title;
  var onTap;

  Bottom_pin({required this.title, this.onTap});

  @override
  _Bottom_pinState createState() => _Bottom_pinState();
}

class _Bottom_pinState extends State<Bottom_pin> {
  final LocalAuthentication auth = LocalAuthentication();

  late bool _canCheckBiometrics;

  bool _isAuthenticating = false;
  final TextEditingController _pinPutController = TextEditingController();
  final TextEditingController _pinPutController2 = TextEditingController();
  final TextEditingController _pinPutController3 = TextEditingController();
  bool _isLoading = false;

  final FocusNode _pinPutFocusNode = FocusNode();
  final FocusNode _pinPutFocusNode2 = FocusNode();
  final FocusNode _pinPutFocusNode3 = FocusNode();
  bool useBiometric = true;
  String pin1 = '';
  String pin2 = '';
  String pin = '';
  bool isPin = false;

  @override
  void initState() {
    _checkBiometrics();
    filldetails();

    super.initState();
  }

  String? bio_icon() {
    if (Platform.isAndroid) {
      return "assets/fingerprint.png";
    } else if (Platform.isIOS) {
      return "assets/face_id.png";
    }
    return null;
  }

  String? bio_text() {
    if (Platform.isAndroid) {
      return "Fingerprint";
    } else if (Platform.isIOS) {
      return "Face ID";
    }
    return null;
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Color.fromRGBO(128, 6, 128, 1)),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        pin = pref.getString("pin")!;
        print('########PIN SELF########');
        print(pin);
        if (pin.isEmpty) {
          isPin = false;
        } else {
          isPin = true;
        }
      });
    }

    // setState(() {
    //   isPin = true;
    // });
  }

  Future<dynamic> _validate_pin(pinset) async {
    setState(() {
      _isLoading = true;
    });

    if (pinset == pin) {
      print("correct");
      Navigator.of(context).pop();
      await widget.onTap();
    } else {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _pinPutController.text = "";
        });
      }
      AwesomeDialog(
        context: context,
        animType: AnimType.bottomSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.error,
        title: 'Oops!',
        desc: "Incorrect Pin",
        btnCancelOnPress: () {},
        btnCancelText: "ok",
      ).show();
    }
  }

  Future<dynamic> _set_pin(pin1, pin2) async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.muhallidata.com/api/pin?pin1=$pin1&pin2=$pin2';

      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        },
      );
      print('###########CORRECT PIN SET########');
      print(pin1);
      print(pin2);

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("pin", pin1);

        setState(() {
          _isLoading = false;
          isPin = true;
          pin = pin1;
        });

        Toast.show("Transaction pin set successfully",
            backgroundColor: Colors.green,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
            _pinPutController.text = "";
            _pinPutController2.text = "";
            _pinPutController2.text = "";
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: Color.fromRGBO(46, 202, 139, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
            _pinPutController.text = "";
            _pinPutController2.text = "";
            _pinPutController3.text = "";
          });
        }
        Map responseJson = json.decode(response.body);
        if (responseJson.containsKey("error")) {
          AwesomeDialog(
            context: context,
            animType: AnimType.bottomSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.error,
            title: 'Oops!',
            desc: responseJson["error"],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
            _pinPutController.text = "";
          });
        }

        Toast.show("Uexpected error occured",
            backgroundColor: Color.fromRGBO(46, 202, 139, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
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

  /////Biometric functions

  Future<void> _checkBiometrics() async {
    try {
      final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
      setState(() {
        _canCheckBiometrics = canAuthenticateWithBiometrics;
      });
    } on PlatformException catch (e) {
      print(e);
    }

    print("can  _canCheckBiometrics $_canCheckBiometrics");
  }

  Future<void> _authenticate() async {
    Navigator.of(context).pop();
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to proceed',
      );
    } on PlatformException catch (e) {
      print(e);
    }

    if (authenticated == true) {
      await widget.onTap();
    }
    if (!mounted) {
      setState(() {});
    }
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    ToastContext().init(context);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return useBiometric
        ? SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(
                    phonesize.width * 0.02,
                    phonesize.height * 0.03,
                    phonesize.width * 0.03,
                    phonesize.height * 0.02),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0))),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Confirm Transaction",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.cancel_sharp,
                              color: Colors.red,
                            ))
                      ]),
                  SizedBox(height: phonesize.height * 0.01),
                  SizedBox(height: phonesize.height * 0.01),
                  Text(widget.title, style: TextStyle(fontSize: 17)),
                  Divider(
                    color: Colors.grey,
                  ),
                  SizedBox(height: phonesize.height * 0.01),
                  InkWell(
                    onTap: () {
                      print(_canCheckBiometrics);
                      if (_canCheckBiometrics == true) {
                        _isAuthenticating
                            ? _cancelAuthentication()
                            : _authenticate();
                      }
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            bio_icon()!,
                            height: 50,
                          ),
                          SizedBox(height: 8),
                          Text(bio_text()!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 19))
                        ]),
                  ),
                  SizedBox(height: phonesize.height * 0.02),
                  Column(
                    children: [
                      Text(
                        "or",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          setState(() {
                            useBiometric = false;
                          });
                        },
                        child: Text(
                          "Use Pin Instead",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: phonesize.height * 0.01),
                  _isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Processing..."),
                            SizedBox(width: 2),
                            CircularProgressIndicator(),
                          ],
                        )
                      : SizedBox()
                ])),
          )
        : isPin
            ? SingleChildScrollView(
                child: Container(
                    height: phonesize.height,
                    padding: EdgeInsets.fromLTRB(
                        phonesize.width * 0.02,
                        phonesize.height * 0.03,
                        phonesize.width * 0.03,
                        phonesize.height * 0.02),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))),
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Confirm Transaction",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.cancel_sharp,
                                  color: Colors.red,
                                ))
                          ]),
                      SizedBox(height: phonesize.height * 0.01),
                      SizedBox(height: phonesize.height * 0.01),
                      Text(widget.title, style: TextStyle(fontSize: 17)),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: phonesize.height * 0.01),
                      Text("ENTER PIN TO Confirm",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: phonesize.height * 0.01),
                      Container(
                        padding: EdgeInsets.fromLTRB(phonesize.width * 0.17, 0,
                            phonesize.width * 0.17, 0),
                        child: Pinput(
                          length: 5,
                          validator: (s) {},
                          useNativeKeyboard: false,
                          showCursor: true,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          obscureText: true,
                          onCompleted: (String pin) => _validate_pin(pin),
                          focusNode: _pinPutFocusNode,
                          controller: _pinPutController,
                          pinAnimationType: PinAnimationType.scale,
                        ),
                      ),
                      SizedBox(height: phonesize.height * 0.01),
                      _isLoading
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Processing..."),
                                SizedBox(width: 2),
                                CircularProgressIndicator(),
                              ],
                            )
                          : Container(
                              padding: EdgeInsets.fromLTRB(
                                  phonesize.width * 0.2,
                                  0,
                                  phonesize.width * 0.2,
                                  phonesize.height * 0.01),
                              child: GridView.count(
                                  crossAxisCount: 4,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 1,
                                  padding: const EdgeInsets.all(2),
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
                                      return RoundedButton(
                                        title: '$e',
                                        onTap: () {
                                          _pinPutController.text =
                                              '${_pinPutController.text}$e';
                                        },
                                      );
                                    }),
                                    RoundedButton(
                                      title: '<-',
                                      onTap: () {
                                        if (_pinPutController.text.isNotEmpty) {
                                          _pinPutController.text =
                                              _pinPutController.text.substring(
                                                  0,
                                                  _pinPutController
                                                          .text.length -
                                                      1);
                                        }
                                      },
                                    ),
                                  ]),
                            ),
                      SizedBox(height: phonesize.height * 0.02),
                      Column(
                        children: [
                          Text(
                            "or",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              setState(() {
                                useBiometric = true;
                              });
                            },
                            child: Text(
                              "Use ${bio_text()}",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ])),
              )
            : SingleChildScrollView(
                child: Padding(
                  // padding: const EdgeInsets.all(8.0),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context)
                        .viewInsets
                        .bottom, // This adjusts the view when the keyboard appears
                  ),
                  child: Container(
                      padding: EdgeInsets.all(
                          phonesize.height / phonesize.width + 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      child: Column(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Confirm Transaction",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.cancel_sharp,
                                    color: Colors.red,
                                  ))
                            ]),
                        Divider(height: 20, color: Colors.grey),
                        SizedBox(height: phonesize.height * 0.01),
                        Center(
                            child: Text(
                                "You have not set transaction pin , Please set Transaction pin to Confirm this Transaction",
                                style: TextStyle(fontSize: 17))),
                        SizedBox(height: phonesize.height * 0.01),
                        SizedBox(height: phonesize.height * 0.01),
                        Text("ENTER PIN ",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(phonesize.width * 0.17,
                              0, phonesize.width * 0.17, 0),
                          child: Pinput(
                            length: 5,
                            validator: (s) {},
                            useNativeKeyboard: true,
                            showCursor: true,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            obscureText: true,
                            onCompleted: (String? pin) => setState(() {
                              pin1 = pin!;
                            }),
                            focusNode: _pinPutFocusNode,
                            controller: _pinPutController,
                            pinAnimationType: PinAnimationType.scale,
                          ),
                        ),
                        SizedBox(height: phonesize.height * 0.01),
                        Text("RE-ENTER PIN",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.fromLTRB(phonesize.width * 0.17,
                              0, phonesize.width * 0.17, 0),
                          child: Pinput(
                            length: 5,
                            validator: (s) {},
                            useNativeKeyboard: true,
                            showCursor: true,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            obscureText: true,
                            onCompleted: (String? pin) => setState(() {
                              pin2 = pin!;
                            }),
                            focusNode: _pinPutFocusNode2,
                            controller: _pinPutController2,
                            pinAnimationType: PinAnimationType.scale,
                          ),
                        ),
                        SizedBox(height: phonesize.height * 0.01),
                        _isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("Processing..."),
                                  SizedBox(width: 2),
                                  CircularProgressIndicator(),
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  _set_pin(pin1, pin2);
                                },
                                child: Container(
                                  width: phonesize.width / 3.5,
                                  padding: EdgeInsets.symmetric(
                                      vertical: phonesize.height * 0.01),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: Offset(2, 4),
                                            blurRadius: 5,
                                            spreadRadius: 2)
                                      ],
                                      gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Color.fromRGBO(46, 202, 139, 1),
                                            Color.fromRGBO(46, 202, 139, 1)
                                          ])),
                                  child: Text(
                                    'Set pin',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),
                      ])),
                ),
              );
  }
}

class RoundedButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;

  RoundedButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.005,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color.fromRGBO(25, 21, 99, 1),
        ),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
