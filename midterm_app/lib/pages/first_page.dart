import 'package:flutter/material.dart';
import 'package:midterm_app/pages/course/mycourse.dart';

class FirstPage extends StatelessWidget {
  final List<String> buttonNames = [
    'My Course',
    'Upskills',
    'Upskills2',
    'Upskills3',
    'Upskills4',
    'Upskills5',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LevelUp_Midterm'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(buttonNames.length, (index) {
          return InkWell(
            onTap: () {
              if (index == 0) {
                Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyCourseView()),
                    );
                return;
              }
              Navigator.pushNamed(context, '/${index + 1}');
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getIconForIndex(index),
                    size: 40.0,
                    color: Color(0xFF295F98),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    buttonNames[index],
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF295F98),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.school;
      case 1:
        return Icons.book;
      case 2:
        return Icons.work;
      case 3:
        return Icons.code;
      case 4:
        return Icons.computer;
      case 5:
        return Icons.star;
      default:
        return Icons.help; 
    }
  }
}
