import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool _showPass = false;

  String? _validateTextField(String fieldName, String? value, int minLength) {
    if (value == null || value.isEmpty) {
      return '$fieldName must not be empty';
    }
    if (value.length < minLength) {
      return '$fieldName must be longer than $minLength characters';
    }
    return null;
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email!, password: _password!);

      if (userCredential.user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'isLoggedIn': true});

        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                  validator: (value) => _validateTextField('Email', value, 6),
                  onSaved: (newValue) {
                    _email = newValue;
                  },
                ),
                SizedBox(height: 20),

                TextFormField(
                  obscureText: !_showPass,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    hintText: 'Enter your password',
                    labelText: 'Password',
                    suffixIcon: GestureDetector(
                      onLongPress: () async {
                        setState(() {
                          _showPass = true;
                        });
                        await Future.delayed(Duration(seconds: 2));
                        setState(() {
                          _showPass = false;
                        });
                      },
                      child: Icon(Icons.remove_red_eye),
                    ),
                  ),
                  validator: (value) => _validateTextField('Password', value, 6),
                  onSaved: (newValue) {
                    _password = newValue;
                  },
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please correct the errors in the form'),
                        ),
                      );
                      return;
                    }

                    _formKey.currentState!.save();

                    _signInWithEmailAndPassword();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF295F98),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Sign In'),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/signup');
                  },
                  child: Text('Don\'t have an account? Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
