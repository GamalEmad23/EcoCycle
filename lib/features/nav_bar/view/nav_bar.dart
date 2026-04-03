import 'package:eco_cycle/features/home/view/home_scree.dart';
import 'package:eco_cycle/features/recycling_request/view/recycling_request_screen.dart';
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
    const Scaffold(body: Center(child: Text("Map"))),
    const Scaffold(body: Center(child: Text("Statistics"))),
    const Scaffold(body: Center(child: Text("Profile"))),
    const RecyclingRequestScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: pages[index],
      floatingActionButton: Container(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              index = 4;
            });
          },
          backgroundColor: const Color(0xFF00E676),
          elevation: 10,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 40, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        height: 80,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12,
        color: Colors.white,
        elevation: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_rounded, "الرئيسية", isSelected: index == 0),
            _buildNavItem(1, Icons.map_outlined, "الخريطة", isSelected: index == 1),
            
            const SizedBox(width: 80),
            
            _buildNavItem(2, Icons.bar_chart_outlined, "الإحصائيات", isSelected: index == 2),
            _buildNavItem(3, Icons.person_outline_rounded, "الملف الشخصي", isSelected: index == 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int itemIndex, IconData icon, String label, {required bool isSelected}) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => index = itemIndex),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF00E676) : const Color(0xFF94A3B8),
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
