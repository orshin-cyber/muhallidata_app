import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AirtimeFunding_Comfirm extends StatefulWidget {
  String? network;
  String? phone;
  int? amount;

  AirtimeFunding_Comfirm({Key? key, this.network, this.amount, this.phone})
      : super(key: key);

  @override
  _AirtimeFunding_ComfirmState createState() => _AirtimeFunding_ComfirmState();
}

class _AirtimeFunding_ComfirmState extends State<AirtimeFunding_Comfirm> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late SharedPreferences sharedPreferences;
  var platform;
  late Map topuppercent;

  //bool _obscureText = true;

  @override
  void initState() {
    filldetails();
    super.initState();
  }

  Widget? Instruction() {
    if (widget.network == "MTN") {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "How to transfer airtime on ${widget.network}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${widget.network} Transfer - Default PIN : 0000",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "To Create a new PIN, Dial: *600*0000*NEWPIN*NEWPIN#",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "E.g, *600*0000*5555*5555# ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Dial *600*${topuppercent[widget.network]["phone"]}*${widget.amount}*5555#   to send the Airtime,Change 5555 to your pin if your already have pin ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ));
    } else if (widget.network == "GLO") {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.indigo.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "How to transfer airtime on ${widget.network}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${widget.network} Transfer - Default PIN : 0000",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "To Create a new PIN, Dial *132*0000*NEWPIN*NEWPIN#",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "E.g, *132*0000*55555*55555# ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Dial **131**${topuppercent[widget.network]["phone"]}*${widget.amount}*${widget.amount}*5555#  to send the Airtime, Change 5555 to your pin if your already have pin ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ));
    } else if (widget.network == "AIRTEL") {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.shade100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "How to transfer airtime on ${widget.network}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${widget.network} Transfer - Default PIN : 0000",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "To Create a new PIN, *432*4*1*1234*NEWPIN*NEWPIN#",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "E.g, *432*4*1*1234*5555*5555# ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Dial *432*1*${topuppercent[widget.network]["phone"]}*${widget.amount}*${widget.amount}*5555#  to send the Airtime, Change 5555 to your pin if your already have pin ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ));
    } else if (widget.network == "9MOBILE") {
      return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "How to transfer airtime on ${widget.network}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${widget.network} Transfer - Default PIN : 0000",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "To Create a new PIN, Dial: *247*0000*NEWPIN#",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              Text(
                "E.g, *247*0000*5555# ",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Dial *223*5555*${topuppercent[widget.network]["phone"]}*${widget.amount}*${widget.amount}#  to send the Airtime , Change 5555 to your pin if your already have pin",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ));
    }
  }

  Future<dynamic> filldetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var topuppercentjson =
        json.decode(sharedPreferences.getString("percentage")!);

    setState(() {
      topuppercent = topuppercentjson;
    });
  }

  Future<dynamic> _airtimeFunding_Comfirm() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

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
      String url = 'https://www.muhallidata.com/api/Airtime_funding/';
      String? net;
      if (widget.network == "MTN") {
        net = "1";
      } else if (widget.network == "GLO") {
        net = "2";
      } else if (widget.network == "AIRTEL") {
        net = "4";
      } else if (widget.network == "9MOBILE") {
        net = "3";
      }

      Response response = await post(Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Token ${sharedPreferences.getString("token")}'
          },
          body: jsonEncode({
            "amount": widget.amount,
            "network": net,
            "mobile_number": widget.phone,
            "Platform": platform
          }));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);

            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              title: 'Success',
              desc:
                  'Your Request has been submitted successfuly , we will process it shortly, \n Thank You',
              btnOkOnPress: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("/home", (route) => false);
              },
              btnOkIcon: Icons.check_circle,
            ).show();
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
            btnCancelOnPress: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/airtimefundin", (route) => false);
            },
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        ToastContext().init(context);
        return AlertDialog(
          title: Text('Comfirmation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you have transfer the airtime to the number?'),
                SizedBox(
                  height: 10,
                ),
                Text(
                    'Note: if you click submit without been transfer , you account will be ban.',
                    style: TextStyle(color: Colors.red)),
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
                Navigator.of(context).pop();
                setState(() => _isLoading = true);
                await _airtimeFunding_Comfirm();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        _showMyDialog();
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
                  const Color.fromRGBO(48, 63, 159, 1),
                  const Color.fromRGBO(48, 63, 159, 1)
                ])),
        child: Text(
          'Submit',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _AirtimeFunding_ComfirmfieldsWidget() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Instruction()!
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Airtime Funding Payment",
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
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Kindly transfer the sum of ₦${widget.amount} to the phone number shown below",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${topuppercent[widget.network]["phone"]}",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade100,
                            ),
                            child: Text(
                              "PLEASE NOTE: Due to certain restriction, We cannot automatically deduct airtime, you have to manually transfer the airtime to the phone number above, Thank you ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Instruction()!,
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                            ),
                            child: Text(
                              "Only Click Submit after you have transfer the airtime to avoid your account been Ban",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          _submitButton(),
                          Expanded(
                            flex: 2,
                            child: SizedBox(),
                          ),
                        ],
                      )),
                ),
              ],
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
