import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 10),
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  image: DecorationImage(
                      image: AssetImage("images/bg.jpg"), fit: BoxFit.cover)),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xff0340cf).withOpacity(0.5),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [Image.asset("images/line_wave_35.png")],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome To',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 32,
                                  height: 1.2,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w700),
                            )),
                        RichText(
                          text: TextSpan(
                            text: 'muhallidata.com',
                            // text: 'muhallidata.com',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 30,
                                  height: 1.2,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w700),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 40,
                                      height: 1.2,
                                      color: Color(0xffffffff),
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('Buy Data, Buy Airtime, Pay Bills and More...',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.w500),
                            )),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: Text('Best Way to Access the World!',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 20,
                        color: Color(0xff000000),
                        fontWeight: FontWeight.w500),
                  )),
            ),
            SizedBox(height: 25),
            InkWell(
              onTap: () async {
                Navigator.of(context).pushNamed("/signup");
              },
              child: Container(
                height: 56,
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                decoration: BoxDecoration(
                    color: Color(0xff0340cf),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text('REGISTER',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                Navigator.of(context).pushNamed("/login");
              },
              child: Container(
                height: 56,
                margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xff0340cf)),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Text('LOGIN',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 18,
                            color: Color(0xff000000),
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
