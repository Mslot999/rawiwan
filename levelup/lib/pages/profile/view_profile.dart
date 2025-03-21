import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:LevelUp/models/user_provider.dart';

class ViewProfilePage extends StatefulWidget {
  @override
  _ViewProfilePageState createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  User? currentUser;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
          });
        } else {
          print("User document not found");
        }
      } catch (e) {
        print("Error fetching user data: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Reusable style variables
    const textColor = Color(0xFF295F98);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: textColor,
        title: const Text('View Your Profile Detail'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Loading state
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                ListTile(
                  title: const Text('Firstname:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['firstName'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Lastname:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['lastName'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Username:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['username'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Email:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['email'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Address:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['address'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: const Text('Phone Number:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  subtitle: Text(userData?['phoneNumber'] ?? 'Not available'),
                  tileColor: Color.fromARGB(255, 216, 230, 236),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Profile Picture:', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                ),
                userProvider.profileImage != null
                    ? FutureBuilder(
                        future: _loadImage(userProvider.profileImage!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Text('Error loading image', style: TextStyle(color: Colors.red));
                          } else {
                            return Image.file(
                              userProvider.profileImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                                return child;
                              },
                            );
                          }
                        },
                      )
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('No image available', style: TextStyle(color: Colors.grey)),
                      ),
              ],
            ),
    );
  }

  Future<void> _loadImage(File image) async {
    // This function can be used to load an image and return a result if needed
  }
}
