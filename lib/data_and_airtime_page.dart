import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './screens/validator.dart';
import 'airtimereceipt.dart';
import 'bottompin.dart';
import 'componets/datapopup.dart';
import 'datareceipt.dart';

class BuyDataAndAirtime extends StatefulWidget {
  final Map? network;

  BuyDataAndAirtime({
    Key? key,
    @required this.network,
  }) : super(key: key);

  @override
  _BuyDataAndAirtimeState createState() => _BuyDataAndAirtimeState();
}

class _BuyDataAndAirtimeState extends State<BuyDataAndAirtime> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _networkController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _datatypeController = TextEditingController();
  TextEditingController _airtimetypeController = TextEditingController();
  TextEditingController _amount_to_pay_Controller = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController producttypesController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Map topuppercent;
  late String phoneV;
  late bool checkedValue = false;
  late String networkV;
  late Map<dynamic, dynamic> dataplans;
  late String plan_text;
  late String platform;
  late SharedPreferences pref;
  late SharedPreferences sharedPreferences;
  late String _planid;
  late Map networkobject;
  late List<dynamic> previousphones;

  List<Map> _datatype = [];

  List<Map> _datatype1 = [
    // {"name": "SME", "value": "SME"},
    // {"name": "SME 2", "value": "SME 2"},
    // {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    // // {"name": "MTN CG 2", "value": "MTN CG 2"},
    // {"name": "DATA COUPONS", "value": "DATA COUPONS"},
    // {"name": "GIFTING", "value": "GIFTING"}

    {"name": "SME", "value": "SME"},
    {"name": "SME 2", "value": "SME 2"},
    {"name": "DATA COUPONS", "value": "DATA COUPONS"},
    {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  List<Map> _datatype2 = [
    {"name": "SME", "value": "SME"},
    {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  List<Map> _datatype3 = [
    {"name": "SME", "value": "SME"},
    // {"name": "SME", "value": "SME"},
    {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  List<Map> _airtimetype = [
    {"name": "VTU", "value": "VTU"},
    {"name": "Share and Sell", "value": "Share and Sell"}
  ];

  List<Map> producttypes = [
    {"name": "AIRTIME", "value": "AIRTIME"},
    {"name": "DATA", "value": "DATA"}
  ];

  void initState() {
    loadplan();

    super.initState();
  }

  loadplan() async {
    producttypesController.text = "AIRTIME";
    _networkController.text = widget.network!['name'];
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Dataplans")!);
    var topuppercentjson =
        json.decode(sharedPreferences.getString("topuppercentage")!);

    if (this.mounted) {
      setState(() {
        dataplans = resJson;
        topuppercent = topuppercentjson;
      });
    }
  }

  void setValue() {
    if (_networkController.text.isNotEmpty &&
        _airtimetypeController.text.isNotEmpty &&
        _amountController.text.isNotEmpty) {
      var percent =
          topuppercent[_networkController.text][_airtimetypeController.text];

      var amount_v = int.parse(_amountController.text);

      setState(() {
        _amount_to_pay_Controller.text =
            (amount_v - amount_v * (100 - percent) ~/ 100).toString();
      });
    }
  }

  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  void updateInformation(Map dataplan) {
    setState(() {
      _planController.text = dataplan["text"];
      _planid = dataplan["value"];
    });
  }

  void moveToPlanPage(datatype) async {
    print(datatype);

    if (dataplans["${_networkController.text}_PLAN"]["ALL"]
            .where((plan) => plan["plan_type"] == datatype)
            .toList()
            .length >
        0) {
      final Map dataplan = await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => MsorgSlecetionBox(
                plan: dataplans["${_networkController.text}_PLAN"]["ALL"]
                    .where((plan) => plan["plan_type"] == datatype)
                    .toList(),
                plantype: datatype)),
      );

      updateInformation(dataplan);
    } else {
      Toast.show(
          "This data type not available for  this network for now, pls select another data type",
          backgroundColor: const Color.fromRGBO(211, 47, 47, 1),
          duration: Toast.lengthLong,
          gravity: Toast.top);
    }
  }

  Future<dynamic> _BuyDataAndAirtime(
      String phone, String plan, int network) async {
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
      String url = 'https://www.muhallidata.com/api/data/';

      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "plan": plan.toString(),
            "mobile_number": phone,
            "Ported_number": checkedValue,
            "Platform": platform,
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            Map data = json.decode(response.body);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => DataReceipt(data: data)),
                (Route<dynamic> route) => false);
          });
        }
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
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
            desc: responseJson["error"][0],
            btnCancelOnPress: () {},
            btnCancelText: "ok",
          ).show();
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Color.fromRGBO(184, 9, 146,1),duration: Toast.lengthLong,gravity:  Toast.top);
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Uexpected error occured",
            backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } finally {
      Client().close();
    }
  }

  Future<dynamic> _BuyAirtime(
      String phone, String amount, int network, String airtime_type) async {
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
      String url = 'https://www.muhallidata.com/topup/';
      print({
        "network": network,
        "amount": amount,
        "mobile_number": phone,
        "Ported_number": checkedValue,
        "Platform": platform,
        "airtime_type": airtime_type
      });
      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "network": network,
            "amount": amount,
            "mobile_number": phone,
            "Ported_number": checkedValue,
            "Platform": platform,
            "airtime_type": airtime_type
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            Map data = json.decode(response.body);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AirtimeReceipt(data: data)),
                (Route<dynamic> route) => false);
          });
        }
      } else if (response.statusCode == 500) {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        print(response.body);

        Toast.show("Unable to connect to server currently",
            backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
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
            desc: responseJson["error"][0],
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
            backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } finally {
      Client().close();
    }
  }

  void databuy() async {
    await _BuyDataAndAirtime(
      _phoneController.text,
      _planid,
      widget.network!['id'],
    );
  }

  void buyairtime() async {
    await _BuyAirtime(_phoneController.text, _amountController.text,
        widget.network!['id'], _airtimetypeController.text);
  }

  Widget _submitButtonairtime() {
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
                        "You are about to pucharse  ₦${_amountController.text} Airtime for ${_phoneController.text}",
                    onTap: buyairtime);
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
                colors: [Color(0xff0340cf), Color(0xff0340cf)])),
        child: Text(
          'Buy Airtime',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
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
                        "You are about to pucharse ${_planController.text}  for ${_phoneController.text}",
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
                colors: [Color(0xff0340cf), Color(0xff0340cf)])),
        child: Text(
          'Buy Now',
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
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.black),
        //   title: Text("${widget.network['name']}",
        //       style: TextStyle(color: Colors.black, fontSize: 17.0)),
        //   centerTitle: true,
        //   backgroundColor: Colors.white,
        //   elevation: 0.0,
        // ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: Stack(
                    children: [
                      Image.asset(
                        "${widget.network!['logo']}",
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  )),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${widget.network!['name']}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                padding: const EdgeInsets.all(15.0),
                child: producttypesController.text == "AIRTIME"
                    ? BuyAirtimeForm()
                    : buydataform(),
              )
            ],
          )),
          inAsyncCall: _isLoading,
        ));
  }

  Widget BuyAirtimeForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          TextFormField(
            validator: validateMobile,
            textAlign: TextAlign.left,
            controller: _phoneController,
            onSaved: (String? val) {
              phoneV = val!;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon

                  Icons.contacts_rounded,

                  color: Colors.grey,
                ),
                onPressed: () async {
                  Contact? contact = await _contactPicker.selectContact();
                  print("selected contact");
                  var phoneget = contact!.phoneNumbers![0]
                      .replaceAll(" ", "")
                      .replaceAll("-", "")
                      .replaceAll("(", "")
                      .replaceAll(")", "")
                      .replaceAll("+234", "0");
                  print(phoneget);
                  print(contact.phoneNumbers![0]);
                  setState(() {
                    _phoneController.text = phoneget;
                  });
                },
              ),
              labelText: "Phone",
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
            showCursor: true,
            readOnly: true,
            validator: airtimtypevalidator,
            textAlign: TextAlign.left,
            controller: producttypesController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                // Based on passwordVisible state choose the icon

                Icons.arrow_drop_down,
              ),
              labelText: "Product",
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
              showModalBottomSheet(
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                builder: (BuildContext context) {
                  ToastContext().init(context);
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              "Select Product",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: producttypes.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    producttypesController.text =
                                        producttypes[index]["name"];
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: producttypesController.text ==
                                                  producttypes[index]["name"]
                                              ? Colors.red.shade300
                                              : Colors.grey.shade300),
                                    ),
                                    child: Text(
                                      producttypes[index]["name"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 15),
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            validator: validateAmount,
            onChanged: (String value) {
              setValue();
            },
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              labelText: "Amount ",
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
            showCursor: true,
            readOnly: true,
            validator: airtimtypevalidator,
            textAlign: TextAlign.left,
            controller: _airtimetypeController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                // Based on passwordVisible state choose the icon

                Icons.arrow_drop_down,
              ),
              labelText: "Airtime Type",
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
              showModalBottomSheet(
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                builder: (BuildContext context) {
                  ToastContext().init(context);
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              "Select Airtime Type",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _airtimetype.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _airtimetypeController.text =
                                        _airtimetype[index]["name"];
                                  });

                                  setValue();
                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: _airtimetypeController.text ==
                                                  _airtimetype[index]["name"]
                                              ? Colors.red.shade300
                                              : Colors.grey.shade300),
                                    ),
                                    child: Text(
                                      _airtimetype[index]["name"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 15),
          TextFormField(
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
          ),

          // _buydatafieldsWidget(),
          SizedBox(
            height: 15,
          ),
          CheckboxListTile(
            title: Text("Bypass number validator for ported number"),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          SizedBox(
            height: 20,
          ),
          _submitButtonairtime(),

          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget buydataform() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          TextFormField(
            validator: validateMobile,
            textAlign: TextAlign.left,
            controller: _phoneController,
            onSaved: (String? val) {
              phoneV = val!;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon

                  Icons.contact_mail,

                  color: Colors.grey,
                ),
                onPressed: () async {
                  Contact? contact = await _contactPicker.selectContact();
                  print("selected contact");
                  var phoneget = contact?.phoneNumbers![0]
                      .replaceAll(" ", "")
                      .replaceAll("-", "")
                      .replaceAll("(", "")
                      .replaceAll(")", "")
                      .replaceAll("+234", "0");

                  setState(() {
                    _phoneController.text = phoneget!;
                  });
                },
              ),
              labelText: "Phone",
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
            showCursor: true,
            readOnly: true,
            validator: airtimtypevalidator,
            textAlign: TextAlign.left,
            controller: producttypesController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                // Based on passwordVisible state choose the icon

                Icons.arrow_drop_down,
              ),
              labelText: "Product",
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
              showModalBottomSheet(
                elevation: 0,
                context: context,
                backgroundColor: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                builder: (BuildContext context) {
                  ToastContext().init(context);
                  return Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    // height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Text(
                              "Select Product",
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade500,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: producttypes.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    producttypesController.text =
                                        producttypes[index]["name"];
                                  });

                                  Navigator.of(context).pop();
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      border: Border.all(
                                          color: producttypesController.text ==
                                                  producttypes[index]["name"]
                                              ? Colors.red.shade300
                                              : Colors.grey.shade300),
                                    ),
                                    child: Text(
                                      producttypes[index]["name"],
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 15),
          SizedBox(height: 15),

          TextFormField(
            showCursor: true,
            readOnly: true,
            validator: airtimtypevalidator,
            textAlign: TextAlign.left,
            controller: _datatypeController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                // Based on passwordVisible state choose the icon

                Icons.arrow_drop_down,
              ),
              labelText: "Data Type",
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
              if (_networkController.text.isNotEmpty) {
                if (widget.network!["name"] == "MTN") {
                  setState(() {
                    _datatype = _datatype1;
                  });
                } else if (widget.network!["name"] == "9MOBILE") {
                  setState(() {
                    _datatype = _datatype3;
                  });
                } else {
                  setState(() {
                    _datatype = _datatype2;
                  });
                }

                _planController.text = "";
                showModalBottomSheet(
                  elevation: 0,
                  context: context,
                  backgroundColor: Colors.transparent,
                  clipBehavior: Clip.hardEdge,
                  builder: (BuildContext context) {
                    ToastContext().init(context);
                    return Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      // height: MediaQuery.of(context).size.height,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Select Data Type",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade500,
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _datatype.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      _datatypeController.text =
                                          _datatype[index]["name"];
                                    });

                                    // setValue();
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        border: Border.all(
                                            color: _datatypeController.text ==
                                                    _datatype[index]["name"]
                                                ? Colors.red.shade300
                                                : Colors.grey.shade300),
                                      ),
                                      child: Text(
                                        _datatype[index]["name"],
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                Toast.show("Pls select network provider",
                    backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
                    duration: Toast.lengthLong,
                    gravity: Toast.top);
              }
            },
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
              if (_datatypeController.text.isEmpty) {
                Toast.show("Pls select data type",
                    backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
                    duration: Toast.lengthLong,
                    gravity: Toast.top);
              } else {
                if (_networkController.text.isNotEmpty) {
                  moveToPlanPage(_datatypeController.text);
                } else {
                  Toast.show("Pls select network provider",
                      backgroundColor: const Color.fromRGBO(48, 63, 159, 1),
                      duration: Toast.lengthLong,
                      gravity: Toast.top);
                }
              }
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.arrow_drop_down,
              ),
              labelText: "Select Plan",
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

          // _buydatafieldsWidget(),
          SizedBox(
            height: 15,
          ),
          CheckboxListTile(
            title: Text("Bypass number validator for ported number"),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
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
    );
  }
}
