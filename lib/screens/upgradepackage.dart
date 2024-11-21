import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class UpgradePackage extends StatefulWidget {
  @override
  _UpgradePackageState createState() => _UpgradePackageState();
}

class _UpgradePackageState extends State<UpgradePackage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _packagetext = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var platform;
  bool _isLoading = false;

  late String username;
  late String user_type;
  late Map fee;

  @override
  void initState() {
    super.initState();
    filldetails();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    if (this.mounted) {
      setState(() {
        username = pref.getString("username")!;
        user_type = pref.getString("user_type")!;
        fee = json.decode(pref.getString("upgrade_fee")!);
      });
    }
  }

  Future<dynamic> _upgradeSend(String package) async {
    try {
      setState(() {
        _isLoading = true;
      });
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String url = 'https://www.muhallidata.com/api/upgrade/?package=$package';
      print(url);
      Response response = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        },
      );

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);
        print(responseJson["message"]);
        sharedPreferences.setString("user_type", package);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        Toast.show(responseJson["message"],
            backgroundColor: Colors.green,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
        Navigator.of(context).pushReplacementNamed("/home");
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        var responseJson = json.decode(response.body);
        Toast.show(responseJson["message"],
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("unexpected error occured",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
      }
    } finally {
      Client().close();
    }
  }

  void senddata() async {
    await _upgradeSend('dgdg');
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    var phonesize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Upgrade package",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Icon(
            Icons.info_outlined,
            size: 30,
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            ModalProgressHUD(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                          child: Text(
                        "CURRENT PACKAGE : $user_type",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      user_type != "TopUser"
                          ? TextFormField(
                              showCursor: true,
                              readOnly: true,
                              // validator: airtimtypevalidator,
                              textAlign: TextAlign.left,
                              controller: _packagetext,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  // Based on passwordVisible state choose the icon

                                  Icons.arrow_drop_down,
                                ),
                                labelText: "Package",
                                hintStyle: TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    width: 0.1,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.all(25),
                                fillColor: Colors.white,
                              ),
                              onTap: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20.0),
                                                topRight:
                                                    Radius.circular(20.0))),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Select Package",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Icon(
                                                        Icons.cancel_sharp,
                                                        color: Colors.red,
                                                      ))
                                                ]),
                                            SizedBox(
                                                height:
                                                    phonesize.height * 0.04),
                                            user_type == "Smart Earner"
                                                ? upgrade(
                                                    "UPGRADE TO AFFILLIATE ₦${fee['affiliate_upgrade_fee']}",
                                                    Colors.blue,
                                                    "Affilliate",
                                                    fee['affiliate_upgrade_fee'])
                                                : SizedBox(),
                                            user_type == "Smart Earner"
                                                ? upgrade(
                                                    "UPGRADE TO TOPUSER ₦${fee['topuser_upgrade_fee']}",
                                                    Colors.red,
                                                    "TopUser",
                                                    fee['topuser_upgrade_fee'])
                                                : SizedBox(),
                                            user_type == "Affilliate"
                                                ? upgrade(
                                                    "UPGRADE TO TOPUSER ₦${fee['affiliate_to_topuser_upgrade_fee']}",
                                                    Colors.red,
                                                    "TopUser",
                                                    fee['affiliate_to_topuser_upgrade_fee'])
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            )
                          : SizedBox(),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
              inAsyncCall: _isLoading,
            ),
          ],
        ),
      )),
    );
  }

  Future<void> _showUPGRADEdialog(package, price) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dear $username'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'kindly note that you will be charge ₦$price to upgrade to $package Package Yes to continue  Cancel to go back')
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('No Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Yes Submit'),
              onPressed: () async {
                _upgradeSend(package);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget upgrade(text, color, action, price) {
    return InkWell(
      onTap: () async {
        Navigator.of(context).pop();
        _showUPGRADEdialog(action, price);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: color,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
          ),
          child: Text(
            '$text',
            style: TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
