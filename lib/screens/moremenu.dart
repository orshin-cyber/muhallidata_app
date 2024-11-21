import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreMenu extends StatefulWidget {
  // const MoreMenu({ Key? key }) : super(key: key);

  @override
  _MoreMenuState createState() => _MoreMenuState();
}

class _MoreMenuState extends State<MoreMenu> {
  List<dynamic> services = [
    {
      "name": "Buy Data",
      "route": "/datanet",
      "icon": "icons/general/linear/global.svg"
    },
    // {
    //   "name": "Buy Data Coupon ",
    //   "route": "/datacoupon",
    //   "icon": "icons/general/linear/password-check.svg"
    // },
    // {
    //   "name": "Buy Data Card ",
    //   "route": "/datacard",
    //   "icon": "icons/general/linear/password-check.svg"
    // },
    {
      "name": "Buy Airtime",
      "route": "/airtimenet",
      "icon": "icons/general/linear/mobile.svg"
    },
    {
      "name": "Cable Tv",
      "route": "/cablename",
      "icon": "icons/general/linear/monitor.svg"
    },
    {
      "name": "Electricity Bill Payment",
      "route": "/bill",
      "icon": "icons/general/linear/lamp-charge.svg"
    },
    {
      "name": "Recharge Pin",
      "route": "/recharge",
      "icon": "icons/general/linear/password-check.svg"
    },
    {
      "name": "Education Pin",
      "route": "/ResultChecker",
      "icon": "icons/general/linear/book.svg"
    },
    {
      "name": "Bulk sms",
      "route": "/bulksms",
      "icon": "icons/general/linear/messages.svg",
      "png": "icons/bulksms.png"
    },
    {
      "name": "Airtime to cash",
      "route": "/airtimefundin",
      "icon": "icons/general/linear/refresh-circle.svg"
    },

    {
      "name": "My Referals",
      "route": "/referal",
      "icon": "icons/general/linear/people.svg"
    },
    {
      "name": "Bonus",
      "route": "/bonus",
      "icon": "icons/general/linear/empty-wallet-add.svg"
    },
    // {"name": "Withdraw", "route": "/withdraw", "icon": Icons.credit_card},

    //  {"name": "Transfer", "route": "/transfer", "icon":  "assets/money-transfer.png"},
    // {
    //   "name": "Transfer",
    //   "route": "/transfer",
    //   "icon": "icons/general/linear/repeat.svg"
    // },
    {
      "name": "Settings",
      "route": "/setting",
      "icon": "icons/general/linear/setting-1.svg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                ListTile(
                  minLeadingWidth: 0,
                  minVerticalPadding: 20,
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    height: 42,
                    width: 42,
                    child: SvgPicture.asset(
                      services[index]["icon"],
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff0340cf),
                        borderRadius: BorderRadius.circular(5)),
                  ),

                  // Image.asset(services[index]["icon"],height: 30,),
                  title: Text("${services[index]["name"]}",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 16,
                            color: Color(0xff1B1B1B),
                            fontWeight: FontWeight.w500),
                      )),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed("${services[index]['route']}");
                  },

                  trailing: SvgPicture.asset(
                    "icons/trailing.svg",
                    color: Color(0xff0340cf),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
