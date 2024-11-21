import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../airtime_funding_history.dart';
import '../airtimehistory.dart';
import '../billhistory.dart';
import '../cablehistory.dart';
import '../datacard_history.dart';
import '../datahistory.dart';
import '../recharge_history.dart';
import '../result_history.dart';
import '../withdrawhistory.dart';

class Transactions extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TransactionsState();
  }
}

class _TransactionsState extends State<Transactions> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController producttypesController = TextEditingController();
  int page = 0;
  List products_pages = [
    DataHListView(),
    AirtimeHListView(),
    CableHListView(),
    BillHListView(),
    WithdrawViewListView(),
    Airtime_fundingHListView(),
    ResultHListView(),
    RechargeHListView(),
    DataRechargeCardHListView(),
  ];

  List<Map> producttypes = [
    {"name": "Data", "value": 0},
    {"name": "Airtime", "value": 1},
    // {"name": "Data Card", "value": 8},
    {"name": "Cable Sub", "value": 2},
    {"name": "Electricity", "value": 3},
    {"name": "Withdraw", "value": 4},
    // {"name": "Airtime 2 Cash", "value": 5},
    {"name": "Exam Pin", "value": 6},
    {"name": "Recharge Card Printing", "value": 7},
  ];

  @override
  void initState() {
    super.initState();
    producttypesController.text = "DATA";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          title: Text("Transactions",
              style: TextStyle(color: Colors.black, fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                showCursor: true,
                readOnly: true,
                textAlign: TextAlign.left,
                controller: producttypesController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    // Based on passwordVisible state choose the icon

                    Icons.arrow_drop_down,
                  ),
                  labelText: "Product",
                  hintStyle: TextStyle(fontSize: 5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      width: 0.1,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(5),
                  fillColor: Colors.white,
                ),
                onTap: () {
                  showModalBottomSheet(
                    elevation: 0,
                    context: context,
                    backgroundColor: Colors.transparent,
                    clipBehavior: Clip.hardEdge,
                    builder: (BuildContext context) {
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
                                  "Select Product",
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
                                itemCount: producttypes.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        producttypesController.text =
                                            producttypes[index]["name"];
                                        page = producttypes[index]["value"];
                                      });

                                      Navigator.of(context).pop();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 5, 10, 5),
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color:
                                                  producttypesController.text ==
                                                          producttypes[index]
                                                              ["name"]
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
              SizedBox(
                height: 20,
              ),
              Expanded(child: products_pages[page])
            ],
          ),
        ));
  }
}
