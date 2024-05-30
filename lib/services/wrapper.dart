import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:green_watch_app/pages/loading_page.dart';

import 'package:green_watch_app/services/layout_page.dart';
import 'package:green_watch_app/services/Login_or_register_page.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Simulate a delay for the loading screen
    await Future.delayed(const Duration(seconds: 2));

    // Check the authentication state
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen();
    } else {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          // User is logged in:
          if (snapshot.hasData) {
            return const Layout();
          }
          // User is NOT logged in:
          else {
            return const LoginOrRegister();
          }
        },
      );
    }
  }
}
