import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

class ResetPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordState();
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  String emailV = '';

  //bool _obscureText = true;

  /*
  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  
  */

  Future<dynamic> _resetPassword(
    String email,
  ) async {
    try {
      String url = 'https://www.muhallidata.com/rest-auth/password/reset/';

      Response response = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": email,
          }));

      print(jsonEncode({
        "email": email,
      }));
      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        json.decode(response.body);

        setState(() {
          _isLoading = false;
          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: 'Succes',
            desc: 'Verification Link has been sent to you',
            btnOkOnPress: () {
              Navigator.of(context).pushNamed("/login");
            },
            btnOkIcon: Icons.check_circle,
          ).show();
        });
      } else if (response.statusCode == 500) {
        setState(() {
          _isLoading = false;
        });
        print(response.body);

        Toast.show(
            "something went wrong please ,report to admin before try another transaction",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      } else {
        setState(() {
          _isLoading = false;
        });
        Map responseJson = json.decode(response.body);

        if (responseJson.containsKey("username")) {
          print(responseJson["username"][0]);

          Toast.show(responseJson["username"][0],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        } else if (responseJson.containsKey("email")) {
          Toast.show(responseJson["email"][0],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        } else if (responseJson.containsKey("password")) {
          Toast.show(responseJson["password"][0],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        } else if (responseJson.containsKey("Phone")) {
          Toast.show(responseJson["Phone"][0],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        } else if (responseJson.containsKey("error")) {
          Toast.show(responseJson["error"][0],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        }
      }
    } finally {
      Client().close();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xff0340cf),
            child: Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        // padding: EdgeInsets.only(top: 20),
                        child: Container(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                          ),
                          // decoration: BoxDecoration(
                          //   image: DecorationImage(
                          //     image: AssetImage("images/userlogin.png"),
                          //     // fit: BoxFit.cover,
                          //     alignment: Alignment.bottomCenter,
                          //   ),
                          //   // color: Color.fromARGB(255, 3, 14, 31),
                          //   color: Color(0xff0340cf),
                          // ),
                        ),
                      ),
                      Image.asset("icons/wavebg.png"),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/login");
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Text("Password Reset",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: TextFormField(
                            obscureText: false,
                            autovalidateMode: AutovalidateMode.always,
                            controller: _emailController,
                            onSaved: (String? val) {
                              emailV = val!;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xff3A3A3A))),
                                labelText: "Email"),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              setState(() => _isLoading = true);
                              await _resetPassword(
                                _emailController.text,
                              );
                            }
                          },
                          child: Container(
                            height: 52,
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                color: Color(0xff0340cf),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text('Proceed',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        inAsyncCall: _isLoading,
      ),
    );

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //     key: _scaffoldKey,
    //     resizeToAvoidBottomInset: false,
    //     body: ModalProgressHUD(
    //       child: SingleChildScrollView(
    //         child: Container(
    //           child: Column(
    //             children: <Widget>[
    //               Container(
    //                 width: MediaQuery.of(context).size.width,
    //                 height: MediaQuery.of(context).size.height / 2.5,
    //                 decoration: BoxDecoration(
    //                     gradient: LinearGradient(
    //                       begin: Alignment.topCenter,
    //                       end: Alignment.bottomCenter,
    //                       colors: [
    //                         Colors.blue[800],
    //                         Colors.blue,
    //                       ],
    //                     ),
    //                     borderRadius:
    //                         BorderRadius.only(bottomLeft: Radius.circular(90))),
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: <Widget>[
    //                     Spacer(),
    //                     Column(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         CircleAvatar(
    //                           backgroundColor: Colors.white,
    //                           radius: 50.0,
    //                           child: SvgPicture.asset(
    //                             "images/top-up.svg",
    //                             semanticsLabel: 'Logo',
    //                             width: 50,
    //                             height: 50,
    //                           ),
    //                         ),
    //                         Text(
    //                           "Datas",
    //                           style: TextStyle(
    //                               color: Colors.white,
    //                               fontSize: 25.0,
    //                               fontWeight: FontWeight.bold),
    //                         )
    //                       ],
    //                     ),
    //                     Spacer(),
    //                     Align(
    //                       alignment: Alignment.bottomRight,
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(bottom: 32, right: 32),
    //                         child: Text(
    //                           'Reset Password',
    //                           style: TextStyle(color: Colors.white, fontSize: 18),
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Form(
    //                 key: _formKey,
    //                 autovalidateMode: AutovalidateMode.always,
    //                 child: Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: EdgeInsets.only(top: 62),
    //                   child: Column(
    //                     children: <Widget>[
    //                       Container(
    //                         width: MediaQuery.of(context).size.width / 1.2,
    //                         height: 60,
    //                         margin: EdgeInsets.only(top: 20),
    //                         padding: EdgeInsets.only(
    //                             top: 4, left: 18, right: 18, bottom: 4),
    //                         decoration: BoxDecoration(
    //                             borderRadius:
    //                                 BorderRadius.all(Radius.circular(50)),
    //                             color: Colors.white,
    //                             boxShadow: [
    //                               BoxShadow(color: Colors.black12, blurRadius: 5)
    //                             ]),
    //                         child: TextFormField(
    //                           obscureText: false,
    //                           controller: _emailController,
    //                           onSaved: (String val) {
    //                             emailV = val;
    //                           },
    //                           decoration: InputDecoration(
    //                             border: InputBorder.none,
    //                             icon: Icon(
    //                               Icons.email,
    //                               color: Colors.grey,
    //                             ),
    //                             hintText: 'Email your Email',
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 15,
    //                       ),
    //                       InkWell(
    //                         onTap: () async {
    //                           if (_formKey.currentState!.validate()) {
    //                             _formKey.currentState!.save();
    //                             setState(() => _isLoading = true);
    //                             await _resetPassword(
    //                               _emailController.text,
    //                             );
    //                           }
    //                         },
    //                         child: Container(
    //                           height: 60,
    //                           width: MediaQuery.of(context).size.width / 1.2,
    //                           decoration: BoxDecoration(
    //                               gradient: LinearGradient(
    //                                 colors: [
    //                                   Colors.blue[800],
    //                                   Colors.blue,
    //                                 ],
    //                               ),
    //                               borderRadius:
    //                                   BorderRadius.all(Radius.circular(50))),
    //                           child: Center(
    //                             child: Text(
    //                               'Reset Password'.toUpperCase(),
    //                               style: TextStyle(
    //                                   color: Colors.white,
    //                                   fontWeight: FontWeight.bold),
    //                             ),
    //                           ),
    //                         ),
    //                       ),
    //                       SizedBox(
    //                         height: 30,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       inAsyncCall: _isLoading,
    //     ),
    //   );
  }
}
