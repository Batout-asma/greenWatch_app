import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:green_watch_app/components/text_box.dart';
import 'package:green_watch_app/components/my_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //user that is logged in
  final currentUser = FirebaseAuth.instance.currentUser;

  // collection
  final usersCollection = FirebaseFirestore.instance.collection("Users");
  // edit field
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(
            color: Color.fromARGB(255, 235, 235, 235),
          ),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
            color: Color.fromARGB(255, 235, 235, 235),
          ),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: const TextStyle(
              color: Color.fromARGB(255, 235, 235, 235),
            ),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          // cancel btn
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
          ),

          // save btn
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Color.fromARGB(255, 235, 235, 235),
              ),
            ),
          ),
        ],
      ),
    );

    //update in database
    if (currentUser != null) {
      final usersCollection = FirebaseFirestore.instance.collection("Users");
      String email = currentUser!.email!;

      if (newValue.trim().isNotEmpty) {
        await usersCollection.doc(email).update({field: newValue});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.green[600],
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // profile picture
                  const Icon(
                    Icons.person,
                    size: 72,
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  // Auto Username
                  Text(
                    currentUser!.email!.split('@')[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[800]),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // user infos
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'My Details',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),

                  // first name
                  MyTextBox(
                    // text: '',
                    text: userData['First_Name'],
                    sName: 'First_Name',
                    onPressed: () => editField('First_Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // last name
                  MyTextBox(
                    // text: '',
                    text: userData['Last_Name'],
                    sName: 'Last_Name',
                    onPressed: () => editField('Last_Name'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyButton(
                    onTap: () {},
                    text: 'Save Profile',
                    enabled: true,
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error${snapshot.error}"),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
