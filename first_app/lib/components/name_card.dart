
import 'package:flutter/material.dart';

class NameCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            height: 150.0,
            child: Image.asset('assets/images/121.png')
          ),
          Column(
            children:[
              Text('Name: Rawiwan Simmakum'),
              Text('DOB: 19 Dec 2001')
            ]
          )
          
        ]
      )
    );
  }
}
