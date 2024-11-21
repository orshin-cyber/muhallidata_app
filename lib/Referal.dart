import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:json_table/json_table.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class MyReferal extends StatefulWidget {
  final String? title;

  MyReferal({Key? key, this.title}) : super(key: key);

  @override
  _MyReferalState createState() => _MyReferalState();
}

class _MyReferalState extends State<MyReferal> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  List mydata = [];
  String? username;

  @override
  void initState() {
    fetchhistory();
    details();
    super.initState();
  }

  Future<dynamic> details() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString("username");
    });
  }

  static String amountformat(value) {
    return "₦$value";
  }

  var columns = [
    JsonTableColumn("username", label: "User"),
    JsonTableColumn("email", label: "email"),
    JsonTableColumn("phone", label: "phone number"),
    JsonTableColumn("date_join", label: "Date Joined"),
    JsonTableColumn("bonus", label: "Bonus Earned", valueBuilder: amountformat),
  ];

  Future fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences = await SharedPreferences.getInstance();

    try {
      final url = 'https://www.muhallidata.com/api/referal/';
      final response = await get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      }).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        if (this.mounted) {
          if (response.body.length < 5) {
            print(response.body);

            setState(() {
              mydata = [];
              _isLoading = false;
            });
          } else {
            setState(() {
              mydata = jsonDecode(response.body) as List;
              _isLoading = false;
            });
          }
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        throw Exception('Failed to load DataH from API');
      }
    } on TimeoutException catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Toast.show("Oops ,request is taking much time to response, please retry",
      //     context,
      //     backgroundColor: Colors.red,
      //     duration: Toast.LENGTH_SHORT,
      //     gravity: Toast.BOTTOM);

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

      // Toast.show("Oops ,Unexpected error occured", context,
      //     backgroundColor: Colors.red,
      //     duration: Toast.LENGTH_SHORT,
      //     gravity: Toast.BOTTOM);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Referals",
              style: TextStyle(color: Colors.white, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Color(0xff0340cf),
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                  margin:
                      EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 50),
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          "muhallidata Referal program",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Welcome to muhallidata.To enjoy our refferal program,refer friends and family to muhallidata.com and earn commission on each transaction they made",
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xff0340cf),
                          ),
                          padding: EdgeInsets.all(10),
                          height: 50,
                          // width: 500.0,
                          width: MediaQuery.of(context).size.width,

                          child: Center(
                            child: Text("click to copy Referral Link below: ",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Tooltip(
                          preferBelow: false,
                          message: "Copy",
                          child: Text(
                            " https://muhallidata.COM/signup/?referal=$username",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        onTap: () {
                          Clipboard.setData(new ClipboardData(
                              text:
                                  "https://muhallidata.COM/signup/?referal=$username"));
                          // Toast.show('Referal username copied.', context,
                          //     backgroundColor: Colors.blue,
                          //     duration: Toast.LENGTH_SHORT,
                          //     gravity: Toast.BOTTOM);

                          Toast.show("Referal username copied",
                              backgroundColor: Colors.blue,
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom);
                        },
                      ),
                    ],
                  )),
              Container(
                child: mydata.isNotEmpty
                    ? JsonTable(
                        mydata,
                        columns: columns,
                        paginationRowCount: 25,
                        showColumnToggle: true,
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          "You have not referal any user , your referals display here. ",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
              ),
            ],
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
