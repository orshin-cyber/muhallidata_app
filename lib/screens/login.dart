import 'dart:async';
import 'dart:convert';

import 'package:muhallidata/screens/dash2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:muhallidata/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();
  late bool _canCheckBiometrics;

  //List<BiometricType> _availableBiometrics;
  late String mykey;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? usernameV;
  String? passwordV;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  // Toggles the password show status

  // Future<void> _checkBiometrics() async {
  //   bool canCheckBiometrics;
  //   try {
  //     canCheckBiometrics = await auth.canCheckBiometrics;
  //     setState(() {
  //       _canCheckBiometrics = canCheckBiometrics;
  //     });
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

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

  // Future<void> _authenticate() async {
  //   Navigator.of(context).pop();
  //   bool authenticated = false;
  //   try {
  //     setState(() {
  //       _isAuthenticating = true;
  //     });
  //     authenticated = await auth.authenticate(
  //       localizedReason: 'Scan your fingerprint to proceed',
  //     );
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }

  //   if (authenticated == true) {
  //     await widget.onTap();
  //   }
  //   if (!mounted) {
  //     setState(() {});
  //   }
  // }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {});
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to access muhallidata',
      );

      setState(() {});
    } on PlatformException catch (e) {
      //print(e);
    }
    if (!mounted) return;
    if (authenticated == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      mykey = sharedPreferences.getString("tok")!;
      //print(mykey);
      setState(() {
        sharedPreferences.setString("token", mykey);
      });
      Toast.show("Welcome back ",
          backgroundColor: Colors.green,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => NewDashboard()),
          (Route<dynamic> route) => false);

      //print(mykey);
      //print("yea welcome");
    }

    setState(() {});
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  Future<dynamic> _loginUser(String username, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://muhallidata.com/rest-auth/login/';

      Response response = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        String url = 'https://www.muhallidata.com/api/user/';

        Response res = await get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${responseJson['key']}'
          },
        );
        // print('Login response#######################');
        // print(res.body);

        if (res.statusCode == 200 || res.statusCode == 201) {
          Map resJson = json.decode(res.body);

          List adminNum = resJson["Admin_number"]
              .map((net) => net["phone_number"])
              .toList();

          sharedPreferences.setString("Exam", json.encode(resJson!["Exam"]));
          sharedPreferences.setString(
              "topuppercentage", json.encode(resJson!["topuppercentage"]));
          sharedPreferences.setString(
              "percentage", json.encode(resJson!["percentage"]));
          sharedPreferences.setString(
              "banners", json.encode(resJson!["banners"]));
          sharedPreferences.setString("banks", json.encode(resJson!["banks"]));
          sharedPreferences.setString(
              "Dataplans", json.encode(resJson!["Dataplans"]));
          sharedPreferences.setString(
              "Cableplan", json.encode(resJson!["Cableplan"]));
          // if (!(resJson!["user"]["bank_accounts"]["accounts"].isEmpty)) {
          //   sharedPreferences.setString("account",
          //       json.encode(resJson!["user"]["bank_accounts"]["accounts"]));
          // } else {
          //   sharedPreferences.setString(
          //       "account", resJson["user"]["reservedaccountNumber"] ?? "");
          // }

          sharedPreferences.setString("account",
              json.encode(resJson!["user"]["bank_accounts"]["accounts"]) ?? "");
          // sharedPreferences.setString("account",
          //     json.encode(resJson!["user"]["bank_accounts"]["accounts"]));
          // sharedPreferences.setString(
          //     "support_phone_number", resJson!["support_phone_number"]);

          sharedPreferences.setString("pin", resJson!["user"]["pin"] ?? '');
          sharedPreferences.setString(
              "upgrade_fee", json.encode(resJson!["upgrade_fee"] ?? ""));
          sharedPreferences.setString("password", password!);
          // sharedPreferences.setString("fullname", resJson!["user"]["FullName"]);
          // sharedPreferences.setString("img", resJson!["user"]["img"]);
          sharedPreferences.setString("token", responseJson!['key']);
          sharedPreferences.setString("tok", responseJson!['key']);
          sharedPreferences.setString("username", resJson!["user"]["username"]);
          // sharedPreferences.setBool(
          //     "email_verify", resJson!["user"]["email_verify"]);
          sharedPreferences.setString(
              "user_type", resJson!["user"]["user_type"]);
          sharedPreferences.setString(
              "walletb", resJson!["user"]["wallet_balance"]);
          sharedPreferences.setString(
              "bonusb", resJson!["user"]["bonus_balance"]);
          sharedPreferences.setString("email", resJson!["user"]["email"]);
          sharedPreferences.setString(
              "notification", resJson!["notification"]["message"] ?? "");

          // sharedPreferences.setString(
          //     "account", resJson!["user"]["reservedaccountNumber"]);
          sharedPreferences.setString(
              "bank", resJson!["user"]["reservedbankName"] ?? "");

          sharedPreferences.setString("phone", resJson!["user"]["Phone"] ?? "");

          sharedPreferences.setString(
              "recharge", json.encode(resJson!["recharge"]));

          sharedPreferences.setString("AdminNumberMTN", adminNum![0]);
          sharedPreferences.setString("AdminNumberGLO", adminNum![1]);
          sharedPreferences.setString("AdminNumberAIRTEL", adminNum![2]);
          sharedPreferences.setString("AdminNumber9MOBILE", adminNum![3]);

          sharedPreferences.setString("account",
              json.encode(resJson!["user"]["bank_accounts"]["accounts"]) ?? "");

          sharedPreferences.setString("support_phone_number",
              json.encode(resJson!["webconfig"]["support_phone_number"]) ?? "");

          sharedPreferences.setString(
              "gmail", json.encode(resJson!["webconfig"]["gmail"]) ?? "");

          sharedPreferences.setString("whatsapp_group_link",
              json.encode(resJson!["webconfig"]["whatsapp_group_link"]) ?? "");

          sharedPreferences.setString(
              "address", json.encode(resJson!["webconfig"]["address"]) ?? "");

          // sharedPreferences.setString("Exam", json.encode(resJson["Exam"]));
          // sharedPreferences.setString(
          //     "topuppercentage", json.encode(resJson["topuppercentage"]));
          // sharedPreferences.setString(
          //     "percentage", json.encode(resJson["percentage"]));
          // sharedPreferences.setString(
          //     "banners", json.encode(resJson["banners"]));
          // sharedPreferences.setString("banks", json.encode(resJson["banks"]));
          // sharedPreferences.setString(
          //     "Dataplans", json.encode(resJson["Dataplans"]));
          // sharedPreferences.setString(
          //     "Cableplan", json.encode(resJson["Cableplan"]));
          // sharedPreferences.setString(
          //     "account", json.encode(resJson["user"]["bank_accounts"]));
          // sharedPreferences.setString(
          //     "support_phone_number", resJson["support_phone_number"]);

          // sharedPreferences.setString("pin", resJson["user"]["pin"]);
          // sharedPreferences.setString(
          //     "datacard_plan", json.encode(resJson["datacard_plan"]));

          // sharedPreferences.setString(
          //     "datacoupon_plan", json.encode(resJson["datacoupon_plan"]));

          // sharedPreferences.setString("password", password);
          // sharedPreferences.setString("fullname", resJson["user"]["FullName"]);
          // sharedPreferences.setString("img", resJson["user"]["img"]);
          // sharedPreferences.setString("token", responseJson['key']);
          // sharedPreferences.setString("tok", responseJson['key']);
          // sharedPreferences.setString("username", resJson["user"]["username"]);
          // sharedPreferences.setBool(
          //     "email_verify", resJson["user"]["email_verify"]);
          // sharedPreferences.setString(
          //     "user_type", resJson["user"]["user_type"]);
          // sharedPreferences.setString(
          //     "walletb", resJson["user"]["wallet_balance"]);
          // sharedPreferences.setString(
          //     "bonusb", resJson["user"]["bonus_balance"]);
          // sharedPreferences.setString("email", resJson["user"]["email"]);
          // sharedPreferences.setString(
          //     "notification", resJson["notification"]["message"]);

          // sharedPreferences.setString("phone", resJson["user"]["Phone"]);

          // sharedPreferences.setString(
          //     "recharge", json.encode(resJson["recharge"]));
          // //  sharedPreferences.setString(
          // //   "upgrade_fee", json.encode(resJson["upgrade_fee"]));

          // sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
          // sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
          // sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
          // sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);

          // setState(() {
          //   Toast.show("Welcome back ",
          //
          //       backgroundColor: Colors.green,
          //       duration: Toast.lengthLong,
          //       gravity: Toast.bottom);
          // });

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (Route<dynamic> route) => false);
          _isLoading = false;
        } else {
          setState(() {
            _isLoading = false;
          });
          Toast.show('Something went wrong, pls try again.',
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        }
      } else if (response.statusCode == 500) {
        setState(() {
          _isLoading = false;
        });

        Toast.show("something went wrong please ",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show('Unable to log in with provided credentials.',
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
      });

      Toast.show("something went wrong please $e",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
      Client().close();
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Color(0xff0340cf),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      // fit: StackFit.expand,

                      children: <Widget>[
                        // Image.asset(
                        //   "images/download.png",
                        //   alignment: Alignment.bottomCenter,
                        // ),

                        Container(
                          // padding: EdgeInsets.only(top: 20),
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight:
                                  MediaQuery.of(context).size.height * 0.1,
                            ),
                            decoration: BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage("images/userlogin.png"),
                              //   // fit: BoxFit.cover,
                              //   alignment: Alignment.bottomCenter,
                              // ),
                              // color: Color.fromARGB(255, 3, 14, 31),
                              color: Color(0xff0340cf),
                            ),
                          ),
                        ),

                        Image.asset("icons/wavebg.png"),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                  ),
                                ),

                                Text("muhallidata.com",
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                    )),

                                // Container(
                                //   child: Image.asset(
                                //     "images/download.png",
                                //     width: 800,
                                //     height: 450,
                                //   ),
                                // ),

                                // Image.asset(
                                //   "assets/whitelogo.png",
                                //   width: 300,
                                //   height: 150,
                                // ),

                                SizedBox()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Text("Sign In",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              autovalidateMode: AutovalidateMode.always,
                              controller: _usernameController,
                              onSaved: (String? val) {
                                usernameV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Username"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              obscureText: _obscureText,
                              controller: _passwordController,
                              onSaved: (String? val) {
                                passwordV = val!;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xff3A3A3A))),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed("/ResetPassword");
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 20),
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() => _isLoading = true);
                                await _loginUser(_usernameController.text,
                                    _passwordController.text);
                              }
                            },
                            child: Container(
                              height: 52,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                  color: Color(0xff0340cf),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text('Sign In',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Column(children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text('I’m a new user.',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("/signup");
                                  },
                                  child: Text('Sign Up',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff7c0000),
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(height: 100),
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
