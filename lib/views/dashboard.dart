import 'package:clublly/utils/colors.dart';
import 'package:clublly/views/pages/cart_page.dart';
import 'package:clublly/views/pages/categories_page.dart';
import 'package:clublly/views/pages/home_page.dart';
import 'package:clublly/views/pages/products_page.dart';
import 'package:clublly/views/pages/profile_page.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Do an IndexedStack.
    // This would hold all of the pages and display the Navbar.
    // Use the IndexedStack Widget body and bottomNavigationBar within Scaffold

    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: currentPageIndex,
          children: [
            ProductsPage(),
            CategoriesPage(),
            HomePage(),
            CartPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.white,
            labelTextStyle: WidgetStatePropertyAll<TextStyle>(
              TextStyle(color: Colors.black),
            ),
          ),
          child: NavigationBar(
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            backgroundColor: Colors.white,
            onDestinationSelected: (index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined, color: Colors.black54),
                label: 'Shop',
                selectedIcon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.secondary,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_outlined, color: Colors.black54),
                label: 'Categories',
                selectedIcon: Icon(
                  Icons.library_books_outlined,
                  color: AppColors.secondary,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Colors.black54),
                label: 'Home',
                selectedIcon: Icon(
                  Icons.home_outlined,
                  color: AppColors.secondary,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined, color: Colors.black54),
                label: 'Cart',
                selectedIcon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.secondary,
                ),
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined, color: Colors.black54),

                // Icon(
                //   Icons.person_rounded,
                //   color: Colors.white,
                // ),
                label: 'Profile',
                selectedIcon: Icon(
                  Icons.person_outlined,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
