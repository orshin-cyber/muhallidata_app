import 'package:muhallidata/screens/fund_wallet_screen.dart';
import 'package:flutter/material.dart';

Widget verticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget horizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}

Widget billCard({
  required BuildContext context,
  String? icon,
  String? text,
  required void Function() onTap,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        height: 65,
        width: 65,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green..withOpacity(0.02),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  icon!,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                text!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget homeCards(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            billCard(
              context: context,
              icon: "assets/data.png",
              text: "Data",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/airtime.png",
              text: "Airtime",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/cable.png",
              text: "Cable",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/electricity.png",
              text: "Bills",
              onTap: () {},
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            billCard(
              context: context,
              icon: "assets/education.png",
              text: "Edu Pin",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/sms.png",
              text: "Bulk SMS",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/result-checker.png",
              text: "Result",
              onTap: () {},
            ),
            billCard(
              context: context,
              icon: "assets/more.png",
              text: "More",
              onTap: () {},
            ),
          ],
        ),
      ],
    ),
  );
}

class Button extends StatelessWidget {
  // const Button({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return FundWalletBottomSheet();
          },
        );
      },
      child: Container(
        alignment: Alignment.center,
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: Color(0xff0340cf), borderRadius: BorderRadius.circular(10)),
        child: Image.asset(
          "assets/add.png",
          width: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FundWalletScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Screen 1'),
      ),
      body: Center(
        child: Text('Welcome to Screen 1!'),
      ),
    );
  }
}
