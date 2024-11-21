import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late String username;
  late String email;
  late String phone;

  @override
  void initState() {
    details();
    super.initState();
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

  Future<dynamic> details() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username")!;
      email = pref.getString("email")!;
      phone = pref.getString("phone")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text('Account'),
            tiles: [
              SettingsTile(
                  title: Text('$username'), leading: Icon(Icons.verified_user)),
              SettingsTile(title: Text('$phone'), leading: Icon(Icons.phone)),
              SettingsTile(title: Text('$email'), leading: Icon(Icons.email)),
              SettingsTile(
                  title: Text('My Referals'),
                  leading: Icon(Icons.supervised_user_circle),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/referal");
                  }),
            ],
          ),
          SettingsSection(
            title: Text('Security'),
            tiles: [
              SettingsTile(
                  title: Text('Change password'),
                  leading: Icon(Icons.lock),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/changepassword");
                  }),
              SettingsTile(
                  title: Text('Pin Mangement'),
                  leading: Icon(Icons.lock),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/pin");
                  }),
              SettingsTile(
                title: Text('Sign out'),
                leading: Icon(Icons.exit_to_app),
                onPressed: (e) {
                  setlogout();
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text('About'),
            tiles: [
              SettingsTile(
                  title: Text('About muhallidata.com'),
                  leading: Icon(Icons.description),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/about");
                  }),
              SettingsTile(
                  title: Text('Contact Us'),
                  leading: Icon(Icons.contact_mail),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/contact");
                  }),
              SettingsTile(
                  title: Text('Visit Website'),
                  leading: Icon(Icons.open_in_browser),
                  onPressed: (e) {
                    Navigator.of(context).pushNamed("/website");
                  }),
            ],
          )
        ],
      ),
    );
  }
}
