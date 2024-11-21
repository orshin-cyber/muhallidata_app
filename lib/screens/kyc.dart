import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_plus_plus/dropdown_plus_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class KycPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _KycPageState();
  }
}

class _KycPageState extends State<KycPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _middlenameController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();

  TextEditingController _dobController = TextEditingController();

  TextEditingController _stateController = TextEditingController();
  TextEditingController _bvnController = TextEditingController();
  TextEditingController _lgController = TextEditingController();

  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _gender;

  late XFile uploadimage; //variable for choosed file

  Future<bool> getFileSize(File file) async {
    int bytes = await file.length();
    if (bytes <= 0) return false;
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    var size = (bytes / pow(1024, i));

    if (size > 100) {
      Toast.show(
          'Exceed maximum size 100KB, uploaded image size ${size.toStringAsFixed(2) + ' ' + suffixes[i]}',
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
      return false;
    } else {
      return true;
    }
  }

  Future<bool> chooseImage() async {
    final ImagePicker _picker = ImagePicker();
    var choosedimage = await _picker.pickImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 50);

    int bytes = await choosedimage!.length();
    if (bytes <= 0) return false;
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    var size = (bytes / pow(1024, i));

    if (size > 100) {
      Toast.show(
          'Exceed maximum size 100KB, uploaded image size ${size.toStringAsFixed(2) + ' ' + suffixes[i]}',
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
      return false;
    } else {
      setState(() {
        uploadimage = choosedimage;
      });
      return false;
    }
  }

  Future<dynamic> sendkyc() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      List<int> imageBytes = await File(uploadimage.path).readAsBytes();

      String baseimage = base64Encode(imageBytes);

      print(({
        "First_Name": _firstnameController.text,
        'Middle_Name': _middlenameController.text,
        'Last_Name': _lastnameController.text,
        "DoB": _dobController.text,
        'Gender': _gender,
        "State_of_origin": _stateController.text,
        "Local_gov_of_origin": _lgController.text,
        "BVN": _bvnController.text,
        "passport_photogragh": baseimage
      }));
      String url = 'https://www.muhallidata.com/api/kyc/';
      var uri = Uri.parse(url);
      var request = MultipartRequest("POST", uri);
      Map<String, String> headers = {
        "Accept": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      };

      request.files.add(await MultipartFile.fromPath(
          'passport_photogragh', uploadimage.path));
      request.fields["First_Name"] = _firstnameController.text;
      request.fields['Middle_Name'] = _middlenameController.text;
      request.fields['Last_Name'] = _lastnameController.text;
      request.fields["Date_of_Birth"] = _dobController.text;
      request.fields['Gender'] = _gender;
      request.fields["State_of_origin"] = _stateController.text;
      request.fields["Local_gov_of_origin"] = _lgController.text;
      request.fields["BVN"] = _bvnController.text;
      request.headers.addAll(headers);

      var response = await request.send();

      print(response.statusCode);
      print(response.stream);

      response.stream.transform(utf8.decoder).listen((value) {
        var datares = jsonDecode(value);

        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            _isLoading = false;
            AwesomeDialog(
              context: context,
              animType: AnimType.leftSlide,
              headerAnimationLoop: false,
              dialogType: DialogType.success,
              title: 'Succes',
              desc: datares['message'],
              btnOkOnPress: () {
                Navigator.of(context).pushNamed("/home");
              },
              btnOkIcon: Icons.check_circle,
            ).show();
          });
        } else if (response.statusCode == 500) {
          setState(() {
            _isLoading = false;
          });

          Toast.show("Unable to connect to server currently",
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        } else {
          setState(() {
            _isLoading = false;
          });

          Toast.show(datares['message'],
              backgroundColor: Colors.red,
              duration: Toast.lengthLong,
              gravity: Toast.top);
        }
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      Toast.show('$error',
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
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
      appBar: AppBar(
        title:
            Text("KYC", style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.red,
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: <Widget>[
                        Container(
                            //show image here after choosing image
                            child: uploadimage == null
                                ? InkWell(
                                    onTap: () {
                                      chooseImage();
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(top: 20),
                                        padding: EdgeInsets.only(
                                            top: 4,
                                            left: 18,
                                            right: 18,
                                            bottom: 4),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black12,
                                                  blurRadius: 5)
                                            ]),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.cloud_upload_outlined,
                                              size: 100,
                                            ),
                                            Text(
                                                "Select Passport Photograh\nMaximum size of 100kb")
                                          ],
                                        )),
                                  )
                                : //if uploadimage is null then show empty container
                                Container(
                                    margin: EdgeInsets.only(top: 20),
                                    padding: EdgeInsets.only(
                                        top: 4, left: 18, right: 18, bottom: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 5)
                                        ]), //elese show image here
                                    child: SizedBox(
                                        height: 150,
                                        child: Image.file(File(uploadimage
                                            .path)) //load image from file
                                        ))),
                        uploadimage != null
                            ? Container(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    chooseImage(); // call choose image function
                                  },
                                  icon: Icon(Icons.image),
                                  label: Text("Change this Passport"),
                                  // color: Colors.red,
                                  // colorBrightness: Brightness.dark,
                                ),
                              )
                            : SizedBox(),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                            },
                            obscureText: false,
                            controller: _firstnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.supervised_user_circle_outlined,
                                color: Colors.grey,
                              ),
                              hintText: 'First Name',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            obscureText: false,
                            controller: _middlenameController,
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user_sharp,
                                color: Colors.grey,
                              ),
                              hintText: 'Middle Name',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _lastnameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.verified_user_sharp,
                                color: Colors.grey,
                              ),
                              hintText: 'SurName',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _bvnController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.settings_cell_rounded,
                                color: Colors.grey,
                              ),
                              hintText: 'NIN/BVN',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _stateController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.house_rounded,
                                color: Colors.grey,
                              ),
                              hintText: 'State of origin',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            obscureText: false,
                            controller: _lgController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.house,
                                color: Colors.grey,
                              ),
                              hintText: 'LG of origin',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          height: 60,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: TextFormField(
                            validator: (String? value) {
                              if (value?.length == 0) {
                                return "This field is required";
                              }
                              return null;
                            },
                            readOnly: true,
                            obscureText: false,
                            controller: _dobController,
                            onTap: () async {
                              await showDatePicker(
                                context: context,
                                initialDate: DateTime(1998),
                                firstDate: DateTime(1800),
                                lastDate: DateTime(2021),
                              ).then((selectedDate) {
                                if (selectedDate != null) {
                                  _dobController.text = DateFormat('yyyy-MM-dd')
                                      .format(selectedDate);
                                }
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.calendar_today,
                                color: Colors.grey,
                              ),
                              hintText: 'Date of Birth',
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.2,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(
                              top: 4, left: 18, right: 18, bottom: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 5)
                              ]),
                          child: DropdownFormField<Map<String, dynamic>>(
                            dropdownItemSeparator: Divider(
                              color: Colors.black,
                              height: 1,
                            ),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                suffixIcon: Icon(Icons.arrow_drop_down),
                                labelText: "Gender"),
                            onSaved: (dynamic value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            onChanged: (dynamic value) {
                              setState(() {
                                _gender = value;
                              });
                            },
                            // validator: (dynamic str) {},
                            displayItemFn: (dynamic item) => Text(
                              item['name'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                            dropdownItemFn: (dynamic item, position, focused,
                                    dynamic lastSelectedItem, onTap) =>
                                ListTile(
                              title: Text(item['name']),
                              tileColor: focused
                                  ? Color.fromARGB(20, 0, 0, 0)
                                  : Colors.transparent,
                              onTap: onTap,
                            ),
                            findFn: (dynamic str) async => [
                              {"name": "MALE", "desc": "MALE"},
                              {"name": "FEMALE", "desc": "FEMALE"}
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              if (_gender == null) {
                                Toast.show("Select Your gender",
                                    backgroundColor: Colors.red,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.top);
                                return;
                              }

                              if (uploadimage == null) {
                                Toast.show(
                                    "Pls upload your passport photograph",
                                    backgroundColor: Colors.red,
                                    duration: Toast.lengthLong,
                                    gravity: Toast.top);
                                return;
                              }
                              setState(() => _isLoading = true);
                              await sendkyc();
                            }
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    const Color.fromRGBO(198, 40, 40, 1),
                                    const Color.fromRGBO(244, 67, 54, 1),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                'Submit'.toUpperCase(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
  }
}
