import 'package:flutter/material.dart';
import 'package:onboarding_intro_screen/onboarding_screen.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OnBoardScreenState();
  }
}

class OnBoardScreenState extends State<OnBoardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _globalKey,
      body: OnBoardingScreen(
        // bgColor: Colors.white,
        // themeColor: Colors.blue,
        pages: pages,
        onSkip: () {
          Navigator.of(context).pushReplacementNamed("/login");
        },
        // skipClicked: (value) {
        //   Navigator.of(context).pushReplacementNamed("/login");
        // },
        // getStartedClicked: (value) {
        //   Navigator.of(context).pushReplacementNamed("/login");
        // },
      ),
    );
  }

  final pages = [
    OnBoardingModel(
        title: 'Welcome to muhallidata',
        body: 'muhallidata ,Automated VTU platform and affordable services .',
        titleColor: Colors.black,
        // descripColor: const Color(0xFF929794),
        image: Image.asset('images/undraw_Hello_qnas.png')),
    OnBoardingModel(
        title: 'We are Fast',
        body: 'Our Services delivery and wallet funding is automated.',
        titleColor: Colors.black,
        // descripColor: const Color(0xFF929794),
        image: Image.asset('images/undraw_fast_loading_0lbh.png')),
    OnBoardingModel(
        title: 'You are Safe',
        body:
            'Your funds in your wallet can be kept as long as you want and it’s secured.',
        titleColor: Colors.black,
        // body: const Color(0xFF929794),
        image: Image.asset('images/undraw_security_o890.png')),
    OnBoardingModel(
        title: 'We are Reliable',
        body: 'With our several years of experience and engineers.',
        titleColor: Colors.black,
        // descripColor: const Color(0xFF929794),
        image: Image.asset('images/undraw_team_spirit_hrr4.png')),
  ];
}
