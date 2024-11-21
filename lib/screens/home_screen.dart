import 'package:connection_status_bar/connection_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:muhallidata/screens/dash2.dart';
import 'package:muhallidata/screens/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../walletsummary.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;
  List<Widget> widgets = [
    NewDashboard(),
    WalletSummary(),
    // ChatWidget(),
    Setting()
  ];
  void changeIndex(int newIndex) => setState(() => currentIndex = newIndex);
  String username = '';

  Future<dynamic> filldetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (this.mounted) {
      setState(() {
        username = pref.getString("username")!;
      });
    }
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'We Provide Awesome Services at datavendor.ng',
      text:
          'We use cutting-edge technology to run our services. Our data delivery and wallet funding is automated, airtime top-up and data purchase are automated and get delivered to you almost instantly. We offer instant recharge of Airtime, Databundle, CableTV (DStv, GOtv & Startimes), Electricity Bill Payment and Airtime to cash.',
      linkUrl: 'https://www.datavendor.ng/referal=$username',
    );
  }

  _launchURL() async {
    const url = 'https://api.whatsapp.com/send?phone=2348056665655';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Scaffold(
                body: widgets[currentIndex],
                // floatingActionButton: _social_Account(),
                bottomNavigationBar: bottomNavbar(
                    onTap: changeIndex, currentIndex: currentIndex)),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConnectionStatusBar(),
          ),
        ],
      ),
    );
  }
}

// Widget bottomNavbar({@required onTap, @required currentIndex}) {
//   return BottomNavigationBar(
//     backgroundColor: Colors.white,
//     onTap: onTap,
//     currentIndex: currentIndex,
//     type: BottomNavigationBarType.fixed,
//     items: [
//       _buildNavItem(
//         icon: Icons.home,
//         label: 'Home',
//         isActive: currentIndex == 0,
//       ),
//       _buildNavItem(
//         icon: Icons.rotate_90_degrees_ccw_rounded,
//         label: 'Summary',
//         isActive: currentIndex == 1,
//       ),
//       _buildNavItem(
//         icon: Icons.settings,
//         label: 'Setting',
//         isActive: currentIndex == 2,
//       ),
//     ],
//   );
// }

// BottomNavigationBarItem _buildNavItem({
//   required IconData icon,
//   required String label,
//   required bool isActive,
// }) {
//   return BottomNavigationBarItem(
//     icon: Container(
//       padding: EdgeInsets.all(8), // Padding around the icon
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isActive
//             ? Colors.orange
//             : Colors.black, // Orange for active, black otherwise
//       ),
//       child: Icon(
//         icon,
//         color: Colors.white, // Icon color (white)
//       ),
//     ),
//     label: label,
//   );
// }

Widget bottomNavbar({@required onTap, @required currentIndex}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.black, // Background color of the bottom navigation bar
      borderRadius: BorderRadius.circular(20), // Rounded corners for the bar
    ),
    padding: EdgeInsets.symmetric(
        horizontal: 12, vertical: 6), // Padding around the bar
    child: BottomNavigationBar(
      backgroundColor: Colors
          .transparent, // Make the actual bar background transparent to show the container color
      onTap: onTap,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: [
        _buildNavItem(
          icon: Icons.home,
          label: 'Home',
          isActive: currentIndex == 0,
        ),
        _buildNavItem(
          icon: Icons.rotate_90_degrees_ccw_rounded,
          label: 'Summary',
          isActive: currentIndex == 1,
        ),
        _buildNavItem(
          icon: Icons.settings,
          label: 'Setting',
          isActive: currentIndex == 2,
        ),
      ],
    ),
  );
}

// BottomNavigationBarItem _buildNavItem({
//   required IconData icon,
//   required String label,
//   required bool isActive,
// }) {
//   return BottomNavigationBarItem(
//     icon: Stack(
//       alignment: Alignment.center,
//       children: [
//         if (isActive)
//           Container(
//             padding: EdgeInsets.all(8), // Padding for the hover effect size
//           ),
//         Icon(icon, color: Colors.white), // Icon color
//       ],
//     ),
//     label: label,
//   );
// }
BottomNavigationBarItem _buildNavItem({
  required IconData icon,
  required String label,
  required bool isActive,
}) {
  return BottomNavigationBarItem(
    icon: Container(
      decoration: BoxDecoration(
        color: isActive
            ? Color(0xFF2703CA)
            : Colors.transparent, // Background color for active icon
        shape: BoxShape.circle, // Circular shape for the background
      ),
      padding: EdgeInsets.all(
          8), // Padding to control the size of the circular background
      child: Icon(
        icon,
        color: Colors.white, // Icon color (white)
      ),
    ),
    label: label,
  );
}
