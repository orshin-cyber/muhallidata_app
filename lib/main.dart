import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:muhallidata/payment.dart';
import 'package:muhallidata/screens/atm.dart';
import 'package:muhallidata/screens/atm2.dart';
import 'package:muhallidata/screens/complain.dart';
import 'package:muhallidata/screens/home_screen.dart';
import 'package:muhallidata/screens/landpage.dart';
import 'package:muhallidata/screens/site_request.dart';
import 'package:muhallidata/screens/store.dart';
import 'package:muhallidata/screens/transactions.dart';
import 'package:muhallidata/screens/upgradepackage.dart';
import 'package:muhallidata/screens/walletfunding.dart';

import './screens/signup.dart';
import './screens/welcome.dart';
import 'Bulksms.dart';
import 'Referal.dart';
import 'Trasnsfer.dart';
import 'airtimefunding.dart';
import 'banknotice.dart';
import 'bankpayment.dart';
import 'billpayment.dart';
import 'billreceipt.dart';
import 'bonus.dart';
import 'buyairtime.dart';
import 'buydata.dart';
import 'cablesub.dart';
import 'chatwidget.dart';
import 'couponpayment.dart';
import 'datacard.dart';
import 'datacoupon.dart';
import 'history.dart';
import 'manualbank.dart';
import 'passwordchange.dart';
import 'passwordreset.dart';
import 'pin_management.dart';
import 'recharge_print.dart';
import 'screens/about.dart';
import 'screens/contact.dart';
import 'screens/kyc.dart';
import 'screens/login.dart';
import 'screens/moremenu.dart';
import 'screens/onboardui.dart';
import 'screens/pricing.dart';
import 'screens/reservedAccount.dart';
import 'screens/result_checkerform.dart';
import 'screens/setting.dart';
import 'screens/splash_screen.dart';
import 'screens/website.dart';
import 'walletsummary.dart';
import 'withdraw.dart';

void main() {
  runApp(
    MaterialApp(
      routes: {
        '/home': (context) => HomeScreen(),
        '/onboard': (context) => OnBoardScreen(),
        '/landingpage': (context) => LandingPage(),
        // '/latest': (context) => LatestDashboard(),
        '/login': (context) => LoginPage(),
        '/transactions': (context) => Transactions(),
        '/signup': (context) => SignupPage(),
        '/setting': (context) => Setting(),
        '/bank': (context) => BankPagePayment(),
        '/airtimefundin': (context) => AirtimeFunding(),
        '/paystack': (context) => CheckoutMethodSelectable(),
        '/bill': (context) => ElectPayment(),
        '/cablename': (context) => CableS(),
        '/history': (context) => History(),
        '/airtimenet': (context) => BuyAirtime(),
        '/datanet': (context) => BuyData(),
        '/changepassword': (context) => Change(),
        '/ResetPassword': (context) => ResetPassword(),
        '/transfer': (context) => Transfer(),
        '/withdraw': (context) => Withdraw(),
        '/bonus': (context) => Bonus(),
        '/billreceipt': (context) => Billreceipt(),
        '/wallet': (context) => WalletSummary(),
        '/about': (context) => AboutPage(),
        '/contact': (context) => ContactPage(),
        '/supportchat': (context) => ChatWidget(),
        '/referal': (context) => MyReferal(),
        '/ResultChecker': (context) => ResultChecker(),
        '/banknotice': (context) => BankNotice(),
        '/pricing': (context) => PricingWidget(),
        "/web": (context) => WebsiteWidget(),
        '/website': (context) => WebsiteWidget(),
        '/kyc': (context) => KycPage(),
        '/pin': (context) => PIn(),
        '/coupon': (context) => Coupon(),
        '/welcome': (context) => WelcomeP(),
        '/recharge': (context) => RechargeCard(),
        '/complain': (context) => Complain(),
        '/atm': (context) => Atm(),
        '/atm2': (context) => SecondAtm(),
        '/bank2': (context) => BankManualPayment(),
        '/rsite': (context) => RessellerSIte(),
        "/upgrade": (context) => UpgradePackage(),
        "/more": (context) => MoreMenu(),
        "/fundWallet": (context) => FundWallet(),
        '/store': (context) => StoreWidget(),
        '/datacard': (context) => DataRechargeCard(),
        '/datacoupon': (context) => DataCoupon(),
        '/bulksms': (context) => Bulksms(),
        '/reservedAccount': (context) => ReservedAccount(),
      },
      theme: ThemeData(
        fontFamily: "Roboto",
        primaryColor: Color(0xff0340cf),
      ),
      debugShowCheckedModeBanner: false,
      title: 'muhallidata',
      home: Stack(
        children: [
          ConnectionStatusBar(),
          SplashScreen(),
        ],
      ),
    ),
  );
}
