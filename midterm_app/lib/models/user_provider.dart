import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class UserProvider with ChangeNotifier {

  final List<Map<String, String>> _usersDatabase = [];

  String? _username;
  String? _password;
  bool _isLoggedIn = false;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _address;
  String? _phoneNumber;

  String? get username => _username;
  String? get password => _password;
  bool get isLoggedIn => _isLoggedIn;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get address => _address;
  String? get phoneNumber => _phoneNumber;

  
  void signUp({
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
      print("Hello $_firstName $_lastName");
    } else {
      print("Invalid username or password");
    }
    
    notifyListeners();
  }
}
