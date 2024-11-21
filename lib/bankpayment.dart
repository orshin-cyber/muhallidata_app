import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class BankPagePayment extends StatefulWidget {
  final String? title;

  BankPagePayment({Key? key, this.title}) : super(key: key);

  @override
  _BankPagePaymentState createState() => _BankPagePaymentState();
}

class _BankPagePaymentState extends State<BankPagePayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<dynamic> account = [];
  late String bank;
  late String username = "";
  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    account = json.decode(pref.getString("account")!);
    // bank = pref.getString("bank")!;
    username = pref.getString("username")!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Virtual Account",
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
                        Container(
                            margin: EdgeInsets.fromLTRB(10.0, 20, 10.0, 0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Color(0xff0340cf),
                            ),
                            child: Center(
                                child: Text(
                              "AUTOMATED BANK FUNDING \n\nPay into the account below your wallet will be funded automatically",
                              style: TextStyle(color: Colors.white),
                            ))),
                        SizedBox(height: 10),
                        account.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    'No Virtual Account Generated',
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
                        Container(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: account.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.all(5),
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff0340cf)),
                                    child: Stack(
                                      children: <Widget>[
                                        Positioned(
                                          left: 29,
                                          bottom: 120,
                                          child: Text(
                                            'ACCOUNT NUMBER',
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 29,
                                          bottom: 80,
                                          child: Text(
                                            "${account[index]["accountNumber"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 170,
                                          bottom: 82,
                                          child: GestureDetector(
                                            child: Tooltip(
                                              preferBelow: false,
                                              message: "Copy",
                                              child: Icon(
                                                Icons.copy_sharp,
                                                color: Colors.white,
                                                size: 14,
                                              ),
                                            ),
                                            onTap: () {
                                              Clipboard.setData(new ClipboardData(
                                                  text:
                                                      "${account[index]["accountNumber"]}"));
                                              Toast.show(
                                                  'Account number copied.',
                                                  backgroundColor: Colors.green,
                                                  duration: Toast.lengthLong,
                                                  gravity: Toast.bottom);
                                            },
                                          ),
                                        ),
                                        Positioned(
                                          left: 29,
                                          bottom: 50,
                                          child: Text(
                                            'ACCOUNT NAME',
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 29,
                                          bottom: 20,
                                          child: Text(
                                            "$username",
                                            style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 220,
                                          bottom: 50,
                                          child: Text(
                                            '${account[index]["bankName"] == "9Payment Service Bank" ? "₦35 charge" : "N50 charge"}',
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ),
                                        Positioned(
                                          left: 220,
                                          bottom: 20,
                                          child: Text(
                                            "${account[index]["bankName"]}",
                                            style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })),
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
