import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BankManualPayment extends StatefulWidget {
  final String? title;

  BankManualPayment({Key? key, this.title}) : super(key: key);

  @override
  _BankManualPaymentState createState() => _BankManualPaymentState();
}

class _BankManualPaymentState extends State<BankManualPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  List<dynamic> account = [];
  String bank = "";
  List<dynamic> banks = [];
  String username = "";
  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      account = json.decode(pref.getString("account")!);
      bank = pref.getString("bank")!;
      banks = json.decode(pref.getString("banks")!);
      username = pref.getString("username")!;
    });

    print(banks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Manual Bank Payment",
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: Color(0xff0340cf),
                                ),
                                child: Center(
                                    child: Text(
                                  "MANUAL BANK FUNDING\n\You can deposit or transfer fund into our account stated below. Use your registered username as depositor's name, naration or remarks Your account will be funded as soon as your payment is confirmed.",
                                  style: TextStyle(color: Colors.white),
                                )),
                              ),
                              SizedBox(height: 20),
                              banks.isEmpty
                                  ? Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          'No Manual Banks Added',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 5,
                                    ),
                              banks.length >= 1
                                  ? Text(
                                      "PLEASE NOTE THAT MINIMUM WALLET FUNDING VIA MANUAL BANK TRANSFER/DEPOSIT IS 3000#.",
                                      style: TextStyle(
                                          color: Color(0xffC90000),
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : SizedBox(),
                              SizedBox(height: 10),
                              banks.length >= 1
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushNamed("/banknotice");
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
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
                                                  Color.fromRGBO(
                                                      17, 35, 210, 1),
                                                  Color(0xffC90000)
                                                ])),
                                        child: Text(
                                          'Send payment Notification',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              SizedBox(height: 10),
                              banks.length >= 1
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: ListView.builder(
                                          padding: const EdgeInsets.all(8),
                                          itemCount: banks.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Card(
                                              child: Column(children: [
                                                SizedBox(height: 5),
                                                Text(
                                                  "Bank Name : ${banks[index]['bank_name']}",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          17, 35, 210, 1),
                                                      fontSize: 17.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "Name: ${banks[index]['account_name']}",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          17, 35, 210, 1),
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Account Number: ${banks[index]['account_number']}",
                                                  style: TextStyle(
                                                      color: Color.fromRGBO(
                                                          17, 35, 210, 1),
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]),
                                            );
                                          }),
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
