import 'package:flutter/material.dart';

class FilterSkill extends StatelessWidget {
  const FilterSkill({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Filter Skill'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('your skill:', style: TextStyle(fontWeight: FontWeight.bold)),
            ListTile(
              title: Text('PHP'),
              onTap: () {
                Navigator.of(context).pop('PHP');  // Pass 'PHP' back when selected
              },
            ),
            ListTile(
              title: Text('JAVASCRIPT'),
              onTap: () {
                Navigator.of(context).pop('JAVASCRIPT');  // Pass 'JAVASCRIPT' back when selected
              },
            ),
            ListTile(
              title: Text('HTML'),
              onTap: () {
                Navigator.of(context).pop('HTML');  // Pass 'HTML' back when selected
              },
            ),
            ListTile(
              title: Text('CSS'),
              onTap: () {
                Navigator.of(context).pop('CSS');  // Pass 'CSS' back when selected
              },
            ),
            Divider(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();  // Close dialog without selecting
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}
