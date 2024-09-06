
import 'package:flutter/material.dart';

class ThirdPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Third Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert),
            onPressed: () {},
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/1');
            },
            icon: Icon(Icons.home)
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show message'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
              content: const Text('Hello'),
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {
 
                },
                ),
              ),
            );        
            },
        ),
      ),
    );
  }
}