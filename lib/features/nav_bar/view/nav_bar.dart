import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/home/view/home_scree.dart';
import 'package:eco_cycle/features/map/view/map_screen.dart';
import 'package:eco_cycle/features/profile/view/profile_screen.dart';
import 'package:eco_cycle/features/recycling_request/view/recycling_request_screen.dart';
import 'package:eco_cycle/features/statistics/view/statistics_screen.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;

  final List<Widget> pages = [
    const HomeScree(),
    const MapScreen(),
    const RecyclingRequestScreen(),
    const StatisticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(20),
            child: BottomNavigationBar(
              currentIndex: index,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: AppColors.lightGreen2,
              selectedItemColor: AppColors.green,
              unselectedItemColor: AppColors.textPrimary,
              onTap: (value) {
                setState(() {
                  index = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 25),
                  label: "nav_bar.home".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined, size: 25),
                  label: "nav_bar.map".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add, size: 25),
                  label: "nav_bar.add".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart, size: 25),
                  label: "nav_bar.statistic".tr(),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_2_outlined, size: 25),
                  label: "nav_bar.profile".tr(),
                ),
              ],
            ),
          ),
        ),
      ),

      body: pages[index]
    );
  }
}
