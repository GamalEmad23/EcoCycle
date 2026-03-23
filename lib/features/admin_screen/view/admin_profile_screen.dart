import 'package:eco_cycle/core/helper/get_helper/get_helper.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/admin_screen/widget/section_widget.dart';
import 'package:eco_cycle/features/admin_screen/widget/state_box.dart';
import 'package:flutter/material.dart';

import '../../../core/themes/app_colors.dart';
import 'orders_screen.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xffF5F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                padding:  EdgeInsets.all(16),
                decoration:  BoxDecoration(
                  color: Color(0xffE9F0EC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                     Align(
                      alignment: Alignment.centerRight,
                      child:Icon(Icons.arrow_forward_ios, size: 20)),


                     SizedBox(height: 10),

                     CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),

                     SizedBox(height: 10),

                     CustomeText(text:
                      "أحمد محمد",
                      fontWeight: FontWeight.bold,
                    ),

                     SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const CustomeText(text:
                        "مدير النظام",
                       textColor: AppColors.primary,
                      ),
                    ),

                     SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  [
                        StatBox(title: "نشاط", value: "98%"),
                        StatBox(title: "مراكز", value: "13"),
                        StatBox(title: "مستخدمين", value: "154"),
                      ],
                    )
                  ],
                ),
              ),

               SizedBox(height: 20),

              sectionWidget(icon: Icons.people, title: "إدارة المستخدمين", subtitle: "التحكم في صلاحيات المستخدمين"),

              sectionWidget(icon: Icons.recycling, title: "إدارة مراكز إعادة التدوير", subtitle: "تحديث المواقع ومتابعة الطلبات"),

              sectionWidget(icon: Icons.settings, title: "الإعدادات", subtitle: "تخصيص التطبيق وتغيير النظام"),

               SizedBox(height: 10),

              InkWell(
                onTap: (){

                },
                child: Container(
                  margin:  EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:  Icon(Icons.logout, color: Colors.red),
                    title:  CustomeText(text: "تسجيل الخروج"),
                    subtitle:  CustomeText(text: "إنهاء الجلسة الحالية بأمان",fontSize: 15,textColor: AppColors.textGrey,),
                    trailing:  Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),

               SizedBox(height: 20),

              Container(

                margin:  EdgeInsets.symmetric(horizontal: 16),
                padding:  EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    CustomeText(text: "نصيحه اليوم",textColor: Colors.white,),
                     CustomeText(text:
                      "تقليل استهلاك الورق يوفر ملايين الأشجار سنويًا",
                      textColor: AppColors.white,
                    ),
                  ],
                )
              ),

               SizedBox(height: 20),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,

        onTap: (index) {
          if (index == 0) {
            GetHelper.getTo(OrdersScreen());
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
    );
  }
}


