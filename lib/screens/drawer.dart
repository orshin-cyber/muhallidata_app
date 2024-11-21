import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'login.dart';

class MyDrawer extends AnimatedWidget {
  MyDrawer({Key? key, Animation<double>? animation, String? username})
      : super(key: key, listenable: animation!);

  setlogout(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("token");

    Toast.show("Account logout successfully",
        backgroundColor: Color.fromRGBO(164, 6, 7, 1),
        duration: Toast.lengthLong,
        gravity: Toast.top);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
        (Route<dynamic> route) => false);
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'We Provide Awesome Services at muhallidata',
      text:
          'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
      linkUrl:
          'https://play.google.com/store/apps/details?id=com.muhallidata.msorgdevelopers',
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 0.8,
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Menus",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w400),
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Center(
                child: Image(
              image: AssetImage(
                'assets/logo.png',
              ),
              height: 70,
            )),
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/empty-wallet-add.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Wallet Summary",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed('/wallet');
                    },
                  ),

                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/coin.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Pricing",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/pricing");
                    },
                  ),

                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/keyboard-open.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Affilliate Website",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/rsite");
                    },
                  ),

                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/profile-2user.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("About us",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/about");
                    },
                  ),
                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/call.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Contact Us",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/contact");
                    },
                  ),
                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/messages.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Log Complaint",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/complain");
                    },
                  ),
                  // ListTile(
                  //   minVerticalPadding: 20,
                  //   horizontalTitleGap: 10,
                  //   leading: SvgPicture.asset(
                  //     "icons/general/linear/keyboard-open.svg",
                  //     height: 35,
                  //     color: Color(0xff000000),
                  //   ),
                  //   title: Text("Affilliate Website",
                  //       style: GoogleFonts.poppins(
                  //         textStyle: TextStyle(
                  //             fontSize: 18,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w500),
                  //       )),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed("/rsite");
                  //   },
                  // ),
                  // ListTile(
                  //   minVerticalPadding: 20,
                  //    horizontalTitleGap: 10,
                  //   leading:  SvgPicture.asset(
                  //                           "icons/general/linear/send-square.svg",
                  //                           height: 35,
                  //                             color: Color(0xff000000),
                  //   ),
                  //   title: Text(
                  //     "Upgrade package",
                  //      style: GoogleFonts.poppins(
                  //             textStyle: TextStyle(
                  //                 fontSize: 18,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w500),
                  //           )),

                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed("/upgrade");
                  //   },
                  // ),
                  // ListTile(
                  //   minVerticalPadding: 20,
                  //    horizontalTitleGap: 10,
                  //   leading:  SvgPicture.asset(
                  //                           "icons/general/linear/refresh-circle.svg",
                  //                           height: 35,
                  //                             color: Color(0xff000000),
                  //   ),
                  //   title: Text(
                  //     "Airtime to Cash",
                  //      style: GoogleFonts.poppins(
                  //             textStyle: TextStyle(
                  //                 fontSize: 18,
                  //                 color: Colors.black,
                  //                 fontWeight: FontWeight.w500),
                  //           )),

                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Navigator.of(context).pushNamed("/airtimefundin");
                  //   },
                  // ),

                  ListTile(
                    minVerticalPadding: 20,
                    horizontalTitleGap: 10,
                    leading: SvgPicture.asset(
                      "icons/general/linear/setting-1.svg",
                      height: 35,
                      color: Color(0xff000000),
                    ),
                    title: Text("Settings",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed("/setting");
                    },
                  ),
                  // ListTile(
                  //   minVerticalPadding: 20,
                  //   horizontalTitleGap: 10,
                  //   leading: SvgPicture.asset(
                  //     "icons/general/linear/share.svg",
                  //     height: 35,
                  //     color: Color(0xff000000),
                  //   ),
                  //   title: Text("Share",
                  //       style: GoogleFonts.poppins(
                  //         textStyle: TextStyle(
                  //             fontSize: 18,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.w500),
                  //       )),
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     share();
                  //   },
                  // ),

                  SizedBox(
                    height: 20,
                  ),

                  Center(
                    child: InkWell(
                      onTap: () {
                        setlogout(context);
                      },
                      child: Text("Log out",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20,
                                color: Colors.red,
                                fontWeight: FontWeight.w400),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
