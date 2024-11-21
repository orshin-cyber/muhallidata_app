import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class ReservedAccount extends StatefulWidget {
  @override
  _ReservedAccountState createState() => _ReservedAccountState();
}

class _ReservedAccountState extends State<ReservedAccount> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var platform;
  bool _isLoading = false;
  final bool isVerified = false;
  List<dynamic> account = [];

  String username = "";
  Map? user;
  List<dynamic> banks = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<dynamic> getUser() async {
    try {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences pref = await SharedPreferences.getInstance();

      String url = 'https://www.muhallidata.com/api/user/';

      Response res = await get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${pref.getString("token")}'
        },
      );
      Map resJson = json.decode(res.body);

      print(resJson);

      user = resJson["user"];
      username = resJson["user"]["username"];
      banks = resJson["available_bank"] ?? [];
      account = resJson["user"]["bank_accounts"]['accounts'] ?? [];
      _isLoading = false;

      setState(() {});
    } catch (e) {
      // print(e);
      setState(() {
        _isLoading = false;
      });

      Toast.show("Something went wrong, please contact admin",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Virtual Account",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () async {
              if (user != null && user!["verify"]) {
                final result = await showModalBottomSheet(
                  context: context,
                  isDismissible: false,
                  isScrollControlled:
                      true, // Allows the bottom sheet to take full height
                  builder: (BuildContext context) {
                    return CreatVirtualAccount(
                      banks: banks,
                    );
                  },
                );

                if (result != null && result == true) {
                  getUser();
                }
              } else {
                final result = await showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  isScrollControlled:
                      true, // Allows the bottom sheet to take full height
                  builder: (BuildContext context) {
                    return VerifyIdentity();
                  },
                );

                if (result != null && result == true) {
                  getUser();
                }
              }
            },
            icon: Icon(
              Icons.add,
              size: 30,
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: account!.length > 0
                  ? Container(
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
                            Container(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: account!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.all(5),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xff0340cf),
                                        ),
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
                                                "${account![index]["accountNumber"]}",
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
                                                  Clipboard.setData(
                                                      new ClipboardData(
                                                          text:
                                                              "${account![index]["accountNumber"]}"));
                                                  Toast.show(
                                                      'Account number copied.',
                                                      backgroundColor:
                                                          Colors.green,
                                                      duration:
                                                          Toast.lengthLong,
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
                                                '${account![index]["bankName"] == "9Payment Service Bank" ? "₦35 charge" : "N50 charge"}',
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
                                                "${account![index]["bankName"]}",
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
                    )
                  : Column(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              // decoration: BoxDecoration(
                              //   border: Border.all(),
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue[50],
                                    ),
                                    padding: EdgeInsets.all(16),
                                    child: Icon(
                                      Icons.business, // Use an appropriate icon
                                      size: 48,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'You have not created any Virtual Account Yet',
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 16),
                                  if (user != null && user!["verify"]) ...[
                                    Text(
                                      '${user!["verify"]} Create a virtual account to fund your wallet. Please note that this account is exclusively linked to your wallet. You can add it as a beneficiary and send money to it anytime to top up your wallet.',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result =
                                            await showModalBottomSheet(
                                          context: context,
                                          isDismissible: false,
                                          isScrollControlled:
                                              true, // Allows the bottom sheet to take full height
                                          builder: (BuildContext context) {
                                            return CreatVirtualAccount(
                                              banks: banks,
                                            );
                                          },
                                        );

                                        if (result != null && result == true) {
                                          getUser();
                                        }
                                      },
                                      child: Text('Create Virtual Account'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Colors.amber, // Button color
                                      ),
                                    ),
                                  ] else ...[
                                    Text(
                                      'To generate a virtual account, we need to verify your identity. Rest assured, your submitted information will be kept safe and handled with care. We only require this to create your virtual account.',
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final result =
                                            await showModalBottomSheet(
                                          isDismissible: false,
                                          context: context,

                                          isScrollControlled:
                                              true, // Allows the bottom sheet to take full height
                                          builder: (BuildContext context) {
                                            return VerifyIdentity();
                                          },
                                        );

                                        if (result != null && result == true) {
                                          getUser();
                                        }
                                      },
                                      child: Text('Verify Your Identity'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.amber, // Butto
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            _isLoading
                ? Container(
                    color: Colors.white,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox()
          ],
        ),
      )),
    );
  }
}

class VerifyIdentity extends StatefulWidget {
  const VerifyIdentity({super.key});

  @override
  State<VerifyIdentity> createState() => _VerifyIdentityState();
}

class _VerifyIdentityState extends State<VerifyIdentity> {
  bool _isLoading = false;
  String name = "";
  String identityType = "";
  String number = "";
  String dob = "";
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
  }

  void _verifyIdentity() async {
    final Map<String, dynamic> requestData = {
      "name": name,
      "dob": dob,
      "number": number,
      "identity": identityType,
    };

    print(requestData);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      setState(() {
        _isLoading = true;
      });
      final response = await post(
        Uri.parse('https://www.muhallidata.com/api/identity-verification/'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
        });

        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: 'Success',
          desc: data['message'],
          btnOkOnPress: () {
            Navigator.of(context).pop(true);
          },
          btnOkIcon: Icons.check_circle,
        ).show();
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
        });

        Toast.show(errorData['message'] ?? "Something went wrong",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);

      Toast.show("Something went wrong, please contact admin ${e}",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Identity Verification',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    icon: Icon(Icons.close))
              ],
            ),
            SizedBox(height: 35),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Please provide valid information. Note that information verification is limited to 3 attempts per day. Continuous attempts with invalid information may result in your account being blocked.',
                style: TextStyle(color: Colors.red),
              ),
            ),
            SizedBox(height: 16),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name (as appears on your ID card)',
                    ),
                    maxLength: 100,
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Identity Type',
                    ),
                    items: [
                      DropdownMenuItem(value: 'BVN', child: Text('BVN')),
                      DropdownMenuItem(value: 'NIN', child: Text('NIN')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        identityType = value!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an identity type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Identity Number',
                      hintText: 'Your BVN/NIN number',
                    ),
                    onChanged: (value) {
                      setState(() {
                        number = value;
                      });
                    },
                    maxLength: 11,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your identity number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      String formattedDate = formatDate(pickedDate!);
                      _dateController.text = formattedDate;
                      dob = formattedDate;

                      setState(() {});
                    },
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      _verifyIdentity();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: _isLoading
                              ? Color.fromRGBO(58, 59, 77, 1)
                              : Color(0xff0340cf),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2)
                          ],
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Continue',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CreatVirtualAccount extends StatefulWidget {
  List<dynamic>? banks;
  CreatVirtualAccount({super.key, required this.banks});

  @override
  State<CreatVirtualAccount> createState() => _CreatVirtualAccountState();
}

class _CreatVirtualAccountState extends State<CreatVirtualAccount> {
  List<String> selectedMonnifyBanks = [];
  List<String> selectedPayvesselBanks = [];
  bool _isLoading = false;

  void _generateVirtualAccount() async {
    if (selectedMonnifyBanks.isEmpty && selectedPayvesselBanks.isEmpty) {
      Toast.show("Select at least one bank",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);

      return;
    }

    final Map<String, dynamic> requestData = {
      "monnify": selectedMonnifyBanks,
      "payvessel": selectedPayvesselBanks,
    };

    print(requestData);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      setState(() {
        _isLoading = true;
      });
      final response = await post(
        Uri.parse('https://www.muhallidata.com/api/create-virtual-account/'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        },
        body: jsonEncode(requestData),
      );

      print(response.statusCode);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
        });
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: 'Success',
          desc: data['message'],
          btnOkOnPress: () {
            Navigator.of(context).pop(true);
          },
          btnOkIcon: Icons.check_circle,
        ).show();
      } else {
        final errorData = jsonDecode(response.body);
        setState(() {
          _isLoading = false;
        });

        Toast.show(errorData['message'] ?? "Something went wrong",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.top);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Toast.show("Something went wrong, please contact admin ${e}",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.top);
    }
  }

  void _onMonnifyChanged(bool? selected, String bank) {
    setState(() {
      if (selected == true) {
        selectedMonnifyBanks.add(bank);
      } else {
        selectedMonnifyBanks.remove(bank);
      }
    });
  }

  void _onPayvesselChanged(bool? selected, String bank) {
    setState(() {
      if (selected == true) {
        selectedPayvesselBanks.add(bank);
      } else {
        selectedPayvesselBanks.remove(bank);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generate Account',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close))
            ],
          ),
          SizedBox(height: 25),
          Form(
            child: Column(
              children: [
                if (widget.banks == null || widget.banks!.isEmpty)
                  Center(
                    child: Text("No Banks Available"),
                  )
                else
                  ...widget.banks!
                      .map((e) => e["bankCode"] == "120001"
                          ? CheckboxListTile(
                              title: Text(e["bankName"]),
                              value: selectedPayvesselBanks
                                  .contains(e["bankCode"]),
                              onChanged: (value) =>
                                  _onPayvesselChanged(value, e["bankCode"]),
                            )
                          : CheckboxListTile(
                              title: Text(e["bankName"]),
                              value:
                                  selectedMonnifyBanks.contains(e["bankCode"]),
                              onChanged: (value) =>
                                  _onMonnifyChanged(value, e["bankCode"]),
                            ))
                      .toList(),
                SizedBox(height: 20),
                InkWell(
                  onTap: () async {
                    _isLoading ? () {} : _generateVirtualAccount();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: _isLoading
                            ? Color.fromRGBO(58, 59, 77, 1)
                            : Color(0xff0340cf),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.shade200,
                              offset: Offset(2, 4),
                              blurRadius: 5,
                              spreadRadius: 2)
                        ],
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Continue',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
