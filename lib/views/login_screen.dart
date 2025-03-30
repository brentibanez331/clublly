import 'dart:developer';

import 'package:clublly/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:clublly/main.dart';
import 'package:clublly/views/profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  void _setupAuthListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Onboarding()),
        );
      }
    });
  }

  Future<AuthResponse> _googleSignIn() async {
    // For Android, you don't need to provide clientId or serverClientId in the constructor
    // final GoogleSignIn googleSignIn = GoogleSignIn(
    //   scopes: ['email', 'profile'],
    // );

    var webClientId = dotenv.env['WEB_CLIENT_ID'] ?? '';

    final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);

    try {
      // Handle possible null return (if user cancels)
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google Sign In was canceled by user';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      return supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (error) {
      log('Google sign in error: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: _googleSignIn,
          child: const Text('Google login'),
        ),
      ),
    );
  }
}
