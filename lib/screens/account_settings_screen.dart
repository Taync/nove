import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:nove_5/screens/AddressListScreen.dart';
import 'package:nove_5/screens/DeleteAccountScreen.dart';
import 'package:nove_5/screens/MembershipInfoScreen.dart';
import 'package:nove_5/screens/change_password_screen.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account Settings")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text("Account Information"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MembershipInfoScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.location_on_outlined),
            title: Text("Address Information"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddressListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text("Change Password"),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChangePasswordScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete_forever_outlined, color: Colors.red),
            title: Text(
              "Delete My Account",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DeleteAccountScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
