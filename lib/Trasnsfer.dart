import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:muhallidata/screens/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'bottompin.dart';

class Transfer extends StatefulWidget {
  final String? title;

  Transfer({Key? key, this.title}) : super(key: key);

  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _amountController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String amountV = "";
  late String usernameV;

  //bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _transfer(String amount, String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    try {
      String url = 'https://www.muhallidata.com/api/transfer/';

      Response response = await post(Uri.parse(url),
              headers: {
                "Content-Type": "application/json",
                'Authorization': 'Token ${sharedPreferences.getString("token")}'
              },
              body:
                  jsonEncode({"amount": amount, "receiver_username": username}))
          .timeout(const Duration(seconds: 30));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        //var responseJson = json.decode(response.body);

        if (this.mounted) {
          setState(() {
            _isLoading = false;
            print(response.body);
            Map responseJson = json.decode(response.body);

            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              title: 'Success',
              desc:
                  '₦${responseJson["amount"]} succesfully Transfer to ${responseJson["receiver_username"]} from your wallet',
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
            backgroundColor: Colors.blue,
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
          // Toast.show(responseJson["error"][0],  context, backgroundColor:Colors.blue,duration: Toast.lengthLong, duration: Toast.lengthLong, gravity:  Toast.top);
        }
      } else {
        if (this.mounted) {
          setState(() {
            _isLoading = false;
          });
        }

        Toast.show("Unable to connect to server currently",
            backgroundColor: Colors.blue,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } on TimeoutException catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,request is taking much time to response, please retry",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } on Error catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });

      Toast.show("Oops ,Unexpected error occured",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } finally {
      Client().close();
    }
  }

  Widget _entryField(String title, myicon, mykey, String inputvalue,
      TextEditingController controll,
      {dynamic valid, bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              obscureText: isPassword,
              controller: controll,
              validator: valid,
              keyboardType: mykey,
              onSaved: (String? val) {
                inputvalue = val!;
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  icon: Icon(myicon),
                  filled: true)),
        ],
      ),
    );
  }

  void databuy() async {
    await _transfer(_amountController.text, _usernameController.text);
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Bottom_pin(
                    title:
                        "You are about to Transfer  ₦${_amountController.text} to ${_usernameController.text} ",
                    onTap: databuy);
              });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.shade200,
              offset: Offset(2, 4),
              blurRadius: 5,
              spreadRadius: 2)
        ], color: Color(0xff0340cf)),
        child: Text(
          'Transfer',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _TransferfieldsWidget() {
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
              _entryField("Receiver Username", Icons.verified_user,
                  TextInputType.text, amountV, _usernameController,
                  valid: validateuser),
              _entryField("Amount", Icons.account_balance_wallet,
                  TextInputType.number, amountV, _amountController,
                  valid: validatemusa),
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
          title: Text("Transfer",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: ModalProgressHUD(
          child: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _TransferfieldsWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          )),
          inAsyncCall: _isLoading,
        ));
  }
}
