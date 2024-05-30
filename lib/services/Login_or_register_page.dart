// ignore_for_file: file_names

import 'package:green_watch_app/pages/login_page.dart';
import 'package:green_watch_app/pages/sign_up_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Init to Login page as first
  bool showLoginPage = true;

  // Toggle between Login and Sign Up pages
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LogIn(onTap: togglePages);
    } else {
      return SignUp(
        onTap: togglePages,
      );
    }
  }
}
