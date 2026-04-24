import 'package:easy_localization/easy_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecyclingCentersScreen extends StatelessWidget {
  const RecyclingCentersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),

      appBar: AppBar(
        title: Text("admin_profile.manage_centers_title".tr()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "admin_profile.search_center".tr(),
                  prefixIcon: const Icon(Icons.search),
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

                  var centers = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      var center = centers[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [

                            CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: const Icon(
                                Icons.recycling,
                                color: Colors.green,
                              ),
                            ),

                            const SizedBox(width: 12),


                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    center['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "${center['city']} - ${center['address']}",
                                    style: const TextStyle(
                                      color: Colors.grey,
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