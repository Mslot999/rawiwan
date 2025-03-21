import 'package:LevelUp/models/user_provider.dart';
import 'package:LevelUp/pages/profile/edit_profile.dart';
import 'package:LevelUp/pages/profile/view_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

Future<void> fetchUserData() async {
  try {
    // Fetch the current user from FirebaseAuth
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Print current user's UID for debugging
      print("Current user UID: ${currentUser.uid}");

      // Query Firestore to fetch user data where the user is logged in
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        // Extract data from the document
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        // Check if the user is logged in
        if (data['isLoggedIn'] == true) {
          setState(() {
            userData = data;
          });
          print("Fetched user data: $data");
        } else {
          print("User is not logged in");
          setState(() {
            userData = null;
          });
        }
      } else {
        print("User document does not exist");
        setState(() {
          userData = null;
        });
      }
    } else {
      print("No user is currently logged in");
      setState(() {
        userData = null;
      });
    }
  } catch (e) {
    print("Error fetching user data: $e");
    setState(() {
      userData = null;
    });
  }
}



  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: const Color(0xFF295F98),
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: userData == null
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                Center(
                  child: Column(
                    children: [
                      // รูปโปรไฟล์
                      Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: userProvider.profileImage != null
                              ? DecorationImage(
                                  image: FileImage(userProvider.profileImage!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: userProvider.profileImage == null
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    size: 60.0,
                                    color: Colors.grey[400],
                                  ),
                                ],
                              )
                            : null,
                      ),
                      const SizedBox(height: 8.0),
                      // แสดงชื่อผู้ใช้จาก Firestore
                      Text(
                        userData?['username'] ??
                            'No Username', // แสดงจาก Firestore
                        style: const TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // แสดงอีเมลจาก Firestore
                      Text(
                        userData?['email'] ?? 'No Email', // แสดงจาก Firestore
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 21.0),
                _buildProfileButton(
                  context,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()),
                    );
                  },
                  icon: Icons.edit,
                  label: 'Edit/Update Your Profile',
                  backgroundColor: const Color.fromARGB(255, 230, 201, 255),
                ),
                const SizedBox(height: 16.0),
                _buildProfileButton(
                  context,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewProfilePage()),
                    );
                  },
                  icon: Icons.assignment_ind,
                  label: 'View Your Profile Detail',
                  backgroundColor: const Color.fromARGB(255, 230, 201, 255),
                ),
                const SizedBox(height: 16.0),
                _buildProfileButton(
                  context,
                  onPressed: () {
                    userProvider.logout(context);
                  },
                  icon: Icons.logout,
                  label: 'Logout',
                  backgroundColor: const Color.fromARGB(255, 250, 214, 216),
                ),
              ],
            ),
    );
  }

  ElevatedButton _buildProfileButton(BuildContext context,
      {required VoidCallback onPressed,
      required IconData icon,
      required String label,
      required Color backgroundColor}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
