import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../admin_orders/view/orders_screen.dart';
import '../admin_profile/view/admin_profile_screen.dart';

class AdminNavBar extends StatefulWidget {
  const AdminNavBar({super.key});

  @override
  State<AdminNavBar> createState() => _AdminNavBarState();
}

class _AdminNavBarState extends State<AdminNavBar> {
  int currentIndex = 0;

  final List<Widget> screens = const [AdminProfileScreen(), OrdersScreen()];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        AppColors.isDarkMode = themeMode == ThemeMode.dark;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(index: currentIndex, children: screens),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.isDarkMode
                      ? Colors.black.withValues(alpha: 0.35)
                      : Colors.black12,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              backgroundColor: AppColors.white,
              selectedItemColor: AppColors.green,
              unselectedItemColor: AppColors.textGrey,
              selectedIconTheme: const IconThemeData(size: 26),
              unselectedIconTheme: const IconThemeData(size: 26),
              selectedFontSize: 12,
              unselectedFontSize: 12,
              onTap: (index) {
                if (index == currentIndex) return;
                setState(() {
                  currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person),
                  label: "nav_bar.profile".tr(),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.list),
                  label: "orders.title".tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
