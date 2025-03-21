import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/user_provider.dart'; 



class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _username;
  String? _password;
  String? _email;
  String? _address;
  String? _phoneNumber;

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(48.0),
       
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Enter your first name',
                      labelText: 'First Name',
                    ),
                    validator: (value) => _validateTextField('First Name', value, 6),
                    onSaved: (newValue) {
                      _firstName = newValue;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Enter your last name',
                      labelText: 'Last Name',
                    ),
                    validator: (value) => _validateTextField('Last Name', value, 6),
                    onSaved: (newValue) {
                      _lastName = newValue;
                    },
                  ),
                  SizedBox(height: 20),

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

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Enter your email',
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email must not be empty';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _email = newValue;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Enter your address',
                      labelText: 'Address',
                    ),
                    onSaved: (newValue) {
                      _address = newValue;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      hintText: 'Enter your phone number',
                      labelText: 'Phone Number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone number must not be empty';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _phoneNumber = newValue;
                    },
                  ),
                  SizedBox(height: 20),

                 ElevatedButton(
  onPressed: () async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please correct the errors in the form')),
      );
      return;
    }

    _formKey.currentState!.save();

    try {
      await Provider.of<UserProvider>(context, listen: false).signUp(
        firstName: _firstName!,
        lastName: _lastName!,
        username: _username!,
        password: _password!,
        email: _email!,
        address: _address!,
        phoneNumber: _phoneNumber!,
      );

      // ไปที่หน้าloginหลังจากลงทะเบียนสำเร็จ
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign up failed: $e")),
      );
    }
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF295F98),
    foregroundColor: Colors.white,
  ),
  child: Text('Submit'),
),

                ],
              ),
            ),
          ),
        ),
    );
  }
}
