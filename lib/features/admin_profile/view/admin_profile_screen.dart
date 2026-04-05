import 'package:easy_localization/easy_localization.dart';
import 'package:eco_cycle/core/widgets/custome_text.dart';
import 'package:eco_cycle/features/admin_profile/view/widgets/section_widget.dart';
import 'package:eco_cycle/features/admin_orders/widget/state_box.dart';
import 'package:eco_cycle/features/auth/cubit/auth_cubit.dart';
import 'package:eco_cycle/features/auth/view/login_screen.dart';
import 'package:eco_cycle/features/profile/view/widgets/custome_lang_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/helper/navigate_helper/navigate_helper.dart';
import '../../../core/themes/app_colors.dart';
import '../../admin_orders/view/orders_screen.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  String language = "en";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F7F6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
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
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),

                    SizedBox(height: 10),

                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        "https://i.pravatar.cc/300",
                      ),
                    ),

                    SizedBox(height: 10),

                    CustomeText(text: "أحمد محمد", fontWeight: FontWeight.bold),

                    SizedBox(height: 5),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const CustomeText(
                        text: "مدير النظام",
                        textColor: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StatBox(title: "نشاط", value: "98%"),
                        StatBox(title: "مراكز", value: "13"),
                        StatBox(title: "مستخدمين", value: "154"),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              sectionWidget(
                icon: Icons.people,
                title: "إدارة المستخدمين",
                subtitle: "التحكم في صلاحيات المستخدمين",
              ),

              sectionWidget(
                icon: Icons.recycling,
                title: "إدارة مراكز إعادة التدوير",
                subtitle: "تحديث المواقع ومتابعة الطلبات",
              ),

              sectionWidget(
                icon: Icons.language,
                title: "اللغه",
                subtitle: "تخصيص الللغه  ",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: Colors.grey.shade100,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              /// Title
                              Text(
                                "Select Language",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),

                              SizedBox(height: 20),

                              /// English
                              CustomeLangCard(
                                title: "English",
                                icon: Icons.language,
                                selected: language == "en",
                                onTap: () {
                                  setState(() => language = "en");
                                  context.setLocale(Locale("en"));
                                },
                              ),

                              SizedBox(height: 12),

                              /// Arabic
                              CustomeLangCard(
                                title: "العربية",
                                icon: Icons.language,
                                selected: language == "ar",
                                onTap: () {
                                  setState(() => language = "ar");
                                  context.setLocale(Locale("ar"));
                                },
                              ),

                              SizedBox(height: 20),

                              /// Button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF8FD3A8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text("Done"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 10),

              GestureDetector(
                onTap: () {
                  context.read<AuthCubit>().Signout();
                  if (FirebaseAuth.instance.currentUser == null) {
                    NavigateHelper.pushAndRemoveUntil(context, LoginScreen());
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: CustomeText(text: "تسجيل الخروج"),
                    subtitle: CustomeText(
                      text: "إنهاء الجلسة الحالية بأمان",
                      fontSize: 15,
                      textColor: AppColors.textGrey,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    CustomeText(text: "نصيحه اليوم", textColor: Colors.white),
                    CustomeText(
                      text: "تقليل استهلاك الورق يوفر ملايين الأشجار سنويًا",
                      textColor: AppColors.white,
                    ),
                  ],
                ),
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
            NavigateHelper.push(context, OrdersScreen());
          }
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "الطلبات"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "الحساب"),
        ],
      ),
    );
  }
}
