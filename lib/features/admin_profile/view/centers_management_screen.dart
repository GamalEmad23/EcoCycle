import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class RecyclingCentersScreen extends StatefulWidget {
  const RecyclingCentersScreen({super.key});

  @override
  State<RecyclingCentersScreen> createState() => _RecyclingCentersScreenState();
}

class _RecyclingCentersScreenState extends State<RecyclingCentersScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    AppColors.isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("admin_profile.manage_centers_title".tr()),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                cursorColor: AppColors.green,
                style: TextStyle(color: AppColors.textPrimary),
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "admin_profile.search_center".tr(),
                  hintStyle: TextStyle(color: AppColors.textGrey),
                  prefixIcon: Icon(Icons.search, color: AppColors.textGrey),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('centers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.green),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "admin_profile.no_centers_found".tr(),
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    );
                  }

                  final centers = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final name = data['name'] ?? "";
                    final city = data['city'] ?? "";

                    return name.toLowerCase().contains(
                          searchText.toLowerCase(),
                        ) ||
                        city.toLowerCase().contains(searchText.toLowerCase());
                  }).toList();

                  if (centers.isEmpty) {
                    return Center(
                      child: Text(
                        "admin_profile.no_centers_found".tr(),
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      final center = centers[index];
                      final data = center.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.isDarkMode
                                  ? Colors.black.withValues(alpha: 0.22)
                                  : Colors.black.withValues(alpha: 0.04),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.lightGreen3,
                              child: Icon(
                                Icons.recycling,
                                color: AppColors.green,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? "",
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data['city'] ?? ""} - ${data['address'] ?? ""}",
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
