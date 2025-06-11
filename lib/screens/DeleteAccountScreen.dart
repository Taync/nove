import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  void deleteAccount(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Your account has been deleted.')));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Delete Account"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "When you delete your account;",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "• Your membership information",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text("• Your saved addresses", style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text("• Your order history", style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text(
              "will be permanently deleted. No historical records will be kept. You can rejoin Nove at any time by creating a new account.",
              style: TextStyle(fontSize: 15, color: Colors.grey[800]),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => deleteAccount(context),
                child: Text(
                  "I Understand, Delete My Account",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
