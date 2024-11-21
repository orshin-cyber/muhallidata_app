// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toast/toast.dart';

class WalletSummary extends StatefulWidget {
  final String? title;

  WalletSummary({Key? key, this.title}) : super(key: key);

  @override
  _WalletSummaryState createState() => _WalletSummaryState();
}

class _WalletSummaryState extends State<WalletSummary> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _is_history_Loading = false;
  int page = 1;
  bool hasNextPage = true;
  bool isMoreLoading = false;
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List wallethistory = [];
  late ScrollController _controller;
  List _searchResult = [];

  @override
  void initState() {
    fetchhistory();
    super.initState();
    _controller = ScrollController()..addListener(fetchMore);
  }

  Future _searchhistory(String query) async {
    setState(() {});

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final url = 'https://muhallidata.com/api/Wallet_summary/?search=$query';
    final response = await get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      'Authorization': 'Token ${sharedPreferences.getString("token")}'
    });

    if (response.statusCode == 200) {
      if (json.decode(response.body).length >= 1) {
        var jsonResponse = json.decode(response.body)['results'];
        setState(() {
          _searchResult = jsonResponse;
        });
      }
      setState(() {});
    } else {
      setState(() {});

      throw Exception('Failed to load DataH from API');
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      return;
    }

    _searchhistory(text);
  }

  _order_title(text) {
    if (text.contains("Transfer")) {
      return "Transfer";
    } else if (text.contains("Funding")) {
      return "Wallet Funding";
    } else if (text.contains("DATA")) {
      return "Data Topup";
    } else if (text.contains("VTU")) {
      return "Airtime Topup";
    } else if (text.contains("REFUND")) {
      return "Order Refund";
    } else if (text.contains("VTU")) {
      return "Airtime Topup";
    } else if (text.contains("Airtime pin")) {
      return "Airtime pin";
    } else {
      return "Transaction";
    }
  }

  _order_logo(text) {
    if (text.contains("Transfer")) {
      return "icons/out.png";
    } else if (text.contains("Funding")) {
      return "icons/in.png";
    } else if (text.contains("MTN")) {
      return "assets/mtn.jpeg";
    } else if (text.contains("GLO")) {
      return "assets/glo.jpg";
    } else if (text.contains("AIRTEL")) {
      return "assets/airtel.jpeg";
    } else if (text.contains("9MOBILE")) {
      return "assets/9mobile.jpeg";
    } else if (text.contains("GOtv")) {
      return "assets/gotv.jpeg";
    } else if (text.contains("DStv")) {
      return "assets/dstv.jpeg";
    } else if (text.contains("Cable tv")) {
      return "assets/startime.jpeg";
    } else if (text.contains("Abuja")) {
      return "assets/abuja.jpg";
    } else if (text.contains("Ikeja")) {
      return "assets/ikeja.jpg";
    } else if (text.contains("Enugu")) {
      return "assets/enugu.jpeg";
    } else if (text.contains("Kano")) {
      return "assets/kano.png";
    } else if (text.contains("Port Harcourt")) {
      return "assets/porthacout.jpg";
    } else if (text.contains("Ibadan")) {
      return "assets/ibadan.png";
    } else if (text.contains("Jos")) {
      return "assets/jos.jpeg";
    } else if (text.contains("Kaduna")) {
      return "assets/kaduna.jpg";
    } else if (text.contains("Benin")) {
      return "assets/benin.jpeg";
    } else {
      return "assets/money-transfer.png";
    }
  }

  Future fetchMore() async {
    if (hasNextPage == true &&
        isMoreLoading == false &&
        _is_history_Loading == false) {
      setState(() {
        isMoreLoading = true;
      });

      page = page + 1;
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences = await SharedPreferences.getInstance();
      try {
        final url =
            'https://www.muhallidata.com/api/Wallet_summary/?page=$page';
        final response = await get(Uri.parse(url), headers: {
          "Content-Type": "application/json",
          'Authorization': 'Token ${sharedPreferences.getString("token")}'
        }).timeout(const Duration(seconds: 30));

        //print('########## DOWN ############');
        //print(response.body);
        //print(response.statusCode);

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body)["results"];

          setState(() {
            wallethistory.addAll(data as List);
            isMoreLoading = false;
          });

          if (jsonDecode(response.body)["next"] == null) {
            setState(() {
              hasNextPage = false;
            });
          }
        } else {
          setState(() {
            isMoreLoading = false;
          });
        }
      } on TimeoutException catch (e) {
        print(e);
        setState(() {
          isMoreLoading = false;
        });

        Toast.show(
            "Oops ,request is taking much time to response, please retry",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
      } on Error catch (e) {
        print(e);

        setState(() {
          isMoreLoading = false;
        });

        Toast.show("Oops ,Unexpected error occured",
            backgroundColor: Colors.red,
            duration: Toast.lengthLong,
            gravity: Toast.bottom);
      }
    }
  }

  Future fetchhistory() async {
    if (this.mounted) {
      setState(() {
        _is_history_Loading = true;
      });
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences = await SharedPreferences.getInstance();
    try {
      final url = 'https://www.muhallidata.com/api/Wallet_summary/';
      final response = await get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${sharedPreferences.getString("token")}'
      }).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            wallethistory = jsonDecode(response.body)["results"] as List;
            _is_history_Loading = false;
          });
          //print('###############MAIN WALLET SUMMARY###############');
          //print(wallethistory);
        }
      } else {
        if (this.mounted) {
          setState(() {
            _is_history_Loading = false;
          });
        }

        throw Exception('Failed to load DataH from API');
      }
    } on TimeoutException catch (e) {
      print(e);
      setState(() {
        _is_history_Loading = false;
      });

      Toast.show("Oops ,request is taking much time to response, please retry",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    } on Error catch (e) {
      print(e);
      setState(() {
        _is_history_Loading = false;
      });

      Toast.show("Oops ,Unexpected error occured",
          backgroundColor: Colors.red,
          duration: Toast.lengthLong,
          gravity: Toast.bottom);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("Wallet Summary",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
          // height: MediaQuery.of(context).size.height * 0.25,
          margin: EdgeInsets.only(top: 5, left: 20, right: 20, bottom: 30),
          child: _is_history_Loading
              ? Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Shimmer.fromColors(
                    baseColor: const Color.fromRGBO(224, 224, 224, 1),
                    highlightColor: const Color.fromRGBO(245, 245, 245, 1),
                    enabled: true,
                    child: ListView.builder(
                      itemBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 52.0,
                              height: 52.0,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                  ),
                                  Container(
                                    width: 40.0,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      itemCount: 20,
                    ),
                  ))
              : Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 1)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                child: TextFormField(
                                  controller: searchtext,
                                  obscureText: false,
                                  onChanged: (String val) {
                                    onSearchTextChanged(val);
                                    if (val.length >= 1) {
                                      setState(() {
                                        userInput = true;
                                      });
                                    } else {
                                      setState(() {
                                        userInput = false;
                                      });
                                    }
                                  },
                                  textAlign: TextAlign.left,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search.....',
                                    contentPadding: EdgeInsets.all(5),
                                  ),
                                ),
                              ),
                            ),
                            searchtext.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        searchtext.text = "";
                                        _searchResult.clear();
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        size: 15.0,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        )),
                    SizedBox(
                      height: 20,
                    ),

                    _searchResult.length != 0
                        ? Expanded(
                            child: Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _searchResult.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      backgroundColor:
                                                          Colors.green.shade100,
                                                      radius: 25.0,
                                                      child: CircleAvatar(
                                                        backgroundImage: AssetImage(
                                                            "${_order_logo(_searchResult[index]['product'])}"),
                                                        radius: 20.0,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            "${_order_title(_searchResult[index]['product'])}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            )),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.5,
                                                              child: Text(
                                                                  "${_searchResult[index]['product']}",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  maxLines: 5,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Color(
                                                                            0xff3A3A3A),
                                                                        fontWeight:
                                                                            FontWeight.w300),
                                                                  )),
                                                            ),
                                                            Text(
                                                                // " ${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(_searchResult[index]['create_date']))} ",
                                                                "${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(_searchResult[index]['create_date']).add(Duration(hours: 1)))}",
                                                                style:
                                                                    GoogleFonts
                                                                        .poppins(
                                                                  textStyle: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Color(
                                                                          0xff3A3A3A),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300),
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text("₦",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400)),
                                                  Text(
                                                      "${_searchResult[index]['amount']}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: TextStyle(
                                                            fontSize: 16,
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                                  }),
                            ),
                          )
                        : Expanded(
                            child: wallethistory.length > 0
                                ? Container(
                                    child: ListView.builder(
                                        controller: _controller,
                                        shrinkWrap: true,
                                        itemCount: wallethistory.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                              onTap: () {},
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(bottom: 20),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                Colors.green
                                                                    .shade100,
                                                            radius: 25.0,
                                                            child: CircleAvatar(
                                                              backgroundImage:
                                                                  AssetImage(
                                                                      "${_order_logo(wallethistory[index]['product'])}"),
                                                              radius: 20.0,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "${_order_title(wallethistory[index]['product'])}",
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    textStyle: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Color(
                                                                            0xff000000),
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  )),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: <Widget>[
                                                                  Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.5,
                                                                    child: Text(
                                                                        "${wallethistory[index]['product']}",
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .start,
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          textStyle: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xff3A3A3A),
                                                                              fontWeight: FontWeight.w300),
                                                                        )),
                                                                  ),
                                                                  Text(
                                                                      " ${DateFormat('yyyy-MM-dd – kk:mm a').format(DateTime.parse(wallethistory[index]['create_date']))} ",
                                                                      style: GoogleFonts
                                                                          .poppins(
                                                                        textStyle: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color:
                                                                                Color(0xff3A3A3A),
                                                                            fontWeight: FontWeight.w300),
                                                                      )),
                                                                ],
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("₦",
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)),
                                                        Text(
                                                            "${wallethistory[index]['amount']}",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              textStyle: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        }),
                                  )
                                : Container(
                                    child: Column(
                                      children: [
                                        Image.asset("images/empty.png"),
                                        Text(
                                            "You have not perform any transaction",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                  )),

                    isMoreLoading
                        ? Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: 20,
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : SizedBox(),

                    //  hasNextPage == false ? Padding(padding: EdgeInsets.only(top: 10,bottom: 20,),
                    // child: Center(
                    //    child: Text("No more transactions"),
                    // ),):SizedBox()
                  ],
                )),
    );
  }
}
