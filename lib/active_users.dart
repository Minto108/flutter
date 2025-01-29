import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveUsersPage extends StatelessWidget {
  const ActiveUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Active Users',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersCollection.where('Active', isEqualTo: 'Yes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("Error fetching data: \${snapshot.error}");
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            debugPrint("No data found in Firestore");
            return const Center(child: Text('No active users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userDoc = users[index];
              final user = userDoc.data() as Map<String, dynamic>?;

              if (user == null) {
                return const SizedBox.shrink();
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tag No: \${user['Tag No'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Vehicle No: \${user['Vehicle No'] ?? 'N/A'}"),
                      Text("Phone No: \${user['Phone No'] ?? 'N/A'}"),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Active: \${user['Active'] ?? 'N/A'}",
                            style: TextStyle(
                              color: (user['Active'] == 'Yes')
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              try {
                                final now = DateTime.now();

                                // Add user to `past_users` collection
                                await FirebaseFirestore.instance
                                    .collection('past_users')
                                    .doc(userDoc.id)
                                    .set({
                                  ...user,
                                  'Active': 'No',
                                });

                                // Update the original document in `users`
                                await userDoc.reference.update({
                                  'Active': 'No',
                                });

                                debugPrint("User deactivated and moved to past_users.");
                              } catch (e) {
                                debugPrint("Error deactivating user: \$e");
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Deactivate"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
