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
        if (!snapshot.hasData) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('Assets/novesplash.jpg'), // Path to your background image
                fit: BoxFit.cover, // Adjust how the image fits (cover, contain, etc.)
              ),
            ),
            child: SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
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
                  child: action == AuthAction.signIn
                      ? const Text('Welcome to Nove, please sign in!')
                      : const Text('Welcome to Nove, please sign up!'),
                );
              },
              footerBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'By signing in, you agree to our Terms and Conditions.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const GoogleSignInButton(
                        loadingIndicator: Text('Loading'),
                        clientId: 'Assets/NoveLogo.jpg', // Note: clientId should be a valid Google OAuth client ID, not an image path
                      ),
                    ],
                  ),
                );
              },
              sideBuilder: (context, shrinkOffset) {
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
        return HomeScreen();
      },
    );
  }
}