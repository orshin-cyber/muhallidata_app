import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Complain extends StatefulWidget {
  @override
  _ComplainState createState() => _ComplainState();
}

class _ComplainState extends State<Complain> {
  String? support_phone_number;

  @override
  void initState() {
    filldetails();
    _launchURL();
    super.initState();
  }

  _launchURL() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString("username");
    var url =
        'https://api.whatsapp.com/send/?phone=+$support_phone_number&text=Hello+I+have+a+complaint.+My+username+is+$username&app_absent=0';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Center(
          child: ElevatedButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil("/home", (route) => false);
        },
        child: Text("Dashboard"),
      )),
    );
  }

  Future<dynamic> filldetails() async {
    // producttypesController.text = "DATA";
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        support_phone_number = pref.getString("support_phone_number") ?? '';
      });
    }
  }
}
