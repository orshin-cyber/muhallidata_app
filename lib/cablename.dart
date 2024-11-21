import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cablesub.dart';

class CableName extends StatefulWidget {
  @override
  _CableNameState createState() => _CableNameState();
}

class _CableNameState extends State<CableName> {
  late List<dynamic> gotv;
  late List<dynamic> dstv;
  late List<dynamic> startime;
  late List<dynamic> cablename;
  late SharedPreferences sharedPreferences;
  bool _isLoading = false;

  void initState() {
    loadplan();
    super.initState();
  }

  loadplan() async {
    sharedPreferences = await SharedPreferences.getInstance();

    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    String url = 'https://www.muhallidata.com/api/cable/';

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      },
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      Map resJson = json.decode(res.body);
      //(resJson);

      print(resJson["cablename"]);

      if (this.mounted) {
        setState(() {
          cablename = resJson["cablename"].map((net) => net["id"]).toList();
          gotv = resJson["GOTVPLAN"];
          dstv = resJson["DSTVPLAN"];
          startime = resJson["STARTIME"];

          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Decoder",
            style: TextStyle(color: Colors.white, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: ModalProgressHUD(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.0),
              Expanded(
                  child: GridView.count(
                      shrinkWrap: true,
                      primary: false,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      crossAxisCount: 2,
                      children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/gotv.jpeg",
                                    id: cablename[0],
                                    plan: gotv)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/gotv.jpeg"),
                            radius: 10.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/dstv.jpeg",
                                    id: cablename[1],
                                    plan: dstv)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/dstv.jpeg"),
                            radius: 10.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => CableS(
                                    image: "assets/startime.jpeg",
                                    id: cablename[2],
                                    plan: startime)));
                      },
                      child: Material(
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/startime.jpeg"),
                            radius: 30.0,
                          ),
                          elevation: 50,
                          borderRadius: BorderRadius.circular(10)

                          //borderRadius: BorderRadius.circular(30),

                          ),
                    ),
                  ]))
            ]),
        inAsyncCall: _isLoading,
      ),
    );
  }
}
