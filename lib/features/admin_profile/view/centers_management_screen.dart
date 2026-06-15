import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecyclingCentersScreen extends StatefulWidget {
  const RecyclingCentersScreen({super.key});

  @override
  State<RecyclingCentersScreen> createState() =>
      _RecyclingCentersScreenState();
}

class _RecyclingCentersScreenState extends State<RecyclingCentersScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("admin_profile.manage_centers_title".tr()),
        centerTitle: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
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
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text("admin_profile.no_centers_found".tr()),
                    );
                  }

                  final centers = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final name = data['name'] ?? "";
                    final city = data['city'] ?? "";

                    return name
                        .toLowerCase()
                        .contains(searchText.toLowerCase()) ||
                        city
                            .toLowerCase()
                            .contains(searchText.toLowerCase());
                  }).toList();

                  if (centers.isEmpty) {
                    return Center(
                      child: Text(
                          "admin_profile.no_centers_found".tr()),
                    );
                  }

                  return ListView.builder(
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      final center = centers[index];
                      final data =
                      center.data() as Map<String, dynamic>;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.lightGreen3,
                              child: const Icon(
                                Icons.recycling,
                                color: Colors.green,
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
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${data['city'] ?? ""} - ${data['address'] ?? ""}",
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                    ),
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

