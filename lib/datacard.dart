import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './screens/validator.dart';
import 'bottompin.dart';
import 'componets/datacardlist.dart';
import 'datacard_receipt.dart';

class DataRechargeCard extends StatefulWidget {
  final String? title;
  final String? image;
  final int? id;
  final List<dynamic>? plan;

  DataRechargeCard({Key? key, this.title, this.image, this.id, this.plan})
      : super(key: key);

  @override
  _DataRechargeCardState createState() => _DataRechargeCardState();
}

class _DataRechargeCardState extends State<DataRechargeCard> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _planController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String planV;
  late String platform;
  late List<dynamic> plans;
  late Map networkobject;
  late String _planid;
  late int amount_to_pay;
  late SharedPreferences sharedPreferences;

  void initState() {
    loadplan();
    _quantityController.text = '1';
    super.initState();
  }

  void setValue() {
    if (_planController.text.isNotEmpty &&
        _quantityController.text.isNotEmpty) {
      setState(() {
        _amount_to_pay_Controller.text =
            (amount_to_pay * int.parse(_quantityController.text)).toString();
      });
    }
  }

  void updateInformation(Map dataplan) {
    //print(dataplan);
    setState(() {
      _planController.text = dataplan["text"];
      _planid = dataplan["value"].toString();
      amount_to_pay = dataplan["amount_to_pay"];
    });
  }

  void moveToPlanPage() async {
    final Map dataplan = await Navigator.push(
      context,
      CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (context) => DataRechargeCardSlecetionBox(plan: plans)),
    );

    updateInformation(dataplan);
    setValue();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var resJson = json.decode(sharedPreferences.getString("datacard_plan")!);

    setState(() {
      plans = resJson;
    });

    //print(plans);
  }

  Future<dynamic> _DataRechargeCard(
      String name, String plan, String quantity) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });

    if (Platform.isAndroid) {
      setState(() {
        platform = "Android APP";
      });
    } else if (Platform.isIOS) {
      setState(() {
        platform = "IOS APP";
      });
    }
    try {
      String url = 'https://www.muhallidata.com/api/data-card/';
      // //print(jsonEncode({

      //   "plan": plan,
      //   "quantity": quantity,
      //    "name_on_card": name
      // }));
      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode(
              {"plan": plan, "quantity": quantity, "name_on_card": name}));

      //print(response.body);
      //print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        //print(response.body);
        setState(() {
          _isLoading = false;

          Map data = json.decode(response.body);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      DataRechargeCardReceipt(data: data)),
              (Route<dynamic> route) => false);
        });
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        //print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(56, 142, 60, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else if (response.statusCode == 400) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Color.fromRGBO(184, 9, 146,1),duration: Toast.lengthLong, duration: Toast.lengthLong, gravity:  Toast.top);
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(56, 142, 60, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } finally {
      Client().close();
    }
  }

  void databuy() async {
    await _DataRechargeCard(
        _nameController.text, _planid, _quantityController.text);
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                ToastContext().init(context);
                return Bottom_pin(
                    title:
                        "You are about to generate ${_quantityController.text} piece of Data recharge card ${_planController.text} ",
                    onTap: databuy);
              });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  const Color.fromRGBO(25, 118, 210, 1),
                  const Color.fromRGBO(25, 118, 210, 1)
                ])),
        child: Text(
          'Buy Data Card Pin',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Buy Data Card Pins",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
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
                  SizedBox(height: 15),
                  TextFormField(
                    validator: planvalidator,
                    enableInteractiveSelection: false,
                    showCursor: false,
                    readOnly: true,
                    textAlign: TextAlign.left,
                    controller: _planController,
                    onTap: () async {
                      moveToPlanPage();
                    },
                    // onSaved: (String val) {
                    //   phoneV = val;
                    // },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Select Amount",
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
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    validator: quantityvalid2,
                    onChanged: (String value) {
                      setValue();
                    },
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Quantity ",
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
                  ),
                  _amount_to_pay_Controller.text.isNotEmpty
                      ? SizedBox(height: 15)
                      : SizedBox(),
                  _amount_to_pay_Controller.text.isNotEmpty
                      ? TextFormField(
                          showCursor: true,
                          readOnly: true,
                          controller: _amount_to_pay_Controller,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: "Amount to Pay",
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
                        )
                      : SizedBox(),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    validator: validatename,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      labelText: "Name on Card",
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
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _submitButton(),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
