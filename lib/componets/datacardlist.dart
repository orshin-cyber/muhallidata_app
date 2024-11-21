import 'package:flutter/material.dart';

class DataRechargeCardSlecetionBox extends StatefulWidget {
  final List<dynamic>? plan;

  DataRechargeCardSlecetionBox({Key? key, @required this.plan})
      : super(key: key);
  @override
  _DataRechargeCardSlecetionBoxState createState() =>
      _DataRechargeCardSlecetionBoxState();
}

class _DataRechargeCardSlecetionBoxState
    extends State<DataRechargeCardSlecetionBox> {
  bool userInput = false;
  TextEditingController searchtext = TextEditingController();
  List _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    widget.plan!.forEach((plan) {
      if (plan['plan'].toLowerCase().contains(text.toLowerCase()) ||
          plan['plan_network'].toLowerCase().contains(text.toLowerCase()) ||
          plan['plan_type'].toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(plan);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: SafeArea(
          child: Container(
              padding: const EdgeInsets.all(8.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.navigate_before,
                      size: 35.0,
                    ),
                  ),
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
                        onSaved: (String? val) {},
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search',
                        ),
                      ),
                    ),
                  ),
                  userInput
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              searchtext.text = "";
                              _searchResult = [];
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 25.0,
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              )),
        ),
      ),
      body: _searchResult.length != 0 || searchtext.text.isNotEmpty
          ? ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      "text":
                          "${_searchResult[index]['plan_network']} ${_searchResult[index]['plan']} ${_searchResult[index]['plan_type']}   -   ?${_searchResult[index]['plan_amount']} - ${_searchResult[index]['month_validate']}",
                      "value": "${_searchResult[index]['id']}",
                      "amount_to_pay": _searchResult[index]["plan_amount"]
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    )),
                    child: Text(
                      "${_searchResult[index]['plan_network']} ${_searchResult[index]['plan']} ${_searchResult[index]['plan_type']}   -   ?${_searchResult[index]['plan_amount']} - ${_searchResult[index]['month_validate']}  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: widget.plan?.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pop(context, {
                      "text":
                          "${widget.plan?[index]['plan_network']} ${widget.plan?[index]['plan']} ${widget.plan?[index]['plan_type']} ${widget.plan?[index]['plan_amount']} ${widget.plan?[index]['month_validate']}  ",
                      "value": "${widget.plan?[index]['id']}",
                      "amount_to_pay": widget.plan![index]["plan_amount"]
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 18, 15, 18),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    )),
                    child: Text(
                      "${widget.plan?[index]['plan_network']} ${widget.plan?[index]['plan']} ${widget.plan?[index]['plan_type']} ${widget.plan?[index]['plan_amount']}  ${widget.plan?[index]['month_validate']}  ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
