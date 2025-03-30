import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    // Do an IndexedStack.
    // This would hold all of the pages and display the Navbar.
    // Use the IndexedStack Widget body and bottomNavigationBar within Scaffold

    return Scaffold(body: Text("Dashboard"));
  }
}
