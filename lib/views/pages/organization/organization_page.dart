import 'package:clublly/models/organization.dart';
import 'package:clublly/models/product_image.dart';
import 'package:clublly/utils/colors.dart';
import 'package:clublly/views/dashboard.dart';
import 'package:clublly/views/pages/organization/organization_home_page.dart';
import 'package:clublly/views/pages/organization/organization_locations.dart';
import 'package:clublly/views/pages/organization/organization_order_page.dart';
import 'package:clublly/views/pages/organization/organization_product_page.dart';
import 'package:flutter/material.dart';

class OrganizationPage extends StatefulWidget {
  final Organization organization;

  const OrganizationPage({Key? key, required this.organization})
    : super(key: key);

  @override
  _OrganizationPageState createState() => _OrganizationPageState();
}

class _OrganizationPageState extends State<OrganizationPage> {
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.organization.acronym),
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            OrganizationHomePage(),
            OrganizationOrderPage(),
            OrganizationProductPage(organizationId: widget.organization.id!),
            OrganizationLocations(organizationId: widget.organization.id!),
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(height: 24),
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.rocket_launch_outlined),
                          SizedBox(width: 10),
                          const Text('Dashboard'),
                        ],
                      ),
                      selected: _selectedIndex == 0,
                      selectedColor: AppColors.secondary,
                      onTap: () {
                        _onItemTapped(0);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.receipt_outlined),
                          SizedBox(width: 10),
                          const Text('Orders'),
                        ],
                      ),
                      selected: _selectedIndex == 1,
                      selectedColor: AppColors.secondary,
                      onTap: () {
                        _onItemTapped(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_bag_outlined),
                          SizedBox(width: 10),
                          const Text('Products'),
                        ],
                      ),
                      selected: _selectedIndex == 2,
                      selectedColor: AppColors.secondary,
                      onTap: () {
                        _onItemTapped(2);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.place),
                          SizedBox(width: 10),
                          const Text('Pickup Locations'),
                        ],
                      ),
                      selectedColor: AppColors.secondary,
                      selected: _selectedIndex == 3,
                      onTap: () {
                        _onItemTapped(3);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.home_outlined),
                    SizedBox(width: 10),
                    const Text('Return to Home'),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
