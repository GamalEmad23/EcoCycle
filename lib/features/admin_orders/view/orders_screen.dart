import 'package:eco_cycle/core/helper/navigate_helper/navigate_helper.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/addmin_profile/view/admin_profile_screen.dart';
import 'package:flutter/material.dart';
import '../widget/order_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor:AppColors.white,
        body: SafeArea(
          child: Column(
            children: [

              Padding(
                padding:  EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                     Icon(Icons.search),
                     CustomeText(text:
                      "صفحة الطلبات",
                     fontSize: 24,
                    fontWeight: FontWeight.bold,),


                    InkWell(
                      onTap: (){
                        NavigateHelper.push(context,AdminProfileScreen());
                      },
                        child:  Icon(Icons.arrow_forward_ios, size: 20)),
                  ],
                ),
              ),

               TabBar(
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textGrey,
                indicatorColor: AppColors.primary,
                tabs: [
                  Tab(text: "الكل"),
                  Tab(text: "معلق"),
                  Tab(text: "مقبول"),
                  Tab(text: "مرفوض"),
                ],
              ),

              Expanded(
                child: TabBarView(
                  children: [
                    orders(),
                    orders(),
                    orders(),
                    orders(),
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,

          onTap: (index) {
            if (index == 1) {
              NavigateHelper.push(context,AdminProfileScreen());
            }
          },

          items:  [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "الطلبات",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "الحساب",
            ),
          ],
        ),
      ),
    );
  }
}

Widget orders() {
  return ListView(
    padding:  EdgeInsets.all(16),
    children:  [
      OrderCard(),
      OrderCard(),
    ],
  );
}

