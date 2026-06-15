import 'package:eco_cycle/core/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  String searchText = "";

  void toggleStatus(String userId, bool currentStatus) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({
      "isActive": !currentStatus,
    });
  }

  void deleteUser(String userId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        title: Text("admin_profile.manage_users_title".tr()),
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
                  hintText: "admin_profile.search_user".tr(),
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
                    .collection('users')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No Users",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    );
                  }

                  final users = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final name = data['name'] ?? "";

                    return name
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final doc = users[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final name = data['name'] ?? "";
                      final email = data['email'] ?? "";
                      final image = data['image'];
                      final isActive = data['isActive'] ?? true;

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
                              backgroundImage: image != null
                                  ? NetworkImage(image)
                                  : null,
                              backgroundColor: AppColors.lightGreen3,
                              child: image == null
                                  ? Text(
                                      name.isNotEmpty ? name[0] : "?",
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    )
                                  : null,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(color: AppColors.textGrey),
                                  ),
                                ],
                              ),
                            ),

                            GestureDetector(
                              onTap: () => toggleStatus(doc.id, isActive),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? Colors.green.withOpacity(0.15)
                                      : Colors.red.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isActive
                                      ? "admin_profile.active".tr()
                                      : "admin_profile.blocked".tr(),
                                  style: TextStyle(
                                    color: isActive
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            IconButton(
                              onPressed: () => deleteUser(doc.id),
                              icon: const Icon(Icons.delete, color: Colors.red),
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

