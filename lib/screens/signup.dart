import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SignupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignupPageState();
  }
}

class _SignupPageState extends State<SignupPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _emailController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _referalController = TextEditingController();

  TextEditingController _phoneController = TextEditingController();

  TextEditingController _fullnamecontroller = TextEditingController();

  TextEditingController _addresscontroller = TextEditingController();

  bool _obscureText = true;
  bool agree_term = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String usernameV = '';
  String emailV = '';
  String passwordV = '';
  String referalV = '';
  String phoneV = '';
  String fullnameV = '';
  String addressV = '';

  Future<dynamic> _signupUser(String fullname, String username, String email,
      String password, referal, phone, address) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      String url = 'https://www.muhallidata.com/api/registration/';

      Response response = await post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "email": email,
            "password": password,
            "referer_username": referal,
            "Phone": phone,
            "FullName": fullname,
            "Platform": "app",
            "Address": address
          }));

      print({
        "username": username,
        "email": email,
        "password": password,
        "referer_username": referal,
        "Phone": phone,
        "FullName": fullname,
        "Platform": "app",
        "Address": address
      });

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseJson = json.decode(response.body);

        setState(() {
          _isLoading = false;

          // print(responseJson["key"]);

          sharedPreferences.setString("token", responseJson['token']);

          AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            title: 'Succes',
            desc: 'Registrations Successful, proceed to login',
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
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Container(
                color: Color(0xff0340cf),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        // fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            // padding: EdgeInsets.only(top: 20),
                            child: Container(
                              constraints: BoxConstraints(
                                minHeight:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //   image: AssetImage("images/userlogin.png"),
                                //   // fit: BoxFit.cover,
                                //   alignment: Alignment.bottomCenter,
                                // ),
                                // color: Color.fromARGB(255, 3, 14, 31),
                                color: Color(0xff0340cf),
                              ),
                            ),
                          ),
                          Image.asset("icons/wavebg.png"),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),

                                  // Text("muhallidata.com",
                                  //     style: GoogleFonts.poppins(
                                  //       textStyle: TextStyle(
                                  //           fontSize: 35,
                                  //           color: Colors.white,
                                  //           fontWeight: FontWeight.w700),
                                  //     )),
                                  // Image.asset(
                                  //   "assets/whitelogo.png",
                                  //   width: 300,
                                  //   height: 150,
                                  // ),

                                  // Container(
                                  //   child: Image.asset("images/download.png"),
                                  // ),

                                  SizedBox()
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 1.2,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: Form(
                        key: _formKey,
                        child: Column(children: <Widget>[
                          Center(
                            child: Text("Create Your Account",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _fullnamecontroller,
                              onSaved: (String? val) {
                                fullnameV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Full Name"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _usernameController,
                              onSaved: (String? val) {
                                usernameV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Username"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _emailController,
                              onSaved: (String? val) {
                                emailV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Email"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _addresscontroller,
                              onSaved: (String? val) {
                                addressV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Address"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _phoneController,
                              onSaved: (String? val) {
                                phoneV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Phone Number"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: false,
                              controller: _referalController,
                              onSaved: (String? val) {
                                referalV = val!;
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                      borderSide:
                                          BorderSide(color: Color(0xff3A3A3A))),
                                  labelText: "Referral Username (Optional)"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: TextFormField(
                              obscureText: _obscureText,
                              controller: _passwordController,
                              onSaved: (String? val) {
                                passwordV = val!;
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    borderSide:
                                        BorderSide(color: Color(0xff3A3A3A))),
                                labelText: "Password",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon

                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,

                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    // Update the state i.e. toogle the state of passwordVisible variable
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Checkbox(
                                  activeColor: Color(0xff0340cf),
                                  value: this.agree_term,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      this.agree_term = value!;
                                    });
                                  },
                                ),
                                Text(
                                  'By signing up, you agree to our ',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed("/login");
                                    },
                                    child: Text('Terms',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff0340cf),
                                              fontWeight: FontWeight.w400),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                setState(() => _isLoading = true);
                                await _signupUser(
                                  _fullnamecontroller.text,
                                  _usernameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                  _referalController.text,
                                  _phoneController.text,
                                  _addresscontroller.text,
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: Color(0xff0340cf),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Center(
                                child: Text('Sign Up',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Already a member',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed("/login");
                                },
                                child: Text('Sign in',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff0340cf),
                                          fontWeight: FontWeight.w400),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
