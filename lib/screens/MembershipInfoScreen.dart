// ... diğer importlar
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MembershipInfoScreen extends StatefulWidget {
  const MembershipInfoScreen({super.key});

  @override
  State<MembershipInfoScreen> createState() => _MembershipInfoScreenState();
}

class _MembershipInfoScreenState extends State<MembershipInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String gender = '';
  bool isLoading = true;

  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

    if (doc.exists) {
      final data = doc.data();
      final fullName = data?['name'] ?? '';
      final parts = fullName.split(' ');
      firstName = parts.isNotEmpty ? parts.first : '';
      lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
      setState(() {
        email = currentUser!.email ?? '';
        phone = data?['phone'] ?? '';
        gender = data?['gender'] ?? '';
        isLoading = false;
      });
    }
  }

  Future<void> updateUserData() async {
    if (_formKey.currentState!.validate()) {
      final fullName = '$firstName $lastName'.trim();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'name': fullName, 'phone': phone, 'gender': gender});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Bilgileriniz güncellendi.')));
    }
  }

  InputDecoration getTextFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.zero),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Üyelik Bilgilerim")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      // İsim ve Soyad Yan Yana
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: firstName,
                              decoration: getTextFieldDecoration('İsim'),
                              validator:
                                  (val) => val!.isEmpty ? 'Zorunlu' : null,
                              onChanged:
                                  (val) => setState(() => firstName = val),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              initialValue: lastName,
                              decoration: getTextFieldDecoration('Soyad'),
                              validator:
                                  (val) => val!.isEmpty ? 'Zorunlu' : null,
                              onChanged:
                                  (val) => setState(() => lastName = val),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Telefon
                      TextFormField(
                        initialValue: phone,
                        decoration: getTextFieldDecoration('Telefon Numarası'),
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => setState(() => phone = val),
                      ),
                      SizedBox(height: 16),

                      // Email (pasif)
                      TextFormField(
                        initialValue: email,
                        decoration: getTextFieldDecoration('E-posta'),
                        enabled: false,
                      ),
                      SizedBox(height: 24),

                      // Cinsiyet
                      Text("Cinsiyet", style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Erkek',
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val!),
                          ),
                          Text("Erkek"),
                          SizedBox(width: 32),
                          Radio<String>(
                            value: 'Kadın',
                            groupValue: gender,
                            onChanged: (val) => setState(() => gender = val!),
                          ),
                          Text("Kadın"),
                        ],
                      ),

                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: updateUserData,
                        child: Text('Kaydet'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
