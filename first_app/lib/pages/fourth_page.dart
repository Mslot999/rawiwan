import 'package:flutter/material.dart';

class FourthPage extends StatefulWidget{
  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  final _formkey = GlobalKey<FormState>();
  String? _name;
  String? _famName;
  int _nameLength = 0;
  bool _showPass = false;

  String? _validateTextField(String fieldName, String? value, int length){
    if (value!.isEmpty) {
      return '$fieldName must not to be empty';
      }
    if (value.length <= length) {
      return '$fieldName must longer than 6 chars';
      }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Fourth Page'),
        
      ),
      body: Form(
        key: _formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.person),
                  hintText: 'Enter your name',
                  labelText: 'Name',
                  suffixText: '$_nameLength',
                ),
                validator: (value) {
                  return _validateTextField('Name', value, 6);
                },
                onSaved: (newValue) {
                  _name = newValue;
                },
                onChanged: (value) {
                  setState(() {
                    _nameLength = value.length;

                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Length: $_nameLength'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  icon: Icon(Icons.group),
                  hintText: 'Enter your surname',
                  labelText: 'Family Name',
                ),
                validator: (value) => _validateTextField('Family Name', value, 6), //=>แบบย่อใช้แทนreturn
                onSaved: (newValue){
                  _famName =newValue;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                obscureText: !_showPass,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.security),
                  suffixIcon: GestureDetector(
                    onLongPress: () async {
                      setState(() {
                        _showPass = true;
                      });

                      await Future.delayed(Duration(
                        seconds: 2
                        ));
                      setState(() {
                        _showPass = false;
                      });
                    },
                    child: Icon(Icons.remove_red_eye)),
                  hintText: 'Enter your password',
                  labelText: 'Password',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: (){            
                  if (!_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Your input is not valid.'),
                      ),
                    );   

                    return;                
                  }    

                  _formkey.currentState!.save();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Hello $_name $_famName'),
                      ),
                  );    
                }, 
                child: Text('Submit')
              ),
            ),
          ],
        ),
      ),
    );
  }
}