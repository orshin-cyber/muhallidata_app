import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FundWalletBottomSheet extends StatelessWidget {
  // const FundWalletBottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Container(
        color: Colors.white,
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 00,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  const Text(
                    "Select Funding Method",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/bank");
                        // Navigator.of(context)
                        //   ..pop
                        //   ..push(MaterialPageRoute(
                        //       builder: (_) => FundWalletScreen()));
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        margin: EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: Color(0xff0340cf),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/add.png",
                              width: 22,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "AUTOMATED BANK TRANSFER",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).pushNamed("/atm");
                    //     // Navigator.of(context)
                    //     //   ..pop
                    //     //   ..push(MaterialPageRoute(builder: (_) => Text('')));
                    //   },
                    //   child: Container(
                    //     width: 140,
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 15,
                    //       vertical: 15,
                    //     ),
                    //     margin: const EdgeInsets.only(bottom: 5),
                    //     decoration: BoxDecoration(
                    //         color: Color(0xff0340cf),
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Image.asset(
                    //           "assets/add.png",
                    //           width: 22,
                    //           color: Colors.white,
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           "MONNIFY ATM",
                    //           style: GoogleFonts.poppins(
                    //             textStyle: const TextStyle(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.of(context).pushNamed("/atm2");
                    //   },
                    //   child: Container(
                    //     width: 140,
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: 15,
                    //       vertical: 15,
                    //     ),
                    //     margin: const EdgeInsets.only(bottom: 5),
                    //     decoration: BoxDecoration(
                    //         color: Color(0xff0340cf),
                    //         borderRadius: BorderRadius.circular(10)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       children: [
                    //         Image.asset(
                    //           "assets/add.png",
                    //           width: 22,
                    //           color: Colors.white,
                    //         ),
                    //         const SizedBox(
                    //           width: 5,
                    //         ),
                    //         Text(
                    //           "PAYSTACK ATM",
                    //           style: GoogleFonts.poppins(
                    //             textStyle: const TextStyle(
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w400,
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed("/bank2");
                      },
                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            color: Color(0xff0340cf),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              "assets/add.png",
                              width: 22,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "MANUAL FUNDING",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
