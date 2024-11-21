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
import 'bottompin.dart';
import 'componets/datapopup.dart';
import 'datareceipt.dart';

class BuyData extends StatefulWidget {
  final String? title;
  final String? image;
  final int? id;
  final Map<dynamic, dynamic>? plan;

  BuyData({Key? key, this.title, this.image, this.id, this.plan})
      : super(key: key);

  @override
  _BuyDataState createState() => _BuyDataState();
}

class _BuyDataState extends State<BuyData> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _networkController = TextEditingController();
  TextEditingController _planController = TextEditingController();
  TextEditingController _datatypeController = TextEditingController();
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late int dropdownValue;
  late String phoneV;
  late bool checkedValue = false;
  late String networkV;
  late Map<dynamic, dynamic> dataplans;
  late String plan_text;
  late String platform;
  late SharedPreferences pref;
  late SharedPreferences sharedPreferences;
  late int _network;
  late String _planid;
  late Map networkobject;
  late List<dynamic> previousphones;

  List<Map> _networklist = [
    {
      "name": "MTN",
      "logo": "assets/mtn.jpg",
      "id": 1,
    },
    {
      "name": "GLO",
      "logo": "assets/glo.jpg",
      "id": 2,
    },
    {
      "name": "AIRTEL",
      "logo": "assets/airtel.jpg",
      "id": 4,
    },
    {
      "name": "9MOBILE",
      "logo": "assets/9mobile.jpg",
      "id": 3,
    }
  ];

  List<Map> _datatype = [];

  List<Map> _datatype1 = [
    {"name": "SME", "value": "SME"},
    {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    {"name": "MTN CG 2", "value": "MTN CG 2"},
    {"name": "DATA COUPONS", "value": "DATA COUPONS"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  List<Map> _datatype2 = [
    {"name": "CORPORATE GIFTING", "value": "CORPORATE GIFTING"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  List<Map> _datatype3 = [
    {"name": "SME", "value": "SME"},
    {"name": "GIFTING", "value": "GIFTING"}
  ];

  void initState() {
    loadplan();
    getpreviousphones();
    super.initState();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();
    Map resJson = json.decode(sharedPreferences.getString("Dataplans")!);

    if (this.mounted) {
      setState(() {
        dataplans = resJson;
      });
    }
  }

  setpreviousphones(previousphone) {
    print(previousphone);
    setState(() {
      networkobject = previousphone;
      _networkController.text = previousphone["name"];
      _network = previousphone["id"];
      _phoneController.text = previousphone["phone"];
    });
  }

  getpreviousphones() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("storedphone") != null) {
      var storedphone =
          json.decode(sharedPreferences.getString("storedphone")!);
      print(storedphone);

      setState(() {
        previousphones = storedphone;
      });
    }
  }

  savecontact() async {
    sharedPreferences = await SharedPreferences.getInstance();
    networkobject["phone"] = _phoneController.text;
    var net = networkobject;
    print(net);

    if (sharedPreferences.getString("storedphone") != null) {
      var storedphone =
          json.decode(sharedPreferences.getString("storedphone")!);

      var existingList = storedphone
          .takeWhile((i) => i["phone"] != _phoneController.text)
          .toList();

      if (existingList.length >= 5) {
        var lastfour =
            existingList.getRange(existingList.length - 4, existingList.length);
        var netlist = [...lastfour, net];
        sharedPreferences.setString("storedphone", json.encode(netlist));
      } else {
        var netlist = [...existingList, net];
        sharedPreferences.setString("storedphone", json.encode(netlist));
      }
    } else {
      var netlist = [];
      netlist.add(net);
      print(netlist);
      sharedPreferences.setString("storedphone", json.encode(netlist));
    }

    getpreviousphones();
  }

  final FlutterContactPicker _contactPicker = new FlutterContactPicker();

  void updateInformation(Map dataplan) {
    print(dataplan);
    setState(() {
      if (dataplans != null) {
        _planController.text = dataplan["text"];
        _planid = dataplan["value"];
      }
    });
  }

  void moveToPlanPage(datatype) async {
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

  Future<dynamic> _buyData(String phone, String plan, int network) async {
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
        savecontact();

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
            backgroundColor: Color.fromRGBO(194, 24, 24, 1),
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
            backgroundColor: Color.fromRGBO(194, 24, 24, 1),
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } finally {
      Client().close();
    }
  }

  void databuy() async {
    await _buyData(
      _phoneController.text,
      _planid,
      _network,
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
                colors: [Color(0xFFC21818), Color.fromRGBO(194, 24, 24, 1)])),
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Data Bundle",
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
                  previousphones != null
                      ? Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.timelapse,
                                    color: Colors.pink[700],
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Recent Beneficiary",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                            Container(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: previousphones.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {
                                          setpreviousphones(
                                              previousphones[index]);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: previousphones[
                                                            index]['name'] ==
                                                        "MTN"
                                                    ? Colors.pink.shade100
                                                    : previousphones[index]
                                                                ['name'] ==
                                                            "AIRTEL"
                                                        ? Colors.red.shade100
                                                        : previousphones[index]
                                                                    ['name'] ==
                                                                "GLO"
                                                            ? Colors
                                                                .pink.shade100
                                                            : Colors.black12,
                                                radius: 30.0,
                                                child: CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      previousphones[index]
                                                          ['logo']),
                                                  radius: 20.0,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                previousphones[index]['phone'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                )),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    showCursor: true,
                    readOnly: true,
                    validator: networkvalidator,
                    textAlign: TextAlign.left,
                    controller: _networkController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        // Based on passwordVisible state choose the icon

                        Icons.arrow_drop_down,
                      ),
                      labelText: "Select Network",
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
                                      "Select Network Provider",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Colors.grey.shade500,
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: _networklist.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _planController.text = "";
                                            networkobject = _networklist[index];
                                            _networkController.text =
                                                _networklist[index]["name"];

                                            _network =
                                                _networklist[index]["id"];
                                          });

                                          if (_networklist[index]["name"] ==
                                              "MTN") {
                                            setState(() {
                                              _datatype = _datatype1;
                                            });
                                          } else if (_networklist[index]
                                                  ["name"] ==
                                              "9MOBILE") {
                                            setState(() {
                                              _datatype = _datatype3;
                                            });
                                          } else {
                                            setState(() {
                                              _datatype = _datatype2;
                                            });
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              border: Border.all(
                                                  color: _networkController
                                                              .text ==
                                                          _networklist[index]
                                                              ["name"]
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade300),
                                            ),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      _networklist[index]
                                                          ["logo"]),
                                                  radius: 30.0,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  _networklist[index]["name"],
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
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
                        _planController.text = "";
                        showModalBottomSheet(
                          elevation: 0,
                          context: context,
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.hardEdge,
                          builder: (BuildContext context) {
                            ToastContext().init(context);
                            return Container(
                              height: 400,
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
                                            fontSize: 18,
                                            color: Colors.grey.shade600),
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
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 5, 10, 5),
                                            child: Container(
                                              padding: EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                    color: _datatypeController
                                                                .text ==
                                                            _datatype[index]
                                                                ["name"]
                                                        ? Colors.red.shade300
                                                        : Colors.grey.shade300),
                                              ),
                                              child: Text(
                                                _datatype[index]["name"],
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                            backgroundColor:
                                const Color.fromRGBO(48, 63, 159, 1),
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
                            backgroundColor: Color.fromRGBO(194, 24, 24, 1),
                            duration: Toast.lengthLong,
                            gravity: Toast.top);
                      } else {
                        moveToPlanPage(_datatypeController.text);
                      }
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

                          Icons.contact_phone_sharp,

                          color: Colors.grey,
                        ),
                        onPressed: () async {
                          Contact? contact =
                              await _contactPicker.selectContact();
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
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
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
