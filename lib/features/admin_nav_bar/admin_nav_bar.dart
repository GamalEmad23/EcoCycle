import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../admin_orders/view/orders_screen.dart';
import '../admin_profile/view/admin_profile_screen.dart';
import 'package:eco_cycle/core/responsive/app_breakpoints.dart';

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

        final useBottomNavigation = AppBreakpoints.isMobile(context);
        final content = IndexedStack(index: currentIndex, children: screens);

        return Scaffold(
          backgroundColor: AppColors.background,
          body: useBottomNavigation
              ? content
              : Row(
                  children: [
                    NavigationRail(
                      selectedIndex: currentIndex,
                      labelType: NavigationRailLabelType.all,
                      backgroundColor: AppColors.white,
                      indicatorColor: AppColors.lightGreen3,
                      minWidth: 80,
                      selectedIconTheme: IconThemeData(
                        color: AppColors.green,
                        size: 26,
                      ),
                      unselectedIconTheme: IconThemeData(
                        color: AppColors.textGrey,
                        size: 24,
                      ),
                      selectedLabelTextStyle: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      unselectedLabelTextStyle: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.lightGreen3,
                              child: Icon(
                                Icons.admin_panel_settings,
                                color: AppColors.green,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDestinationSelected: (index) {
                        setState(() => currentIndex = index);
                      },
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.person_outline),
                          selectedIcon: const Icon(Icons.person),
                          label: Text('nav_bar.profile'.tr()),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.list_outlined),
                          selectedIcon: const Icon(Icons.list),
                          label: Text('orders.title'.tr()),
                        ),
                      ],
                    ),
                    VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.border,
                    ),
                    Expanded(child: content),
                  ],
                ),
          bottomNavigationBar: useBottomNavigation
              ? Container(
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
                )
              : null,
        );
      },
    );
  }
}
