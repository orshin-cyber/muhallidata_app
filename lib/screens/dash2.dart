import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:muhallidata/airtime_funding_history.dart';
import 'package:muhallidata/airtimehistory.dart';
import 'package:muhallidata/billhistory.dart';
import 'package:muhallidata/cablehistory.dart';
import 'package:muhallidata/datahistory.dart';
import 'package:muhallidata/recharge_history.dart';
import 'package:muhallidata/result_history.dart';
import 'package:muhallidata/withdrawhistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'animation.dart';
import 'login.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NewDashboard extends StatefulWidget {
  bool? isupgrade;

  @override
  _NewDashboardState createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard> {
  String username = '';
  String email = '';
  String balance = "0";
  String bonus = "0";
  String alert = '';
  String user_type = '';
  String? gmail;
  String? whatsapp_group_link;
  String? support_phone_number;
  String? address;
  int page = 0;
  String pin = '';
  String notification = '';
  List<dynamic> account = [];
  bool _is_history_Loading = false;
  List wallethistory = [];
  var f = NumberFormat("###,###.00#", "en_US");
  final GlobalKey<ScaffoldState> _scaffoldstate = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  bool showbalance = false;
  AppUpdateInfo? _updateInfo;
  bool _flexibleUpdateAvailable = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  TextEditingController producttypesController = TextEditingController();

  bool homepage = true;

  List banksColors = [
    [
      Color.fromRGBO(77, 77, 76, 1),
      Color.fromRGBO(0, 0, 0, 1),
    ],
    [
      Color.fromRGBO(255, 123, 0, 1),
      Color.fromRGBO(255, 162, 0, 1),
    ],
    [
      Color.fromRGBO(0, 128, 255, 1),
      Color.fromRGBO(12, 2, 157, 1),
    ],
    [
      Color.fromRGBO(242, 7, 107, 1),
      Color.fromRGBO(255, 23, 23, 1),
    ],
    [
      Color.fromARGB(220, 2, 19, 115),
      Color.fromARGB(243, 18, 3, 84),
    ],
  ];
  List top = [
    {
      "logo": "assets/mtn.jpeg",
      "name": "MTN",
      "id": 1,
    },
    {
      "logo": "assets/9mobile.jpeg",
      "name": "9MOBILE",
      "id": 3,
    },
    {
      "logo": "assets/airtel.jpeg",
      "name": "AIRTEL",
      "id": 4,
    },
    {
      "logo": "assets/glo.jpg",
      "name": "GLO",
      "id": 2,
    },
    {
      "logo": "assets/gotv.jpeg",
      "name": "GOTV",
      "id": 1,
    },
    {
      "logo": "assets/dstv.jpeg",
      "name": "DSTV",
      "id": 2,
    },
  ];

  List<dynamic> banners = [];

  List<dynamic> contactOption = [
    {
      "route": 'tel:+2348103101065',
      "name": "Call 2348103101065",
      "logo": "assets/cta-phone-call.png"
    },
    {
      "route": "https://api.whatsapp.com/send/?phone=+2348103101065",
      "name": "Whatsapp",
      "logo": "assets/WhatsApp_icon.png"
    },
    // {"route": "", "name": "Telegram", "logo": "assets/telegram-512.webp"},
    {
      "route":
          "mailto:Gladtidingsbashir@gmail.com?subject=Complain about transaction&body=New%20plugin",
      "name": "E-Mail",
      "logo": "assets/mail.png"
    },
  ];

  List<dynamic> servicelist = [
    {
      "name": "Buy Data",
      "route": "/datanet",
      "icon": "icons/general/linear/global.svg"
    },
    {
      "name": "Buy Airtime",
      "route": "/airtimenet",
      "icon": "icons/general/linear/mobile.svg"
    },
    {
      "name": "Cabe Tv",
      "route": "/cablename",
      "icon": "icons/general/linear/monitor.svg",
    },
    {
      "name": "More Service",
      "route": "/more",
      "icon": "icons/general/linear/more.svg",
    },
  ];

  List<dynamic> homemenu = [
    {
      "name": "Fund  Wallet",
      "route": "/fundWallet",
      "icon": "icons/general/linear/empty-wallet-add.svg"
    },
    // {
    //   "name": "Transfer  ",
    //   "route": "/transfer",
    //   "icon": "icons/general/linear/repeat.svg"
    // },
    {
      "name": "Transactions ",
      "route": "/transactions",
      "icon": "icons/general/linear/card-receive.svg",
    },
    {
      "name": "Wallet Summary",
      "route": "/wallet",
      "icon": "icons/general/linear/empty-wallet-add.svg",
    },
  ];

  // List<dynamic> services = [
  //   {
  //     "name": "Buy Data",
  //     "route": "/datanet",
  //     "icon": "icons/general/linear/global.svg"
  //   },

  //   {
  //     "name": "Buy Airtime",
  //     "route": "/airtimenet",
  //     "icon": "icons/general/linear/mobile.svg"
  //   },
  //   {
  //     "name": "Cable Tv",
  //     "route": "/cablename",
  //     "icon": "icons/general/linear/monitor.svg"
  //   },
  //   {
  //     "name": " Bill Payment",
  //     "route": "/bill",
  //     "icon": "icons/general/linear/lamp-charge.svg"
  //   },
  //   {
  //     "name": "Recharge Card",
  //     "route": "/recharge",
  //     "icon": "icons/general/linear/password-check.svg"
  //   },

  //   {
  //     "name": "Education Pin",
  //     "route": "/ResultChecker",
  //     "icon": "icons/general/linear/book.svg"
  //   },

  //   {
  //     "name": "Refer & Earn",
  //     "route": "/referal",
  //     "icon": "icons/general/linear/people.svg"
  //   },
  //   {
  //     "name": "Bulk sms",
  //     "route": "/bulksms",
  //     "icon": "icons/general/linear/messages.svg",
  //     "png": "icons/bulksms.png"
  //   },
  //   {
  //     "name": "Airtime to cash",
  //     "route": "/airtimefundin",
  //     "icon": "icons/general/linear/refresh-circle.svg"
  //   },
  //   {
  //     "name": "Bonus",
  //     "route": "/bonus",
  //     "icon": "icons/general/linear/empty-wallet-add.svg"
  //   },

  //   // {
  //   //   "name": "Upgrade",
  //   //   "route": "/upgrade",
  //   //   "icon": "icons/general/linear/people.svg"
  //   // },

  //   // {
  //   //   "name": "Buy Data",
  //   //   "route": "/datanet",
  //   //   "icon": "assets/wireless-internet.png",
  //   //   "png":"icons/data2.png"
  //   // },
  //   // {
  //   //   "name": "Buy Airtime",
  //   //   "route": "/airtimenet",
  //   //   "icon": "assets/transfer-money.png",
  //   //   "png":"icons/data.png"
  //   // },
  //   // {
  //   //   "name": "Cable Tv",
  //   //   "route": "/cablename",
  //   //   "icon": "assets/tv-monitor.png",
  //   //   "png":"icons/cable.png"
  //   // },
  //   // {"name": "Bill Payment", "route": "/bill", "icon": "assets/idea.png","png":"icons/utility.png"},

  //   // {"name": "My Referals", "route": "/referal", "icon": Icons.person_add},
  //   // {"name": "Bonus", "route": "/bonus", "icon": Icons.account_balance_wallet},
  //   // {"name": "Withdraw", "route": "/withdraw", "icon": Icons.credit_card},
  //   // {
  //   //   "name": "Airtime to cash",
  //   //   "route": "/airtimefundin",
  //   //   "icon": Icons.track_changes
  //   // },
  //   // {"name": "Bulk SMS", "route": "/sms", "icon": Icons.message},
  //   // {
  //   //   "name": "Transfer",
  //   //   "route": "/transfer",
  //   //   "icon": "assets/money-transfer.png",
  //   //   "png":"icons/bonus.png"
  //   // },
  //   // {"name": "More", "route": "/more", "icon": "assets/more.png"},
  //   // {"name": "Recharge Pin", "route": "/recharge", "icon": Icons.print},
  //   // {"name": "Education Pin", "route": "/ResultChecker", "icon": Icons.book},
  //   // {"name": "Upgrade", "route": "/upgrade", "icon": Icons.upgrade},
  // ];

  List<dynamic> services = [
    {
      "name": "Buy Data",
      "img": "assets/global.jpg",
      "route": "/datanet",
      "icon": Icons.wifi_rounded
    },
    {
      "name": "Buy Airtime",
      "img": "assets/mobile.png",
      "route": "/airtimenet",
      "icon": Icons.phone_iphone
    },
    {
      "name": "Cable Tv",
      "img": "assets/monitor.png",
      "route": "/cablename",
      "icon": Icons.tv
    },
    {
      "name": "Bill Payment",
      "img": "assets/idea.png",
      "route": "/bill",
      "icon": Icons.lightbulb
    },
    {
      "name": "Education Pin",
      "img": "assets/education.png",
      "route": "/ResultChecker",
      "icon": Icons.book
    },
    // {
    //   "name": "Buy Data Coupon",
    //   "img": "images/services/coupon.png",
    //   "route": "/datacoupon",
    //   "icon": Icons.print
    // },
    {
      "name": "Bonus",
      "img": "assets/empty-wallet-add.png",
      "route": "/bonus",
      "icon": Icons.account_balance_wallet
    },
    {
      "name": "My Referals",
      "img": "assets/transfer-money.png",
      "route": "/referal",
      "icon": Icons.person_add
    },
    // {"name": "Withdraw", "img" : "images/image.png", "route": "/withdraw", "icon": Icons.credit_card},
    {
      "name": "Airtime to cash",
      "route": "/airtimefundin",
      "img": "assets/refresh-circle.png",
      "icon": Icons.track_changes
    },
    {
      "name": "Bulk SMS",
      "img": "assets/sms-blue.png",
      "route": "/bulksms",
      "icon": Icons.mail
    },
    // {
    //   "name": "Transfer",
    //   "img": "images/traf.png",
    //   "route": "/transfer",
    //   "icon": Icons.send
    // },
    {
      "name": "Recharge Pin",
      "img": "assets/password-check.png",
      "route": "/recharge",
      "icon": Icons.print
    },
    // {"name": "Upgrade", "img" : "images/image.png", "route": "/upgrade", "icon": Icons.upgrade},
  ];

  List<Map> producttypes = [
    {"name": "Data", "value": 0},
    {"name": "Airtime", "value": 1},
    {"name": "Cable Sub", "value": 2},
    {"name": "Electricity", "value": 3},
    {"name": "Withdraw", "value": 4},
    {"name": "Airtime 2 Cash", "value": 5},
    {"name": "Exam Pin", "value": 6},
    {"name": "Recharge Card Printing", "value": 7},
  ];

  List<dynamic> transactions = [
    {
      "name": 'MTN NG',
      "desc": "Airtime Topup  4:12 PM",
      "logo": "assets/cta-phone-call.png",
      "amount": "N800"
    },
    {
      "name": 'MTN NG',
      "desc": "Airtime Topup  4:12 PM",
      "logo": "assets/cta-phone-call.png",
      "amount": "N800"
    },
    {
      "name": 'MTN NG',
      "desc": "Airtime Topup  4:12 PM",
      "logo": "assets/cta-phone-call.png",
      "amount": "N800"
    },
    {
      "name": 'MTN NG',
      "desc": "Airtime Topup  4:12 PM",
      "logo": "assets/cta-phone-call.png",
      "amount": "N800"
    },
  ];

  List products_pages = [
    DataHListView(),
    AirtimeHListView(),
    CableHListView(),
    BillHListView(),
    WithdrawViewListView(),
    Airtime_fundingHListView(),
    ResultHListView(),
    RechargeHListView(),
  ];

  @override
  void initState() {
    checkForUpdate();
    filldetails();
    walletupdate1();
    fetchhistory();
    super.initState();

    call_Alert();
  }

  // Current selected
  int current = 0;
  int current2 = 0;
  // Handle Indicator
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  // Handle Indicator
  List<T> map2<T>(List list, Function handler) {
    List<T> result2 = [];
    for (var i = 0; i < list.length; i++) {
      result2.add(handler(i, list[i]));
    }
    return result2;
  }

  List<Widget> bannerwidget() {
    return banners.map((bannerobject) {
      return InkWell(
        onTap: () {
          Navigator.of(context).pushNamed("${bannerobject['route']}");
        },
        child: Container(
          margin: EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            image: DecorationImage(
              image: NetworkImage(
                  "https://muhallidata.com/${bannerobject['banner']}"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }).toList();
  }

  setlogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully",
        backgroundColor: Colors.green,
        duration: Toast.lengthShort,
        gravity: Toast.center);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
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

      print(response.body);
      if (response.statusCode == 200) {
        if (this.mounted) {
          setState(() {
            wallethistory = jsonDecode(response.body)["results"] as List;
            _is_history_Loading = false;
          });

          print(wallethistory);
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
      setState(() {
        _is_history_Loading = false;
      });

      Toast.show("Oops ,request is taking much time to response, please retry",
          backgroundColor: Colors.red,
          duration: Toast.lengthShort,
          gravity: Toast.bottom);
    } on Error catch (e) {
      setState(() {
        _is_history_Loading = false;
      });

      Toast.show("Oops ,Unexpected error occured",
          backgroundColor: Colors.red,
          duration: Toast.lengthShort,
          gravity: Toast.bottom);
    }
    ;
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {});
    }).catchError((e) {
      print(e.toString());
    });
  }

  void _showError(dynamic exception) {
    // print(exception.toString());
    // _scaffoldKey.currentState
    //     .showSnackBar(SnackBar(content: Text(exception.toString())));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(exception.toString()),
        duration: Duration(milliseconds: 300),
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  int _selectedIndex = 0;
  Future<dynamic> filldetails() async {
    producttypesController.text = "DATA";
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = pref.getString("username")!;
        user_type = pref.getString("user_type")!;
        email = pref.getString("email")!;
        balance = pref.getString("walletb")!;

        bonus = pref.getString("bonusb")!;
        alert = pref.getString("alert")!;
        notification = pref.getString("notification")!;
        pin = pref.getString("pin")!;
        account = json.decode(pref.getString("account")!);
        gmail = pref.getString("gmail");
        support_phone_number = pref.getString("support_phone_number");
        whatsapp_group_link = pref.getString("whatsapp_group_link");
        showbalance = pref.getBool("showbalance")! ? true : false;
      });
    }
  }

  Widget _social_Account() {
    return SpeedDial(
      // animatedIcon: AnimatedIcons.phone,
      // child: Icon(Icons.phone),
      child: Image.asset('assets/WhatsApp_icon.png',
          width: 50,
          height: 50), // Replace with the actual path to WhatsApp logo
      animatedIconTheme: IconThemeData(size: 25),
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 2 - WhatsApp Group
        SpeedDialChild(
          child: Icon(Icons.group),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
          onTap: () {
            _launchURL(
                '$whatsapp_group_link'); // Replace with your WhatsApp group link
          },
          label: 'WhatsApp Group',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: Colors.green,
        ),

        SpeedDialChild(
          child: Icon(Icons.phone),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () {
            _launchURL(
                'https://api.whatsapp.com/send?phone=$support_phone_number');
          },
          label: 'WhatsApp',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 16.0,
          ),
          labelBackgroundColor: Colors.green,
        ),
      ],
    );
  }

  Future<dynamic> call_Alert() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // print(alert != null);

    if (alert.isNotEmpty) {
      _showMyDialog();
      setState(() {
        pref.setString("alert", '');
      });
    }
  }

  Future<void> _showUPDATEDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update App?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('A new version of muhallidata app available on playstore'),
                SizedBox(
                  height: 10,
                ),
                Text('Would you like to update?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('IGNORE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('LATER'),
              onPressed: () {
                InAppUpdate.startFlexibleUpdate().then((_) {
                  setState(() {
                    _flexibleUpdateAvailable = true;
                  });
                }).catchError((e) => _showError(e));
              },
            ),
            ElevatedButton(
              child: Text('UPDATE NOW'),
              onPressed: () {
                InAppUpdate.performImmediateUpdate()
                    .catchError((e) => _showError(e));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'We Provide Awesome Services at muhallidata.com',
      text:
          'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
      linkUrl: 'https://www.muhallidata.com?referal=$username',
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert Notification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Dear $username'),
                SizedBox(
                  height: 10,
                ),
                Text('$alert'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> walletupdate1() async {
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
    if (this.mounted) {
      setState(() {
        pref.setString("walletb", resJson["user"]["wallet_balance"]);
        pref.setString("bonusb", resJson["user"]["bonus_balance"]);
        balance = pref.getString("walletb")!;
        bonus = pref.getString("bonusb")!;
        banners = json.decode(pref.getString("banners")!);
        pref.setString("whatsapp_group_link",
            resJson["webconfig"]["whatsapp_group_link"] ?? '');
        pref.setString("support_phone_number",
            resJson["webconfig"]["support_phone_number"] ?? '');
        pref.setString("gmail", resJson["webconfig"]["gmail"] ?? '');
        pref.setString("account",
            json.encode(resJson["user"]["bank_accounts"]["accounts"]));
        account = json.decode(pref.getString("account") ?? '[]');

        pref.setString("pin", resJson["user"]["pin"]);

        pin = pref.getString("pin")!;
      });
    }
  }

  Future<dynamic> HideWallet() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setBool("showbalance", !showbalance);

    setState(() {
      showbalance = !showbalance;
    });
  }

  Future<dynamic> walletupdate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String url = 'https://www.muhallidata.com/api/user/';
    setState(() {
      _isLoading = true;
    });

    Response res = await get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Token ${pref.getString("token")}'
      },
    );
    Map resJson = json.decode(res.body);
    print(resJson);
    setState(() {
      pref.setString("walletb", resJson["user"]["wallet_balance"]);
      pref.setString("bonusb", resJson["user"]["bonus_balance"]);
      balance = pref.getString("walletb")!;
      bonus = pref.getString("bonusb")!;
      banners = json.decode(pref.getString("banners")!);
      pref.setString("whatsapp_group_link",
          resJson["webconfig"]["whatsapp_group_link"] ?? '');
      pref.setString("support_phone_number",
          resJson["webconfig"]["support_phone_number"] ?? '');
      pref.setString("gmail", resJson["webconfig"]["gmail"] ?? '');
      pref.setString(
          "account", json.encode(resJson["user"]["bank_accounts"]["accounts"]));
      account = json.decode(pref.getString("account") ?? '[]');

      _isLoading = false;
      // Toast.show("Wallet update successfully",
      //     backgroundColor: Colors.green,
      //     duration: Toast.lengthShort,
      //     gravity: Toast.bottom);
    });
  }

  Future<void> contactDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Contact our Support Team Via'),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
                children: contactOption
                    .map(
                      (opt) => ListTile(
                        minLeadingWidth: 0,
                        minVerticalPadding: 0,
                        leading: Image.asset(
                          opt["logo"],
                          height: 30,
                        ),
                        title: Text(
                          "${opt["name"]}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 150, 146, 146)),
                        ),
                        onTap: () {
                          _launchURL(opt['route']);
                        },
                      ),
                    )
                    .toList()),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var phonesize = MediaQuery.of(context).size;
    // bool dashboard = Provider.of<Dasboardcheck>(context).getDashboard;
    String charge;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      key: _scaffoldstate,
      drawer: MyAnimation(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Duration(seconds: 3), () {
                  walletupdate1();
                  walletupdate();
                  filldetails();
                  // Fluttertoast.showToast(
                  //     msg: "Wallet update successfully",
                  //     backgroundColor: Colors.green,
                  //     toastLength: Toast.LENGTH_SHORT,
                  //     gravity: ToastGravity.BOTTOM);
                });
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: Stack(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  color: Color(0xff006eff),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(30),
                                      bottomRight: Radius.circular(30))),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage('images/Pattern.png'),
                                          fit: BoxFit.fill,
                                        ),
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(30),
                                            bottomRight: Radius.circular(30))),
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 3, 36, 78)
                                              .withOpacity(0.3),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(30),
                                              bottomRight:
                                                  Radius.circular(30))),
                                      child: SizedBox()),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SafeArea(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ClipOval(
                                                child: Image.asset(
                                              "assets/hbs.jpg",
                                              height: phonesize.height * 0.05,
                                              width: phonesize.height * 0.05,
                                              fit: BoxFit.cover,
                                            )),
                                            SizedBox(
                                                width: phonesize.width * 0.01),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Welcome back!",
                                                    style: TextStyle(
                                                        fontSize:
                                                            phonesize.height /
                                                                    phonesize
                                                                        .width +
                                                                10,
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                  Text(
                                                    "$username",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ])
                                          ],
                                        ),
                                        InkWell(
                                          onTap: () {
                                            _scaffoldstate.currentState!
                                                .openDrawer();
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/drawer_icon.svg',
                                            color: Colors.white,
                                          ),
                                        )
                                      ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 35),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Available Balance",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0.1,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                showbalance
                                                    ? "$balance"
                                                    : "*****",
                                                style: TextStyle(
                                                    fontSize: phonesize.height *
                                                        0.045,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              _isLoading
                                                  ? Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: () {
                                                        walletupdate();
                                                        filldetails();
                                                      },
                                                      icon: Icon(Icons.refresh),
                                                      color: Colors.white,
                                                      iconSize: 30,
                                                    )
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences pref =
                                              await SharedPreferences
                                                  .getInstance();
                                          setState(() {
                                            showbalance = !showbalance;
                                            pref.setBool(
                                                "showwallet", !showbalance);
                                          });
                                        },
                                        child: Icon(
                                          showbalance
                                              ? Icons.visibility_off
                                              : Icons.visibility_outlined,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Referal Bonus",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  letterSpacing: 0.1,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          Text(
                                            "$bonus",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Current Package",
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  letterSpacing: 0.1,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "$user_type",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                /*
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    child: Container(
                                        padding: EdgeInsets.all(0),
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          // gradient: LinearGradient(
                                          //   colors: [
                                          //     Color.fromRGBO(255, 98, 0, 1),
                                          //     Color.fromRGBO(166, 0, 0, 1)
                                          //   ],
                                          //   begin: Alignment(-1.0, -1),
                                          //   end: Alignment(-1.0, 1),
                                          // ),
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed('/fundWallet');
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.credit_card,
                                                          size: phonesize.height * 0.030,
                                                          color: Colors.black,
                                                        ))),
                                                  ),
                                                  SizedBox(
                                                      height: phonesize.height * 0.008),
                                                  Text(
                                                    "Fund Wallet",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed("/history");
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.history_rounded,
                                                          size: phonesize.height * 0.030,
                                                          color: Colors.black,
                                                        ))),
                                                  ),
                                                  SizedBox(
                                                      height: phonesize.height * 0.008),
                                                  Text(
                                                    "Transactions",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      contactDialog();
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.message,
                                                          size: phonesize.height * 0.030,
                                                          color: Colors.black,
                                                        ))),
                                                  ),
                                                  SizedBox(
                                                      height: phonesize.height * 0.008),
                                                  Text(
                                                    "Contact",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed("/setting");
                                                    },
                                                    child: Container(
                                                        padding: EdgeInsets.all(6),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                        ),
                                                        child: Center(
                                                            child: Icon(
                                                          Icons.dashboard_customize,
                                                          size: phonesize.height * 0.030,
                                                          color: Colors.black,
                                                        ))),
                                                  ),
                                                  SizedBox(
                                                      height: phonesize.height * 0.008),
                                                  Text(
                                                    "More",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: "Poppins",
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                ]),
                                          ],
                                        )
                                    )
                                ),
                                */
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        margin: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: homemenu
                              .map((menu) => InkWell(
                                    onTap: () {
                                      if (menu["name"] == "Contact Us") {
                                        contactDialog();
                                      } else {
                                        Navigator.of(context)
                                            .pushNamed(menu["route"]);
                                      }
                                    },
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            height: 42,
                                            width: 42,
                                            child: SvgPicture.asset(
                                              menu["icon"],
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                                color: Color(0xFF2703CA),
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(menu["name"],
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff1B1B1B),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ))
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )),
                    SizedBox(height: 5),
                    // Container(
                    //   margin: EdgeInsets.only(
                    //       left: 10, top: 0, bottom: 13, right: 10),
                    //   padding: EdgeInsets.only(
                    //       left: 12, top: 12, bottom: 12, right: 12),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     gradient: LinearGradient(
                    //       colors: [Color(0xff006eff), Color(0xff006eff)],
                    //       begin: Alignment(-1.0, -1),
                    //       end: Alignment(1.0, 1),
                    //     ),
                    //   ),
                    //   child: Center(
                    //     child: Text(
                    //       "Generate Virtual Account Number",
                    //       style: GoogleFonts.inter(
                    //         fontSize: 14,
                    //         fontWeight: FontWeight.w600,
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // )
                    // :
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).pushNamed('/cbnupdate');
                        Navigator.of(context).pushNamed("/reservedAccount");
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                            left: 10, top: 0, bottom: 13, right: 10),
                        padding: EdgeInsets.only(
                            left: 12, top: 12, bottom: 12, right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [Color(0xff006eff), Color(0xff006eff)],
                            begin: Alignment(-1.0, -1),
                            end: Alignment(1.0, 1),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Generate Virtual Bank",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 0),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        height:
                            account != null && account.length >= 1 ? 122 : 0,
                        child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            children: account != null && account.length >= 1
                                ? account
                                    .map(
                                      (index) => new Container(
                                        margin: EdgeInsets.only(right: 10),
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                            colors: banksColors[3],
                                            // colors: [
                                            //   Color.fromRGBO(5, 179, 17, 1),
                                            //   Color.fromRGBO(5, 77, 1, 1),
                                            // ],
                                            begin: Alignment(-1.0, -1),
                                            end: Alignment(1.0, 1),
                                          ),
                                        ),
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              child: SvgPicture.asset(
                                                  "assets/svg/ellipse_top_pink.svg",
                                                  height: 28,
                                                  color: Colors.white),
                                            ),
                                            Positioned(
                                              top: -1,
                                              right: 0,
                                              child: SvgPicture.asset(
                                                  "assets/svg/ellipse_bottom_pink.svg",
                                                  height: 28,
                                                  color: Colors.white),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: SvgPicture.asset(
                                                  "assets/svg/ellipse_bottom_pink.svg",
                                                  height: 35,
                                                  color: Colors.white),
                                            ),
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
                                                "${index["accountNumber"]}",
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
                                                              "${index["accountNumber"]}"));
                                                  Toast.show(
                                                      'Account number copied.',
                                                      backgroundColor:
                                                          Colors.indigo,
                                                      duration:
                                                          Toast.lengthShort,
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
                                                index["bankName"] ==
                                                        "9Payment Service Bank"
                                                    ? '₦35 charge'
                                                    : '₦50 charge'
                                                        '',
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
                                                "${index["bankName"]}",
                                                style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList()
                                : []),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      // shrinkWrap: true,
                      // physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        /*
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TOP PROVIDERS",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: top.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            if (top[index]["name"] ==
                                                    "GOTV" ||
                                                top[index]["name"] ==
                                                    "DSTV") {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          CableS(
                                                              cable: top[
                                                                  index])));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) =>
                                                          BuyDataAndAirtime(
                                                              network: top[
                                                                  index])));
                                            }
                                          },
                                          child: Container(
                                              padding: EdgeInsets.all(8),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundColor:
                                                        Colors.indigo
                                                            .shade100,
                                                    radius: 30.0,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          AssetImage(top[
                                                                  index]
                                                              ["logo"]),
                                                      radius: 25.0,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  Text(
                                                    top[index]["name"],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color
                                                            .fromARGB(
                                                                255,
                                                                105,
                                                                102,
                                                                102),
                                                        fontWeight:
                                                            FontWeight
                                                                .w500),
                                                  ),
                                                ],
                                              )));
                                    },
                                  )),
                            ],
                          ),
                        ),
                        */

                        Divider(
                          thickness: 1.5,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 20, right: 20, bottom: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Quick Services",
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.w400),
                                  )),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/wallet');
                                },
                                child: Row(
                                  children: [
                                    // Text("View All",
                                    //     style: GoogleFonts.poppins(
                                    //       textStyle: TextStyle(
                                    //           fontSize: 14,
                                    //           color: Color(0xff000000),
                                    //           fontWeight:
                                    //               FontWeight.w400),
                                    //     )
                                    // ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    // SvgPicture.asset(
                                    //   "icons/viewall.svg",
                                    //   color: Color(0xFF2703CA),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width,
                            // padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            child: GridView.builder(
                              // padding: EdgeInsets.only(top: 10, bottom: 10),
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 2,
                              ),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        "${services[index]['route']}");
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            child: Image.asset(
                                              "${services[index]['img']}",
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.095,
                                            )),
                                        // Container(
                                        //   padding: EdgeInsets.all(10),
                                        //   decoration: BoxDecoration(
                                        //       color: Colors.red[900],
                                        //       borderRadius: BorderRadius.all(
                                        //         Radius.circular(10),
                                        //       )),
                                        //   child: Icon(
                                        //     services[index]['icon'],
                                        //     size: 25,
                                        //     color: Colors.white,
                                        //   ),
                                        // ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        //${services[index]['name']}
                                        Text("${services[index]['name']}",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700),
                                            ))
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )),

                        SizedBox(
                          height: 10,
                        ),
                        // banners.length >= 1
                        //     ? Container(
                        //         child: Column(
                        //           // shrinkWrap: true,
                        //           children: [
                        //             CarouselSlider(
                        //               items: bannerwidget(),
                        //               options: CarouselOptions(
                        //                 height: 120,
                        //                 enlargeCenterPage: true,
                        //                 pageSnapping: true,
                        //                 autoPlay: true,
                        //                 aspectRatio: 16 / 9,
                        //                 autoPlayCurve:
                        //                     Curves.fastOutSlowIn,
                        //                 enableInfiniteScroll: true,
                        //                 autoPlayAnimationDuration:
                        //                     Duration(milliseconds: 800),
                        //                 viewportFraction: 0.9,
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       )
                        //     : SizedBox(height: 0),
                        SizedBox(
                          height: 150,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //     appBar: AppBar(
    //       backgroundColor: Colors.white,
    //       elevation: 0,
    //       automaticallyImplyLeading: false,
    //       title: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               CircleAvatar(
    //                 // backgroundColor: Colors.orange[400],
    //                 radius: 16.0,
    //                 child: CircleAvatar(
    //                   backgroundImage: AssetImage('images/profile.jpeg'),
    //                 ),
    //               ),
    //               SizedBox(width: 10.0),
    //               Text(
    //                 "Hi, $username",
    //                 style: GoogleFonts.poppins(
    //                   textStyle: TextStyle(
    //                     fontSize: 14,
    //                     color: Colors.black,
    //                     fontWeight: FontWeight.w400,
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //           InkWell(
    //             onTap: () {
    //               _scaffoldstate.currentState!.openDrawer();
    //             },
    //             child: IconButton(
    //               icon: Icon(
    //                 Icons.apps,
    //                 size: 28,
    //               ),
    //               onPressed: () {
    //                 _scaffoldstate.currentState!.openDrawer();
    //               },
    //               color: Colors.black,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     backgroundColor: Colors.white,
    //     // appBar: AppBar(
    //     //   backgroundColor: Color(0xff0340cf),
    //     //   elevation: 0,
    //     // ),

    //     key: _scaffoldstate,
    //     drawer: MyAnimation(),
    //     body: SafeArea(
    //       child: RefreshIndicator(
    //         onRefresh: () {
    //           return Future.delayed(Duration(seconds: 3), () {
    //             walletupdate1();
    //             fetchhistory();
    //             // Toast.show("Wallet succefully updated", context,
    //             //     backgroundColor: Colors.black,
    //             //     duration: Toast.LENGTH_LONG,
    //             //     gravity: Toast.BOTTOM);
    //           });
    //         },
    //         child: ListView(
    //           children: [
    //             Container(
    //               margin: EdgeInsets.all(15),
    //               padding: EdgeInsets.fromLTRB(6, 5, 6, 6),
    //               height: 30,
    //               width: MediaQuery.of(context).size.width * 0.9,
    //               decoration: BoxDecoration(
    //                 color: Color(0xff0340cf),
    //                 borderRadius: BorderRadius.circular(15),
    //               ),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   // crossAxisAlignment:
    //                   //     CrossAxisAlignment.start,
    //                   Text("Referral bonus:",
    //                       style: GoogleFonts.poppins(
    //                         textStyle: TextStyle(
    //                             fontSize: 14,
    //                             color: Color(0xffffffff),
    //                             fontWeight: FontWeight.w600),
    //                       )),

    //                   SizedBox(
    //                     width: 20,
    //                   ),
    //                   Text(
    //                     "N${bonus}",
    //                     style: TextStyle(
    //                         fontSize: 14,
    //                         color: Color(0xffffffff),
    //                         fontWeight: FontWeight.w600),
    //                   )
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               margin: EdgeInsets.fromLTRB(15, 0, 15, 15),
    //               height: 160,
    //               width: MediaQuery.of(context).size.width * 0.9,
    //               decoration: BoxDecoration(
    //                 // image: DecorationImage(
    //                 //     image: AssetImage("images/abstract1ww.jpg"),
    //                 //     fit: BoxFit.cover),
    //                 borderRadius: BorderRadius.only(
    //                   // bottomLeft: Radius.circular(50.0),
    //                   bottomRight: Radius.circular(40.0),
    //                   topLeft: Radius.circular(40.0),
    //                 ),

    //                 // color: Color(0xff5c1963),
    //               ),
    //               child: Stack(
    //                 children: [
    //                   Container(
    //                     decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(15)),
    //                   ),
    //                   Container(
    //                     // decoration: BoxDecoration(
    //                     //   color: Color(0xff0340cf),
    //                     //   borderRadius: BorderRadius.circular(10),
    //                     //   image: DecorationImage(
    //                     //       image: AssetImage("images/abstr.jpg"),
    //                     //       fit: BoxFit.cover),
    //                     // ),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.only(
    //                         bottomRight: Radius.circular(40.0),
    //                         topLeft: Radius.circular(40.0),
    //                       ),
    //                       gradient: LinearGradient(
    //                         begin: FractionalOffset.topCenter,
    //                         end: FractionalOffset.bottomCenter,
    //                         colors: [
    //                           Color(0xff0340cf),
    //                           // Color.fromARGB(255, 157, 52, 69),
    //                           Color(0xff0340cf),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                   Container(
    //                       padding: EdgeInsets.all(10),
    //                       margin: EdgeInsets.fromLTRB(2, 3, 2, 2),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           Row(
    //                             mainAxisAlignment:
    //                                 MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Row(
    //                                 // crossAxisAlignment:
    //                                 //     CrossAxisAlignment.start,
    //                                 mainAxisAlignment: MainAxisAlignment.start,
    //                                 children: [
    //                                   showbalance
    //                                       ? Text(
    //                                           "",
    //                                           style: TextStyle(
    //                                               fontSize: 20,
    //                                               color: Color(0xffffffff),
    //                                               fontWeight: FontWeight.w600),
    //                                         )
    //                                       : SizedBox(),
    //                                   Text(
    //                                       showbalance
    //                                           ? "N$balance"
    //                                           : "********",
    //                                       style: GoogleFonts.poppins(
    //                                         textStyle: TextStyle(
    //                                             fontSize: 20,
    //                                             color: Color(0xffffffff),
    //                                             fontWeight: FontWeight.w600),
    //                                       )),
    //                                   SizedBox(
    //                                     width: 20,
    //                                   ),
    //                                   showbalance
    //                                       ? InkWell(
    //                                           onTap: () {
    //                                             HideWallet();
    //                                           },
    //                                           child: SvgPicture.asset(
    //                                             "icons/Password-Presented hide.svg",
    //                                             color: Colors.white,
    //                                           ),
    //                                         )
    //                                       : InkWell(
    //                                           onTap: () {
    //                                             HideWallet();
    //                                           },
    //                                           child: SvgPicture.asset(
    //                                             "icons/Password-Presented see.svg",
    //                                             color: Colors.white,
    //                                           ),
    //                                         ),
    //                                 ],
    //                               ),
    //                               Column(
    //                                 crossAxisAlignment: CrossAxisAlignment.end,
    //                                 children: [
    //                                   Text(
    //                                     "package",
    //                                     style: TextStyle(
    //                                         fontSize: 12,
    //                                         color: Color(0xffffffff),
    //                                         fontWeight: FontWeight.w600),
    //                                   ),
    //                                   Text(
    //                                     "$user_type",
    //                                     style: TextStyle(
    //                                         fontSize: 14,
    //                                         color: Color(0xffffffff),
    //                                         fontWeight: FontWeight.w600),
    //                                   ),
    //                                 ],
    //                               ),
    //                             ],
    //                           ),
    //                           SizedBox(
    //                             height: 15,
    //                           ),
    //                           SizedBox(
    //                             height: 35,
    //                           ),
    //                           Container(
    //                             // margin: EdgeInsets.all(10),
    //                             child: Row(
    //                               mainAxisAlignment:
    //                                   MainAxisAlignment.spaceAround,
    //                               children: homemenu
    //                                   .map((menu) => InkWell(
    //                                         onTap: () {
    //                                           Navigator.of(context)
    //                                               .pushNamed(menu["route"]);
    //                                         },
    //                                         child: Container(
    //                                           child: Column(
    //                                             children: [
    //                                               Container(
    //                                                 padding: EdgeInsets.all(10),
    //                                                 height: 35,
    //                                                 width: 35,
    //                                                 child: SvgPicture.asset(
    //                                                   menu["icon"],
    //                                                   color: Colors.white,
    //                                                 ),
    //                                                 decoration: BoxDecoration(
    //                                                     color: Color.fromARGB(
    //                                                             255,
    //                                                             85,
    //                                                             150,
    //                                                             152)
    //                                                         .withOpacity(0.3),
    //                                                     borderRadius:
    //                                                         BorderRadius
    //                                                             .circular(10)),
    //                                               ),
    //                                               SizedBox(
    //                                                 height: 2,
    //                                               ),
    //                                               Text(menu["name"],
    //                                                   style:
    //                                                       GoogleFonts.poppins(
    //                                                     textStyle: TextStyle(
    //                                                         fontSize: 8,
    //                                                         color: Colors.white,
    //                                                         fontWeight:
    //                                                             FontWeight
    //                                                                 .w400),
    //                                                   ))
    //                                             ],
    //                                           ),
    //                                         ),
    //                                       ))
    //                                   .toList(),
    //                             ),
    //                           ),
    //                         ],
    //                       )),
    //                 ],
    //               ),
    //             ),
    //             SizedBox(
    //               height: 7,
    //             ),

    //             InkWell(
    //               onTap: () async {
    //                 Navigator.of(context).pushNamed("/reservedAccount");
    //               },
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Container(
    //                   width: MediaQuery.of(context).size.width,
    //                   padding: EdgeInsets.symmetric(vertical: 15),
    //                   alignment: Alignment.center,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(15)),
    //                     color: Color(0xff0340cf),
    //                     boxShadow: <BoxShadow>[
    //                       BoxShadow(
    //                           color: Colors.grey.shade200,
    //                           offset: Offset(2, 4),
    //                           blurRadius: 5,
    //                           spreadRadius: 2)
    //                     ],
    //                   ),
    //                   child: Text(
    //                     'Generate Virtual Account',
    //                     style: TextStyle(fontSize: 15, color: Colors.white),
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 10,
    //             ),

    //             Container(
    //                 // margin: EdgeInsets.all(10),
    //                 child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: servicelist
    //                   .map((menu) => InkWell(
    //                         onTap: () {
    //                           Navigator.of(context).pushNamed(menu["route"]);
    //                         },
    //                         child: Container(
    //                           child: Column(
    //                             children: [
    //                               Container(
    //                                 padding: EdgeInsets.all(10),
    //                                 height: 42,
    //                                 width: 42,
    //                                 child: SvgPicture.asset(
    //                                   menu["icon"],
    //                                   color: Colors.white,
    //                                 ),
    //                                 decoration: BoxDecoration(
    //                                     color: Color(0xff0340cf),
    //                                     borderRadius:
    //                                         BorderRadius.circular(40)),
    //                               ),
    //                               SizedBox(
    //                                 height: 5,
    //                               ),
    //                               Text(menu["name"],
    //                                   style: GoogleFonts.poppins(
    //                                     textStyle: TextStyle(
    //                                         fontSize: 10,
    //                                         color: Colors.black,
    //                                         fontWeight: FontWeight.w400),
    //                                   ))
    //                             ],
    //                           ),
    //                         ),
    //                       ))
    //                   .toList(),
    //             )),
    //             SizedBox(
    //               height: 7,
    //             ),
    //             Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //               child: Container(
    //                 height: account.isNotEmpty && account.length >= 1 ? 122 : 0,
    //                 child: ListView(
    //                     scrollDirection: Axis.horizontal,
    //                     shrinkWrap: true,
    //                     children: account.isNotEmpty && account.length >= 1
    //                         ? account
    //                             .map(
    //                               (index) => new Container(
    //                                 margin: EdgeInsets.only(right: 10),
    //                                 height: 90,
    //                                 width:
    //                                     MediaQuery.of(context).size.width * 0.9,
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(10),
    //                                   color: Color(0xff0340cf),
    //                                 ),
    //                                 child: Stack(
    //                                   children: <Widget>[
    //                                     Positioned(
    //                                       child: SvgPicture.asset(
    //                                           "assets/svg/ellipse_top_pink.svg",
    //                                           height: 28,
    //                                           color: Colors.white),
    //                                     ),
    //                                     Positioned(
    //                                       top: -1,
    //                                       right: 0,
    //                                       child: SvgPicture.asset(
    //                                           "assets/svg/ellipse_bottom_pink.svg",
    //                                           height: 28,
    //                                           color: Colors.white),
    //                                     ),
    //                                     Positioned(
    //                                       bottom: 0,
    //                                       right: 0,
    //                                       child: SvgPicture.asset(
    //                                           "assets/svg/ellipse_bottom_pink.svg",
    //                                           height: 35,
    //                                           color: Colors.white),
    //                                     ),
    //                                     Positioned(
    //                                       left: 29,
    //                                       bottom: 120,
    //                                       child: Text(
    //                                         'ACCOUNT NUMBER',
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 29,
    //                                       bottom: 80,
    //                                       child: Text(
    //                                         "${index["accountNumber"]}",
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 16,
    //                                             fontWeight: FontWeight.w700,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 170,
    //                                       bottom: 82,
    //                                       child: GestureDetector(
    //                                         child: Tooltip(
    //                                           preferBelow: false,
    //                                           message: "Copy",
    //                                           child: Icon(
    //                                             Icons.copy_sharp,
    //                                             color: Colors.white,
    //                                             size: 14,
    //                                           ),
    //                                         ),
    //                                         onTap: () {
    //                                           Clipboard.setData(new ClipboardData(
    //                                               text:
    //                                                   "${index["accountNumber"]}"));
    //                                           Toast.show(
    //                                               'Account number copied.',
    //                                               backgroundColor: Colors.green,
    //                                               duration: Toast.lengthShort,
    //                                               gravity: Toast.bottom);
    //                                         },
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 29,
    //                                       bottom: 50,
    //                                       child: Text(
    //                                         'ACCOUNT NAME',
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 12,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 29,
    //                                       bottom: 20,
    //                                       child: Text(
    //                                         "$username",
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 14,
    //                                             fontWeight: FontWeight.w700,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 220,
    //                                       bottom: 50,
    //                                       child: Text(
    //                                         index["bankName"] ==
    //                                                 "9Payment Service Bank"
    //                                             ? 'N35 Charge'
    //                                             : 'N50 Charge',
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 12,
    //                                             fontWeight: FontWeight.w400,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                     Positioned(
    //                                       left: 220,
    //                                       bottom: 20,
    //                                       child: Text(
    //                                         "${index["bankName"]}",
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 12,
    //                                             fontWeight: FontWeight.w700,
    //                                             color: Colors.white),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             )
    //                             .toList()
    //                         : []),
    //               ),
    //             ),
    //             SizedBox(
    //               height: 5.0,
    //             ),
    //             SizedBox(height: 7),
    //             Padding(
    //               padding: const EdgeInsets.all(15),
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.start,
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Text(
    //                     "TOP PROVIDERS",
    //                     style: TextStyle(
    //                         fontSize: 16,
    //                         color: Colors.grey,
    //                         fontWeight: FontWeight.w400),
    //                   ),
    //                   SizedBox(
    //                     height: 10,
    //                   ),
    //                   Container(
    //                       height: 100,
    //                       child: ListView.builder(
    //                         scrollDirection: Axis.horizontal,
    //                         itemCount: top.length,
    //                         itemBuilder: (context, index) {
    //                           return InkWell(
    //                               onTap: () {
    //                                 if (top[index]["name"] == "GOTV" ||
    //                                     top[index]["name"] == "DSTV") {
    //                                   Navigator.push(
    //                                       context,
    //                                       new MaterialPageRoute(
    //                                           builder: (context) =>
    //                                               CableS(cable: top[index])));
    //                                 } else {
    //                                   Navigator.push(
    //                                       context,
    //                                       new MaterialPageRoute(
    //                                           builder: (context) =>
    //                                               BuyDataAndAirtime(
    //                                                   network: top[index])));
    //                                 }
    //                               },
    //                               child: Container(
    //                                   padding: EdgeInsets.all(8),
    //                                   child: Column(
    //                                     mainAxisAlignment:
    //                                         MainAxisAlignment.center,
    //                                     crossAxisAlignment:
    //                                         CrossAxisAlignment.center,
    //                                     children: [
    //                                       CircleAvatar(
    //                                         backgroundColor:
    //                                             Colors.green.shade100,
    //                                         radius: 30.0,
    //                                         child: CircleAvatar(
    //                                           backgroundImage: AssetImage(
    //                                               top[index]["logo"]),
    //                                           radius: 25.0,
    //                                         ),
    //                                       ),
    //                                       SizedBox(height: 8),
    //                                       Text(
    //                                         top[index]["name"],
    //                                         style: TextStyle(
    //                                             fontSize: 9,
    //                                             color: Color.fromARGB(
    //                                                 255, 105, 102, 102),
    //                                             fontWeight: FontWeight.w500),
    //                                       ),
    //                                     ],
    //                                   )));
    //                         },
    //                       )),
    //                 ],
    //               ),
    //             ),
    //             // ListView(
    //             //     shrinkWrap: true,
    //             //     physics: const AlwaysScrollableScrollPhysics(),
    //             //     children: [
    //             //       banners.length >= 1
    //             //           ? Container(
    //             //               child: ListView(
    //             //                 shrinkWrap: true,
    //             //                 children: [
    //             //                   CarouselSlider(
    //             //                     items: bannerwidget(),
    //             //                     options: CarouselOptions(
    //             //                       height: 110,
    //             //                       enlargeCenterPage: true,
    //             //                       pageSnapping: true,
    //             //                       autoPlay: true,
    //             //                       aspectRatio: 16 / 9,
    //             //                       autoPlayCurve: Curves.fastOutSlowIn,
    //             //                       enableInfiniteScroll: true,
    //             //                       autoPlayAnimationDuration:
    //             //                           Duration(milliseconds: 800),
    //             //                       viewportFraction: 0.9,
    //             //                     ),
    //             //                   ),
    //             //                 ],
    //             //               ),
    //             //             )
    //             //           : SizedBox(
    //             //               height: 0,
    //             //             ),
    //             //     ]),
    //             Divider(
    //               thickness: 1.5,
    //             ),
    //             Container(
    //               width: MediaQuery.of(context).size.width,
    //               padding: EdgeInsets.all(7),
    //               margin: EdgeInsets.all(7),
    //               child: GridView.builder(
    //                 padding: EdgeInsets.only(top: 10, bottom: 10),
    //                 physics: NeverScrollableScrollPhysics(),
    //                 shrinkWrap: true,
    //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                   crossAxisCount: 4,
    //                   crossAxisSpacing: 8,
    //                   mainAxisSpacing: 4,
    //                 ),
    //                 itemCount: services.length,
    //                 itemBuilder: (context, index) {
    //                   return InkWell(
    //                     onTap: () {
    //                       Navigator.of(context)
    //                           .pushNamed("${services[index]['route']}");
    //                     },
    //                     child: Container(
    //                       padding: EdgeInsets.all(5),
    //                       decoration: BoxDecoration(
    //                           // color: Colors.white,
    //                           // borderRadius: BorderRadius.all(
    //                           //   Radius.circular(10),
    //                           // )
    //                           ),
    //                       child: Column(
    //                         mainAxisAlignment: MainAxisAlignment.center,
    //                         crossAxisAlignment: CrossAxisAlignment.center,
    //                         children: [
    //                           Container(
    //                             padding: EdgeInsets.all(10),
    //                             decoration: BoxDecoration(
    //                                 color: Color(0xff0340cf),
    //                                 borderRadius: BorderRadius.all(
    //                                   Radius.circular(10),
    //                                 )),
    //                             child: SvgPicture.asset(
    //                               services[index]["icon"],
    //                               color: Colors.white,
    //                             ),
    //                           ),
    //                           SizedBox(
    //                             height: 10,
    //                           ),
    //                           //${services[index]['name']}

    //                           Text(
    //                             "${services[index]['name']}",
    //                             textAlign: TextAlign.center,
    //                             style: GoogleFonts.poppins(
    //                               textStyle: TextStyle(
    //                                   fontSize: 9,
    //                                   color: Colors.black,
    //                                   fontWeight: FontWeight.w500),
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   );
    //                 },
    //               ),
    //             )
    //           ],
    //         ),
    //       ),
    //     ),

    //     //  BottomNavC(),

    //     floatingActionButton: _social_Account());
  }
}
