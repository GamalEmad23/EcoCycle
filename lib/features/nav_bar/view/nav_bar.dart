import 'package:eco_cycle/core/themes/cubit/theme_cubit.dart';
import 'package:eco_cycle/features/nav_bar/cubit/nav_bar_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/features/home/view/home_screen.dart';
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
  // Pages will be instantiated in build to ensure they rebuild on theme change

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final List<Widget> pages = [
          const HomeScreen(),
          const MapScreen(),
          const RecyclingRequestScreen(),
          const StatisticsScreen(),
          const ProfileScreen(),
        ];
        return BlocBuilder<NavBarCubit, int>(
          builder: (context, index) {
            return Scaffold(
              extendBody: true,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: FloatingActionButton(
                  onPressed: () {
                    context.read<NavBarCubit>().changeIndex(2);
                  },
                  backgroundColor: AppColors.green,
                  elevation: 4,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.recycling,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              bottomNavigationBar: Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    currentIndex: index,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    backgroundColor: AppColors.white,
                    selectedItemColor: AppColors.green,
                    unselectedItemColor: AppColors.textGrey,
                    selectedFontSize: 12,
                    unselectedFontSize: 12,
                    selectedIconTheme: const IconThemeData(size: 26),
                    unselectedIconTheme: const IconThemeData(size: 26),
                    onTap: (value) {
                      context.read<NavBarCubit>().changeIndex(value);
                    },
                    items: [
                      BottomNavigationBarItem(
                        icon: const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.home_outlined),
                        ),
                        label: "nav_bar.home".tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.map_outlined),
                        ),
                        label: "nav_bar.map".tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.transparent,
                          size: 10,
                        ),
                        label: "",
                      ),
                      BottomNavigationBarItem(
                        icon: const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.bar_chart),
                        ),
                        label: "nav_bar.statistic".tr(),
                      ),
                      BottomNavigationBarItem(
                        icon: const Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: Icon(Icons.person_2_outlined),
                        ),
                        label: "nav_bar.profile".tr(),
                      ),
                    ],
                  ),
                ),
              ),
              body: KeyedSubtree(key: ValueKey(themeMode), child: pages[index]),
            );
          },
        );
      },
    );
  }
}
