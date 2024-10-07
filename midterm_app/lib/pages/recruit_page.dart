import 'package:midterm_app/components/recruit_list.dart';
import 'package:midterm_app/data/company_data.dart';
import 'package:midterm_app/pages/filter_skill.dart';
import 'package:flutter/material.dart';


class RecruitPage extends StatefulWidget {
  const RecruitPage({super.key});

  @override
  _RecruitPageState createState() => _RecruitPageState();
}

class _RecruitPageState extends State<RecruitPage> {
  List<Map<String, dynamic>> filteredList = RecruitCardData; // Initially, show all companies
  String searchQuery = '';

  void _filterSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredList = RecruitCardData
          .where((company) => company['companyname'].toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  void _showFilterDialog(BuildContext context) async {
  // Await the result from FilterCompany (the selected skill)
  final selectedSkill = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return const FilterSkill();  // Show the FilterCompany dialog
    },
  );

  // If a skill was selected (not null), filter the list
  if (selectedSkill != null) {
    setState(() {
      filteredList = RecruitCardData
          .where((company) => company['skillrequire'].toLowerCase().contains(selectedSkill.toLowerCase()))
          .toList();  // Filter the companies by selected skill
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: _filterSearch, 
                  decoration: InputDecoration(
                    hintText: 'Search Company',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showFilterDialog(context);
            },
            icon: Icon(Icons.filter_alt, color: Colors.deepPurple),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Related', style: TextStyle(color: Colors.deepPurple)),
                Text('|', style: TextStyle(color: Colors.grey)),
                Text('Latest', style: TextStyle(color: Colors.grey)),
                Text('|', style: TextStyle(color: Colors.grey)),
                Text('Popular', style: TextStyle(color: Colors.grey)),
                Text('|', style: TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    Text('Salary', style: TextStyle(color: Colors.grey)),
                    Icon(Icons.arrow_drop_down, color: Colors.grey),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: CardGrid(nameList: filteredList)),
        ],
      ),
    );
  }
}

class CardGrid extends StatelessWidget {
  const CardGrid({
    super.key,
    required this.nameList,
  });

  final List<Map<String, dynamic>> nameList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: nameList.length,
      itemBuilder: (context, index) {
        return RecruitList(
          companyname: nameList[index]['companyname'],
          skillrequire: nameList[index]['skillrequire'],
          companyImage: nameList[index]['companyImage'],
          companyRating: nameList[index]['companyRating'],
          salary: nameList[index]['salary'],
        );
      },
      padding: EdgeInsets.all(10.0),
    );
  }
}
