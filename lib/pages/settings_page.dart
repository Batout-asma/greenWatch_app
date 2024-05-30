import 'package:flutter/material.dart';
import 'package:green_watch_app/components/my_button.dart';
import 'package:green_watch_app/pages/forgot_pw_page.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void goToForgotPasswordPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          const SizedBox(
            height: 20,
          ),
          MyButton(
            onTap: goToForgotPasswordPage,
            text: 'Get Password',
            enabled: true,
          ),
        ],
      ),
    );
  }
}
