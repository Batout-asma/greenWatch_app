import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_watch_app/components/my_button.dart';
import 'package:green_watch_app/components/my_textfield.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  Future passwordReset() async {
    // Loading circle
    showDialog(
      context: context,
      builder: (contest) {
        return const AlertDialog(
          content: Text('Password reset link sent succesfully!'),
        );
      },
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } on FirebaseAuthException {
      // End Loading
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // WRONG EMAIL
      showErrorMessage('Wrong Email!');
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            message,
            style: const TextStyle(color: Colors.black),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Enter your email and we will send you a password rest link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(
            height: 20,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
          ),

          const SizedBox(
            height: 25,
          ),

          MyButton(
            onTap: passwordReset,
            text: 'Reset Password',
            enabled: true,
          ),
          // MaterialButton(
          //   onPressed: () {},
          //   color: Colors.green,
          //   child: const Text('Reset Password'),
          // )
        ],
      ),
    );
  }
}
