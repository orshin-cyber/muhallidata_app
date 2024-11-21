import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Redirect extends StatefulWidget {
  String? url;

  Redirect({Key? key, this.url}) : super(key: key);
  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  @override
  void initState() {
    _launchUrl();
    super.initState();
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(widget.url as Uri)) {
      throw Exception('Could not launch $widget.url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/home", (route) => false);
            },
            child: Text("Home"),
          ),
        ),
      ),
    );
  }
}
