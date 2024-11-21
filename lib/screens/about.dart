import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            "About us",
            style: TextStyle(color: Colors.black),
          ),
        ),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
                child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      Text(
                        'Welcome to   muhallidata',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to Cash.',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'We Provide Awesome Services',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly.We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'About muhallidata',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'is Nigeria\'s leading telecommunications company. We launched in DECEMBER 2021 and our mission is to become the heart❤️ of telecommunications in Nigeria.',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'We serve a resell customer base that continues to grow exponentially, offering transmission services that span various categories including Noble Data, cable sub, electric bill, Airtime(vtu), phones and much more.',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Our range of services are designed to ensure optimum levels of convenience and customer satisfaction with the resell process; these services include our Affordable price guarantee, Automated, Reliable, dedicated customer service support and many other premium services.',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'As we continue to expand the Platform, our scope of offerings will increase in variety, simplicity and convenience; join us and enjoy the increasing benefits.',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'We are highly customer-centric and are committed towards finding innovative ways of improving our customers\' ordering experience with us; so give us some feedback. For any press related questions, kindly contact us and we hope you enjoy your experience with us.',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'We are 100% Secure',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Your e-wallet is the safest, easiest and fastest means of carrying out transactions with us. Your funds are secured with your e-wallet PIN and can be kept for you for as long as you want. You can also withdraw it any time.',
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        'Our customers are premium to us, hence satisfying them is our topmost priority. Our customer service is just a click away and You get 100% value for any transaction you carry with us.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ]))
              ],
            ),
          )
        ]))));
  }
}
