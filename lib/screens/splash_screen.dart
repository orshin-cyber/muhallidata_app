// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:toast/toast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart';
// import 'dart:convert';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// late String mykey;

// //import "home_screen.dart";
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   void initState() {
//     alert();

//     super.initState();
//     Timer(Duration(seconds: 7), () async {
//       SharedPreferences sharedPreferences =
//           await SharedPreferences.getInstance();

//       if (sharedPreferences.getString("token") != null) {
//         loaddata();
//         Navigator.of(context).pushReplacementNamed("/welcome");
//       } else {
//         Navigator.of(context).pushReplacementNamed("/landingpage");
//       }
//     });
//   }

//   Future<dynamic> loaddata() async {
//     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//     mykey = sharedPreferences.getString("tok")!;

//     if (mykey != null) {
//       String url = 'https://www.muhallidata.com/api/user/';

//       Response res = await get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           'Authorization': 'Token $mykey'
//         },
//       );

//       if (res.statusCode == 200 || res.statusCode == 201) {
//         Map resJson = json.decode(res.body);

//         List adminNum =
//             resJson["Admin_number"].map((net) => net["phone_number"]).toList();

//         sharedPreferences.setString("banks", json.encode(resJson["banks"]));
//         sharedPreferences.setString("banners", json.encode(resJson["banners"]));
//         sharedPreferences.setString("Exam", json.encode(resJson["Exam"]));
//         sharedPreferences.setString(
//             "percentage", json.encode(resJson["percentage"]));
//         sharedPreferences.setString(
//             "topuppercentage", json.encode(resJson["topuppercentage"]));
//         sharedPreferences.setString(
//             "Dataplans", json.encode(resJson["Dataplans"]));
//         sharedPreferences.setString(
//             "Cableplan", json.encode(resJson["Cableplan"]));
//         sharedPreferences.setString(
//             "account", json.encode(resJson["user"]["bank_accounts"]));
//         sharedPreferences.setString(
//             "support_phone_number", resJson["support_phone_number"]);

//         sharedPreferences.setString(
//             "recharge", json.encode(resJson["recharge"]));
//         sharedPreferences.setString(
//             "upgrade_fee", json.encode(resJson["upgrade_fee"]));
//         sharedPreferences.setString("pin", resJson["user"]["pin"]);
//         sharedPreferences.setString("username", resJson["user"]["username"]);
//         sharedPreferences.setString(
//             "walletb", resJson["user"]["wallet_balance"]);
//         sharedPreferences.setString("bonusb", resJson["user"]["bonus_balance"]);
//         sharedPreferences.setString("email", resJson["user"]["email"]);
//         sharedPreferences.setString(
//             "notification", resJson["notification"]["message"]);
//         sharedPreferences.setString("img", resJson["user"]["img"]);

//         sharedPreferences.setString("user_type", resJson["user"]["user_type"]);
//         sharedPreferences.setString("phone", resJson["user"]["Phone"]);
//         sharedPreferences.setBool(
//             "email_verify", resJson["user"]["email_verify"]);

//         sharedPreferences.setString(
//             "datacard_plan", json.encode(resJson["datacard_plan"]));

//         sharedPreferences.setString(
//             "datacoupon_plan", json.encode(resJson["datacoupon_plan"]));

//         sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
//         sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
//         sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
//         sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);
//       } else {
//         setState(() {});
//         Toast.show('Something went wrong, pls try again.',
//             backgroundColor: Colors.red,
//             duration: Toast.lengthLong,
//             gravity: Toast.top);
//       }
//     }
//   }

//   Future<dynamic> alert() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();

//     String url = 'https://www.muhallidata.com/alert/';

//     Response res = await get(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//       },
//     );

//     Map resJson = json.decode(res.body);

//     if (this.mounted) {
//       setState(() {
//         pref.setString("alert", resJson["alert"]);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     ToastContext().init(context);
//     return Scaffold(
//       backgroundColor: Color(0xff0340cf),
//       body: Stack(fit: StackFit.expand, children: <Widget>[
//         Image.asset(
//           'images/bg22.png',
//           fit: BoxFit.cover,
//           color: Color(0xff0d69ff).withOpacity(1.0),
//           colorBlendMode: BlendMode.softLight,
//         ),
//         DecoratedBox(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: FractionalOffset.topCenter,
//               end: FractionalOffset.bottomCenter,
//               colors: [
//                 Color(0xff262161).withOpacity(0.4),
//                 Color.fromARGB(255, 235, 103, 125),
//               ],
//             ),
//           ),
//         ),
//         Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SpinKitFadingCircle(
//                 color: Colors.white,
//                 size: 60.0,
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Image.asset(
//                 "assets/logo.png",
//                 width: 300,
//                 height: 120,
//               ),
//               Padding(padding: EdgeInsets.only(bottom: 50.0)),
//             ],
//           )
//         ])
//       ]),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

String? mykey;

//import "home_screen.dart";
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  bool _isLoading = false;
  void initState() {
    alert();

    super.initState();
    Timer(Duration(seconds: 7), () async {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      // if (sharedPreferences.getBool("first_login") == null) {
      //   setState(() {
      //     sharedPreferences.setBool("first_login", true);
      //   });

      //   Navigator.of(context).pushReplacementNamed("/onboard");
      if (sharedPreferences.getString("token") != null) {
        loaddata();
        Navigator.of(context).pushReplacementNamed("/welcome");
      } else {
        Navigator.of(context).pushReplacementNamed("/landingpage");
      }
    });
  }

  Future<dynamic> loaddata() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    mykey = sharedPreferences.getString("tok");

    if (mykey != null) {
      String url = 'https://www.muhallidata.com/api/user/';

      Response res = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token $mykey'
        },
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        Map resJson = json.decode(res.body);

        List adminNum =
            resJson["Admin_number"].map((net) => net["phone_number"]).toList();

        sharedPreferences.setString("banks", json.encode(resJson["banks"]));
        // sharedPreferences.setString("banners", json.encode(resJson["banners"]));
        sharedPreferences.setString("banners", json.encode(resJson["banners"]));
        sharedPreferences.setString("Exam", json.encode(resJson["Exam"]));
        sharedPreferences.setString(
            "percentage", json.encode(resJson["percentage"]));
        sharedPreferences.setString(
            "topuppercentage", json.encode(resJson["topuppercentage"]));
        sharedPreferences.setString(
            "Dataplans", json.encode(resJson["Dataplans"]));
        sharedPreferences.setString(
            "Cableplan", json.encode(resJson["Cableplan"]));
        sharedPreferences.setString("account",
            json.encode(resJson["user"]["bank_accounts"]["accounts"]));
        sharedPreferences.setString(
            "support_phone_number", resJson["support_phone_number"]);

        sharedPreferences.setString(
            "recharge", json.encode(resJson["recharge"]));
        sharedPreferences.setString(
            "upgrade_fee", json.encode(resJson["upgrade_fee"]));
        sharedPreferences.setString("pin", resJson["user"]["pin"] ?? '');
        sharedPreferences.setString("username", resJson["user"]["username"]);
        sharedPreferences.setString(
            "walletb", resJson["user"]["wallet_balance"]);
        sharedPreferences.setString("bonusb", resJson["user"]["bonus_balance"]);
        sharedPreferences.setString("email", resJson["user"]["email"]);
        sharedPreferences.setString(
            "notification", resJson["notification"]["message"]);
        sharedPreferences.setString("img", resJson["user"]["img"]);

        sharedPreferences.setString("user_type", resJson["user"]["user_type"]);
        sharedPreferences.setString("phone", resJson["user"]["Phone"]);
        sharedPreferences.setBool(
            "email_verify", resJson["user"]["email_verify"]);

        sharedPreferences.setString(
            "datacard_plan", json.encode(resJson["datacard_plan"]));

        sharedPreferences.setString("AdminNumberMTN", adminNum[0]);
        sharedPreferences.setString("AdminNumberGLO", adminNum[1]);
        sharedPreferences.setString("AdminNumberAIRTEL", adminNum[2]);
        sharedPreferences.setString("AdminNumber9MOBILE", adminNum[3]);
      } else {
        setState(() {
          _isLoading = false;
        });
        Toast.show('Something went wrong, pls try again.',
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    }
  }

  Future<dynamic> alert() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.muhallidata.com/api/alert/';

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
    );

    Map resJson = json.decode(res.body);

    if (this.mounted) {
      setState(() {
        pref.setString("alert", resJson["alert"]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      body: Stack(fit: StackFit.expand, children: <Widget>[
        // Image.asset(
        //   '',
        //   fit: BoxFit.cover,
        //   color: Color(0xffffffff).withOpacity(1.0),
        //   colorBlendMode: BlendMode.softLight,
        // ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
                Color.fromARGB(255, 255, 255, 255),
              ],
            ),
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitThreeInOut(
                color: Color(0xff0340cf),
                size: 70.0,
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/logo.png",
                width: 300,
                height: 200,
              ),
              Padding(padding: EdgeInsets.only(bottom: 50.0)),
            ],
          )
        ])
      ]),
    );
  }
}
