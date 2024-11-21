import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:local_auth/local_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:muhallidata/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class WelcomeP extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WelcomePState();
  }
}

class _WelcomePState extends State<WelcomeP> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _passwordController = TextEditingController();

  final LocalAuthentication auth = LocalAuthentication();

  bool _canCheckBiometrics = false;
  //List<BiometricType> _availableBiometrics;
  late String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  late String mykey;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String usernameV;
  late String passwordV;
  String image = "images/profile.jpeg";
  String fname = "";
  bool _obscureText = true;

  @override
  void initState() {
    _checkBiometrics();
    super.initState();
    // _authenticate();
    filldetails();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        usernameV = pref.getString("username")!;
        passwordV = pref.getString("password")!;
        fname = pref.getString("username")!;
      });
    }
  }

  setlogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully",
        backgroundColor: const Color.fromRGBO(67, 160, 71, 1),
        duration: Toast.lengthLong,
        gravity: Toast.top);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  // Toggles the password show status

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
      setState(() {
        _canCheckBiometrics = canCheckBiometrics;
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to access muhallidata',
      );

      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {}
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    if (authenticated == true) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      mykey = sharedPreferences.getString("tok")!;

      setState(() {
        sharedPreferences.setString("token", mykey);
      });
      _loginUser(usernameV, passwordV);
    }

    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
  }

  Future<dynamic> _loginUser(String username, String password) async {
    try {
      String url = 'https://muhallidata.com/rest-auth/login/';

      Response response = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"username": username, "password": password}));

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _isLoading = false;
        });
        Toast.show("Welcome back ",
            backgroundColor: Colors.green,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
      } else if (response.statusCode == 500) {
        setState(() {
          _isLoading = false;
        });

        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
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
    } finally {
      Client().close();
    }
  }

  String? bio_icon() {
    if (Platform.isAndroid) {
      return "assets/android.png";
    } else if (Platform.isIOS) {
      return "assets/ios.png";
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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xff0340cf),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.only(top: 20),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                          ),
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: AssetImage("images/userlogin.png"),
                          //     // fit: BoxFit.cover,
                          //     alignment: Alignment.bottomCenter,
                          //   ),
                          //   // color: Color.fromARGB(255, 3, 14, 31),
                          //   color: Color(0xff0340cf),
                          // ),
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
                                  setlogout();
                                  // Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),

                              // Text("muhallidata.com",
                              //     style: GoogleFonts.poppins(
                              //       textStyle: TextStyle(
                              //           fontSize: 25,
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w700),
                              //     )),

                              // Image.asset(
                              //   "assets/whitelogo.png",
                              //   width: 300,
                              //   height: 150,
                              // ),

                              // Container(
                              //   child: Image.asset("images/download.png"),
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
                        Column(children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage(image), fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text("Welcome Back",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black))),
                          fname != null
                              ? Text("$fname",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black))
                              : Text("$usernameV",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black))
                        ]),
                        SizedBox(height: 20),
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
                              labelText: "Enter Your Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black,
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
                          onTap: () async {
                            if (_passwordController.text.length > 3) {
                              _formKey.currentState!.save();
                              setState(() => _isLoading = true);
                              await _loginUser(
                                  usernameV, _passwordController.text);
                            }
                          },
                          child: Container(
                            height: 56,
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
                        InkWell(
                          onTap: () {
                            if (_canCheckBiometrics == true) {
                              _isAuthenticating
                                  ? _cancelAuthentication()
                                  : _authenticate();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            height: 42,
                            width: 42,
                            child: Image.asset(
                              bio_icon()!,
                              height: 30,
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xff0340cf),
                                borderRadius: BorderRadius.circular(5)),
                          ),
                        ),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        setlogout();
                                      },
                                      child: Text('Sign out',
                                          style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff000000),
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 100),
                              ]),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );

    // @override
    // Widget build(BuildContext context) {
    //   var ponesize = MediaQuery.of(context).size;
    //   return Scaffold(
    //     key: _scaffoldKey,
    //     resizeToAvoidBottomInset: false,
    //     body: ModalProgressHUD(
    //       child: SingleChildScrollView(
    //         child: Container(
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                   padding: EdgeInsets.fromLTRB(
    //                       ponesize.width * 0.01,
    //                       ponesize.height * 0.05,
    //                       ponesize.width * 0.01,
    //                       ponesize.height * 0.01),
    //                   height: MediaQuery.of(context).size.height / 2.5,
    //                   width: MediaQuery.of(context).size.width,
    //                   color: Colors.blue[700],
    //                   child: Column(children: [
    //                     SizedBox(height: ponesize.height * 0.1),
    //                     Container(
    //                       width: 100,
    //                       height: 100,
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         image: DecorationImage(
    //                             image: AssetImage(image), fit: BoxFit.fill),
    //                       ),
    //                     ),
    //                     SizedBox(height: 10),
    //                     Text("Welcome Back",
    //                         style: TextStyle(
    //                             fontSize: 30,
    //                             fontWeight: FontWeight.w900,
    //                             color: Colors.white)),
    //                     fname != null
    //                         ? Text("$fname",
    //                             style: TextStyle(
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: Colors.white))
    //                         : Text("$usernameV",
    //                             style: TextStyle(
    //                                 fontSize: 18,
    //                                 fontWeight: FontWeight.w500,
    //                                 color: Colors.white))
    //                   ])),
    //               Container(
    //                 width: MediaQuery.of(context).size.width,
    //                 padding: EdgeInsets.only(top: 62),
    //                 child: Form(
    //                   key: _formKey,
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                         width: MediaQuery.of(context).size.width / 1.2,
    //                         height: 60,
    //                         margin: EdgeInsets.only(top: 32),
    //                         padding: EdgeInsets.only(
    //                             top: 4, left: 16, right: 16, bottom: 4),
    //                         decoration: BoxDecoration(
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(10)),
    //                             color: Colors.white,
    //                             boxShadow: [
    //                               BoxShadow(color: Colors.black12, blurRadius: 5)
    //                             ]),
    //                         child: TextFormField(
    //                           obscureText: _obscureText,
    //                           controller: _passwordController,
    //                           onSaved: (String val) {
    //                             passwordV = val;
    //                           },
    //                           decoration: InputDecoration(
    //                             border: InputBorder.none,
    //                             icon: Icon(
    //                               Icons.vpn_key,
    //                               color: Colors.grey,
    //                             ),
    //                             hintText: 'Password',
    //                             suffixIcon: IconButton(
    //                               icon: Icon(
    //                                 // Based on passwordVisible state choose the icon

    //                                 _obscureText
    //                                     ? Icons.visibility_off
    //                                     : Icons.visibility,

    //                                 color: Colors.grey,
    //                               ),
    //                               onPressed: () {
    //                                 // Update the state i.e. toogle the state of passwordVisible variable
    //                                 setState(() {
    //                                   _obscureText = !_obscureText;
    //                                 });
    //                               },
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),
    //                       InkWell(
    //                         onTap: () {
    //                           if (_canCheckBiometrics == true) {
    //                             _isAuthenticating
    //                                 ? _cancelAuthentication()
    //                                 : _authenticate();
    //                           }
    //                         },
    //                         child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               Image.asset(
    //                                 bio_icon(),
    //                                 height: 30,
    //                               ),
    //                               SizedBox(width: 8),
    //                               Text(bio_text(),
    //                                   style: TextStyle(
    //                                       fontWeight: FontWeight.w600,
    //                                       fontSize: 19))
    //                             ]),
    //                       ),
    //                       SizedBox(height: 15),
    //                       InkWell(
    //                         onTap: () async {
    //                           if (_formKey.currentState!.validate()) {
    //                             _formKey.currentState!.save();
    //                             setState(() => _isLoading = true);
    //                             await _loginUser(
    //                                 usernameV, _passwordController.text);
    //                           }
    //                         },
    //                         child: Container(
    //                           height: 60,
    //                           width: MediaQuery.of(context).size.width / 1.2,
    //                           decoration: BoxDecoration(
    //                               color: Colors.blue[700],
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(10))),
    //                           child: Center(
    //                             child: Text(
    //                               'Sign in'.toUpperCase(),
    //                               style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(height: 10),
    //                       InkWell(
    //                         onTap: () {
    //                           Navigator.of(context).pushNamed("/ResetPassword");
    //                         },
    //                         child: Align(
    //                           alignment: Alignment.center,
    //                           child: Padding(
    //                             padding:
    //                                 const EdgeInsets.only(top: 16, right: 32),
    //                             child: Text(
    //                               'Forgot your Password or this is not?',
    //                               style: TextStyle(color: Colors.grey[700]),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(height: 15),
    //                       Column(children: <Widget>[
    //                         // Row(
    //                         //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                         //   children: <Widget>[
    //                         //     Text(
    //                         //       'or login with',
    //                         //       style: TextStyle(
    //                         //           color: Colors.grey[800],
    //                         //           fontWeight: FontWeight.w400),
    //                         //     ),
    //                         //     InkWell(
    //                         //         onTap: () {
    //                         //           if (_canCheckBiometrics == true) {
    //                         //             _isAuthenticating
    //                         //                 ? _cancelAuthentication()
    //                         //                 : _authenticate();
    //                         //           }
    //                         //         },
    //                         //         child: Icon(
    //                         //           bio_icon(),
    //                         //           size: 50.0,
    //                         //         )),
    //                         //   ],
    //                         // ),

    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             InkWell(
    //                               onTap: () {
    //                                 setlogout();
    //                               },
    //                               child: Text(
    //                                 'Signout',
    //                                 style: TextStyle(
    //                                   color: Colors.blue,
    //                                   fontWeight: FontWeight.bold,
    //                                 ),
    //                               ),
    //                             )
    //                           ],
    //                         ),

    //                         SizedBox(height: 100),
    //                       ]),
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       inAsyncCall: _isLoading,
    //     ),
    //   );
  }
}
