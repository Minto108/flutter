import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PastUsersPage extends StatelessWidget {
  const PastUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CollectionReference pastUsersCollection =
        FirebaseFirestore.instance.collection('past_users');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Past Users',
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
        stream: pastUsersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            debugPrint("Error fetching data: ${snapshot.error}");
            return const Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            debugPrint("No data found in past_users");
            return const Center(child: Text('No past users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>?;
              if (user == null) return const SizedBox.shrink();

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
                        "Tag No: ${user['Tag No'] ?? 'N/A'}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("Vehicle No: ${user['Vehicle No'] ?? 'N/A'}"),
                      Text("Phone No: ${user['Phone No'] ?? 'N/A'}"),
                      
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
