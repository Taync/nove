import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Kullanıcı giriş yapmamışsa
        if (!snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/novesplash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
                GoogleProvider(
                  clientId:
                      '670324928036-c105i4bjrc7r3d67cejln2snhgqjf6f7.apps.googleusercontent.com',
                ),
              ],
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('Assets/Logomuz.png'),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to Nove, please sign in!'
                        : 'Welcome to Nove, please sign up!',
                  ),
                );
              },
              footerBuilder: (context, action) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our Terms and Conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              sideBuilder: (context, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('Assets/Logomuz.png'),
                  ),
                );
              },
            ),
          );
        }

        // Kullanıcı giriş yaptıysa
        return HomeScreen();
      },
    );
  }
}
