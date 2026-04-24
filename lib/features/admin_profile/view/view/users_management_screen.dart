import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<Map<String, dynamic>> users = [
    {"name": "Ahmed Ali", "email": "ahmed@mail.com", "isActive": true},
    {"name": "Sara Mohamed", "email": "sara@mail.com", "isActive": false},
    {"name": "Omar Khaled", "email": "omar@mail.com", "isActive": true},
  ];

  List<Map<String, dynamic>> filteredUsers = [];

  @override
  void initState() {
    filteredUsers = users;
    super.initState();
  }

  void search(String value) {
    setState(() {
      filteredUsers = users
          .where((u) =>
          u["name"].toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  void toggleStatus(int index) {
    setState(() {
      filteredUsers[index]["isActive"] =
      !filteredUsers[index]["isActive"];
    });
  }

  void deleteUser(int index) {
    setState(() {
      users.remove(filteredUsers[index]);
      filteredUsers = users;
    });
  }

  void addUser() {
    setState(() {
      users.add({
        "name": "New User ${users.length + 1}",
        "email": "new${users.length + 1}@mail.com",
        "isActive": true,
      });
      filteredUsers = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F8),

      appBar: AppBar(
        title: const Text("إدارة المستخدمين"),
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
                onChanged: search,
                decoration: const InputDecoration(
                  hintText: "ابحث عن مستخدم...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];

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
                          child: Text(user["name"][0]),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user["name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(user["email"],
                                  style: const TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () => toggleStatus(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: user["isActive"]
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              user["isActive"] ? "نشط" : "محظور",
                              style: TextStyle(
                                color: user["isActive"]
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),


                        IconButton(
                          onPressed: () => deleteUser(index),
                          icon: const Icon(Icons.delete,
                              color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}