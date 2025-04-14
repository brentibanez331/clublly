import 'dart:developer';

import 'package:clublly/main.dart';
import 'package:clublly/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.disconnect();
      await supabase.auth.signOut();
    } catch (error) {
      log('Error signing out: ${error}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Settings')),
        body: Column(
          children: [
            settingsButton(() {}, "brentibanez33"),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: 12,
            ),
            settingsButton(() {}, "Language"),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: 12,
            ),
            settingsButton(() {}, "Terms & Conditions"),
            Divider(height: 1, color: Colors.black12),
            settingsButton(() {}, "Rating & Feedback"),
            Divider(height: 1, color: Colors.black12),
            settingsButton(() {}, "Connect to Us"),
            Divider(height: 1, color: Colors.black12),
            settingsButton(() {}, "About Clublly"),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: 12,
            ),
            settingsButton(() {}, "Switch Accounts"),
            Container(
              color: Colors.black12,
              width: double.infinity,
              height: 12,
            ),
            InkWell(
              onTap: () async {
                signOut();
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Center(
                  child: Text(
                    "SIGN OUT",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.black12,
                width: double.infinity,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("v1.0"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget settingsButton(VoidCallback callback, String title) {
  return InkWell(
    onTap: callback,
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.black38,
            size: 16,
          ),
        ],
      ),
    ),
  );
}
