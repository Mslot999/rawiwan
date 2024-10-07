import 'package:flutter/material.dart';

class FilterCourse extends StatelessWidget {
  const FilterCourse({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Courses'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Field:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('Front-end'),
              onTap: () {
                Navigator.of(context).pop('Front-end');
              },
            ),
            ListTile(
              title: Text('Back-end'),
              onTap: () {
                Navigator.of(context).pop('Back-end');
              },
            ),
            ListTile(
              title: Text('Web Development'),
              onTap: () {
                Navigator.of(context).pop('Web Development');
              },
            ),
            ListTile(
              title: Text('Data Analytics'),
              onTap: () {
                Navigator.of(context).pop('Data Analytics');
              },
            ),
            Divider(),
            Text('Tuters:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('KongRuksiam'),
              onTap: () {
                Navigator.of(context).pop('KongRuksiam');
              },
            ),
            ListTile(
              title: Text('BorntoDev'),
              onTap: () {
                Navigator.of(context).pop('BorntoDev');
              },
            ),
            ListTile(
              title: Text('Zinglecode'),
              onTap: () {
                Navigator.of(context).pop('Zinglecode');
              },
            ),

          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
