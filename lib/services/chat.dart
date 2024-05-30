import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_watch_app/models/message.dart';

class ChatService extends ChangeNotifier {
  // send message
  Future<void> sendMessage(String receiverEmail, String message) async {
    // get user info
    final String currentUserEmail =
        FirebaseAuth.instance.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create new message
    Message newMessage = Message(
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp);

    // create room chat
    List<String> emails = [currentUserEmail, receiverEmail];
    emails.sort();
    String chatRoom = emails.join("_");

    // store new message in database
    await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoom)
        .collection('Messages')
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    String chatRoom = emails.join("_");
    return FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(chatRoom)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
