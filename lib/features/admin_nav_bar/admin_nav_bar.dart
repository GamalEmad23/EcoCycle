import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../admin_orders/view/orders_screen.dart';
import '../admin_profile/view/view/admin_profile_screen.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int currentIndex = 0;

  final screens = const [
    AdminProfileScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items:  [
          BottomNavigationBarItem(
            icon:  Icon(Icons.person),
            label: "nav_bar.profile".tr(),
          ),
          BottomNavigationBarItem(
            icon:  Icon(Icons.list),
            label: "orders.title".tr(),
          ),
        ],
      ),
    );
  }
}