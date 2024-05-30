import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final String sender;
  final String receiver;

  Conversation({
    required this.id,
    required this.sender,
    required this.receiver,
  });

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Conversation(
        id: doc.id, sender: data['sender'], receiver: data['receiver']);
  }

  Map<String, dynamic> toFirestore() {
    return {'sender': sender, 'receiver': receiver};
  }
}
