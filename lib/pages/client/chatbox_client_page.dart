import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:green_watch_app/components/my_drawer.dart';
import 'package:green_watch_app/models/conversation.dart';
import 'package:green_watch_app/pages/chat_page.dart';
import 'package:green_watch_app/pages/settings_page.dart' as my_settings;
import 'package:green_watch_app/pages/profile_page.dart';

class ChatBoxClient extends StatefulWidget {
  const ChatBoxClient({super.key});

  @override
  State<ChatBoxClient> createState() => _ChatBoxClientState();
}

class _ChatBoxClientState extends State<ChatBoxClient> {
  // Sign user out method
  void signUserOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    FirebaseAuth.instance.signOut();
                  },
                  child: const Text('Log Out')),
            ],
          );
        });
  }

  void goToSettingsPage() {
    // Pop menu drawer
    Navigator.pop(context);

    // Go to settings page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const my_settings.Settings(),
      ),
    );
  }

  void goToProfilePage() {
    // Pop menu drawer
    Navigator.pop(context);

    // Go to profile page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: const Text(
          'ChatBox',
          style: TextStyle(color: Colors.white),
        ),
      ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSettingsTap: goToSettingsPage,
        onLogOutTap: signUserOut,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Conversations')
            .where('sender', isEqualTo: user?.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final conversations = snapshot.data!.docs
              .map((doc) => Conversation.fromFirestore(doc))
              .toList();

          if (conversations.isEmpty) {
            return const Center(
              child: Text('No conversations found.'),
            );
          }

          return ListView(
            children: [
              const SizedBox(height: 25),
              // ChatBox subtitle
              Center(
                child: Text(
                  "Your Conversations",
                  style: TextStyle(color: Colors.green[900], fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final conversation = conversations[index];

                  final chatPartnerEmail = conversation.receiver == user?.email
                      ? conversation.sender
                      : conversation.receiver;
                  var ownername = chatPartnerEmail.split('@')[0];

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green.shade300,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListTile(
                          title: Text(ownername),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatPage(
                                  userEmail: user?.email,
                                  ownerEmail: chatPartnerEmail,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
