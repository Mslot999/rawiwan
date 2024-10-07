import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:midterm_app/models/user_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String? _username;
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
                    hintText: 'Enter your username',
                    labelText: 'Username',
                  ),
                  validator: (value) => _validateTextField('Username', value, 6),
                  onSaved: (newValue) {
                    _username = newValue;
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

                    Provider.of<UserProvider>(context, listen: false).login(
                      _username!,
                      _password!, 
                    );

                    Navigator.of(context).pushReplacementNamed('/home');
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
