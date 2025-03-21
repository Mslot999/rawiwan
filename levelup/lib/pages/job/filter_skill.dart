import 'package:flutter/material.dart';

class FilterSkill extends StatefulWidget {
  const FilterSkill({Key? key}) : super(key: key);

  @override
  _FilterSkillState createState() => _FilterSkillState();
}

class _FilterSkillState extends State<FilterSkill> {
  String selectedFilter = 'All'; 
  final List<String> skillOptions = ['PHP', 'Python', 'CSS', 'JavaScript', 'Dart']; 

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Skill Category'),
      content: SingleChildScrollView( 
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('All'),
              onTap: () {
                setState(() {
                  selectedFilter = 'All';
                });
              },
              selected: selectedFilter == 'All',
            ),
            Divider(), 
            ...skillOptions.map((skill) {
              return ListTile(
                title: Text(skill),
                onTap: () {
                  setState(() {
                    selectedFilter = skill;
                  });
                },
                selected: selectedFilter == skill,
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, selectedFilter); 
          },
          child: Text('Apply'),
        ),
      ],
    );
  }
}
