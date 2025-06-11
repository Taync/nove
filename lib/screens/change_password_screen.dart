import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  Future<void> _changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = FirebaseAuth.instance.currentUser!;
        final cred = EmailAuthProvider.credential(
          email: user.email!,
          password: _currentPasswordController.text.trim(),
        );

        await user.reauthenticateWithCredential(cred);

        await user.updatePassword(_newPasswordController.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password successfully updated.')),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  labelText: "Current Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrent ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () =>
                            setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'Please enter your current password'
                            : null,
              ),
              SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
              ),
              SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Confirm New Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed:
                        () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value != _newPasswordController.text
                            ? 'Passwords do not match'
                            : null,
              ),
              SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _changePassword,
                icon: Icon(Icons.save),
                label: Text("Save"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
