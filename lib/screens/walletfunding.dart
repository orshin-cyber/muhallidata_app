import 'package:flutter/material.dart';

class FundWallet extends StatefulWidget {
  // const FundWallet({ Key? key }) : super(key: key);

  @override
  _FundWalletState createState() => _FundWalletState();
}

class _FundWalletState extends State<FundWallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wallet Funding",
            style: TextStyle(color: Colors.black, fontSize: 17.0)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Container(
        child: ListView(children: [
          ListTile(
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            leading: Image.asset(
              "assets/money-transfer.png",
              height: 30,
            ),
            title: Text(
              "AUTOMATED TRANSFER",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/bank");
            },
          ),
          Divider(
            height: 0.05,
            thickness: 1,
          ),
          // ListTile(
          //   minLeadingWidth: 0,
          //   minVerticalPadding: 0,
          //   leading: Image.asset(
          //     "assets/atm.png",
          //     height: 30,
          //   ),
          //   title: Text(
          //     "MONNIFY ATM",
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed("/atm");
          //   },
          // ),
          // Divider(
          //   height: 0.05,
          //   thickness: 1,
          // ),
          // ListTile(
          //   minLeadingWidth: 0,
          //   minVerticalPadding: 0,
          //   leading: Image.asset(
          //     "assets/debit-card.png",
          //     height: 30,
          //   ),
          //   title: Text(
          //     "PAYSTACK ATM",
          //     style: TextStyle(color: Colors.black),
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed("/atm2");
          //   },
          // ),
          Divider(
            height: 0.05,
            thickness: 1,
          ),
          ListTile(
            minLeadingWidth: 0,
            minVerticalPadding: 0,
            leading: Image.asset(
              "assets/bank.png",
              height: 30,
            ),
            title: Text(
              "MANUAL FUNDING",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              // Navigator.of(context).pushNamed("/bank2");
              Navigator.of(context).pushNamed("/coupon");
            },
          ),
          Divider(
            height: 0.05,
            thickness: 1,
          ),
        ]),
      ),
    );
  }
}
