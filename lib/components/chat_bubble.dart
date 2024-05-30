import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isCurrentUser
            ? const Color.fromARGB(255, 236, 236, 236)
            : Colors.green.shade500,
      ),
      child: Text(
        message,
        style: isCurrentUser
            ? const TextStyle(fontSize: 18, color: Colors.black)
            : const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
