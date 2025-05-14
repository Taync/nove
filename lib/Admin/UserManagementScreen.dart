import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagementScreen extends StatelessWidget {
  final usersRef = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Management")),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['name'] ?? 'No Name'),
                subtitle: Text(data['email'] ?? 'No Email'),
                trailing: Switch(
                  value: data['isAdmin'] ?? false,
                  onChanged: (val) {
                    usersRef.doc(user.id).update({'isAdmin': val});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
