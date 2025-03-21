import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  //final List<Map<String, String>> _usersDatabase = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _username;
  String? _password;
  bool _isLoggedIn = false;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _address;
  String? _phoneNumber;
  File? _profileImage;

  String? get username => _username;
  String? get password => _password;
  bool get isLoggedIn => _isLoggedIn;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get address => _address;
  String? get phoneNumber => _phoneNumber;
  File? get profileImage => _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    // Request permission to access photos
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      // Open the gallery and pick an image
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
        notifyListeners();
      }
    } else {
      print("Permission to access gallery denied");
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String address,
    required String phoneNumber,
  }) async {
    try {
      // สร้างบัญชีผู้ใช้ใน Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // บันทึกข้อมูลผู้ใช้ใน Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        'address': address,
        'phoneNumber': phoneNumber,
        'password': password,
      });

      _username = username;
      _email = email;
      _firstName = firstName;
      _lastName = lastName;
      _address = address;
      _phoneNumber = phoneNumber;
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      print("Sign up failed: $e");
      rethrow;
    }
  }

  // Future<void> login(String email, String password) async {
  //   try {
  //     UserCredential userCredential = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     DocumentSnapshot userDoc = await _firestore
  //         .collection('users')
  //         .doc(userCredential.user!.uid)
  //         .get();

  //     if (userDoc.exists) {
  //       var userData = userDoc.data() as Map<String, dynamic>;

  //       // อัปเดตข้อมูลผู้ใช้ใน UserProvider
  //       updateProfile(
  //         firstName: userData['firstName'],
  //         lastName: userData['lastName'],
  //         username: userData['username'],
  //         email: userData['email'],
  //         address: userData['address'],
  //         phoneNumber: userData['phoneNumber'],
  //       );

  //       // อัปเดต isLoggedIn เป็น true ใน Firestore
  //       await _firestore
  //           .collection('users')
  //           .doc(userCredential.user!.uid)
  //           .update({
  //         'isLoggedIn': true,
  //       });

  //       _isLoggedIn = true; // อัปเดตสถานะในแอป
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     print("Login failed: $e");
  //     rethrow;
  //   }
  // }

  /*void signUp({
    required String firstName,
    required String lastName,
    required String username,
    required String password,
    required String email,
    required String address,
    required String phoneNumber,
  }) {
    _usersDatabase.add({
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    });
    print("User registered: $username, $email");
    notifyListeners();
  }

  void login(String username, String password) {
    final user = _usersDatabase.firstWhere(
      (user) => user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      _username = username;
      _password = password; 
      _isLoggedIn = true;
      _firstName = user['firstName'];
      _lastName = user['lastName'];
      _phoneNumber = user['phoneNumber'];
      _email = user['email'];
      _address = user['address'];
      print("Hello $_firstName $_lastName");
    } else {
      print("Invalid username or password");
    }

    notifyListeners();
  }*/

  void updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? address,
    String? phoneNumber,
    String? password,
    File? profileImage,
  }) {
    if (firstName != null) _firstName = firstName;
    if (lastName != null) _lastName = lastName;
    if (username != null) _username = username;
    if (email != null) _email = email;
    if (address != null) _address = address;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (password != null) _password = password;
    if (profileImage != null) _profileImage = profileImage;

    // อัปเดตข้อมูลใน Firestore
    if (_auth.currentUser != null) {
      updateUserProfileInFirestore(
        uid: _auth.currentUser!.uid, // ใช้ UID จาก Firebase Authentication
        firstName: firstName,
        lastName: lastName,
        username: username,
        email: email,
        address: address,
        phoneNumber: phoneNumber,
        profileImage: profileImage,
        password: password,
      );
    }
    notifyListeners();
  }

  Future<void> updateUserProfileInFirestore({
    required String uid,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? address,
    String? phoneNumber,
    File? profileImage,
    String? password,
  }) async {
    try {
      Map<String, dynamic> updatedData = {};

      if (firstName != null) updatedData['firstName'] = firstName;
      if (lastName != null) updatedData['lastName'] = lastName;
      if (username != null) updatedData['username'] = username;
      if (email != null) updatedData['email'] = email;
      if (address != null) updatedData['address'] = address;
      if (phoneNumber != null) updatedData['phoneNumber'] = phoneNumber;
      if (profileImage != null) updatedData['profileImage'] = profileImage.path;
      if (password != null) updatedData['password'] = password;

      // อัปเดตข้อมูลใน Firestore
      await _firestore.collection('users').doc(uid).update(updatedData);
    } catch (e) {
      print("Failed to update user profile: $e");
      rethrow;
    }
  }

  void updateProfileImage(File? newImage) {
    _profileImage = newImage;
    notifyListeners();
  }

Future<void> logout(BuildContext context) async {
  try {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      print("Current user UID: ${currentUser.uid}");

      // Update isLogging = false in Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .update({'isLoggedIn': false});
      print("User isLoggedIn set to false successfully");

      // Sign out the user
      await _auth.signOut();
      print("User signed out successfully");

      // Redirect to login page
      Navigator.pushReplacementNamed(context, '/');
      print("Navigation to login page succeeded");
    } else {
      print("No user is currently logged in.");
    }
  } catch (e) {
    print("Error logging out: $e");
  }
}

}
