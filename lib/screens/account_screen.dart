import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(title: Text("Account")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Keeps the content centered
          children: [
            SizedBox(height: 10),  // Adds spacing between the text and button
            OutlinedButton(
              child: Text("Logout"),
              onPressed: () async {
              await FirebaseAuth.instance.signOut();
               Navigator.pushReplacementNamed(context, '/'); //logout yapar
              }, 
            ),
          ],
        ),
      ),
    );
  }
}
