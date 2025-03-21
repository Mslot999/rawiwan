import 'package:LevelUp/components/company_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'detail_page.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  String selectedCategory = 'All';
  bool isSalaryExpanded = false;
  bool isAscending = true; 
  String searchQuery = '';
  List<Map<String, dynamic>> companies = [];

  @override
  void initState() {
    super.initState();
    _fetchCompanies();
  }

 
  Future<void> _fetchCompanies() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('companies').get();
      
      setState(() {
        companies = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'id': doc.id, 
            'companyName': data['companyName'] ?? '',
            'skillRequire': data['skillRequire'] ?? '',
            'companyImage': data['companyImage'] ?? '',
            'companyRating': (data['companyRating'] is int)
                ? (data['companyRating'] as int).toDouble()
                : data['companyRating'],
            'salary': data['salary'] ?? 0,
            'description': data['description'] ?? '',
          };
        }).toList();
      });
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }
  }


  void _onCategoryTap(String category) {
    setState(() {
      if (category == 'RATING') {
        isAscending = !isAscending; 
      } else if (category == 'SALARY') {
        isAscending = !isAscending; 
      }
      selectedCategory = category;
    });
  }

  
  List<Map<String, dynamic>> _getFilteredCompanies() {
    List<Map<String, dynamic>> filteredCompanies = List.from(companies);

   
    if (searchQuery.isNotEmpty) {
      filteredCompanies = filteredCompanies.where((company) {
        bool matchesName = company['companyName']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        bool matchesSkill = company['skillRequire']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());

        return matchesName || matchesSkill;
      }).toList();
    }

    
    if (selectedCategory == 'RATING') {
      filteredCompanies.sort((a, b) {
        if (isAscending) {
          return a['companyRating'].compareTo(b['companyRating']);
        } else {
          return b['companyRating'].compareTo(a['companyRating']);
        }
      });
    }

    
    if (selectedCategory == 'SALARY') {
      filteredCompanies.sort((a, b) {
        if (isAscending) {
          return a['salary'].compareTo(b['salary']);
        } else {
          return b['salary'].compareTo(a['salary']);
        }
      });
    }

    return filteredCompanies;
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
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF295F98)),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: companies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => _onCategoryTap('All'),
                        child: Text(
                          'All',
                          style: TextStyle(
                            color: selectedCategory == 'All'
                                ? Color(0xFF295F98)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => _onCategoryTap('RATING'),
                        child: Text(
                          'RATING',
                          style: TextStyle(
                            color: selectedCategory == 'RATING'
                                ? Color(0xFF295F98)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => _onCategoryTap('SALARY'),
                        child: Text(
                          'SALARY',
                          style: TextStyle(
                            color: selectedCategory == 'SALARY'
                                ? Color(0xFF295F98)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: CardGrid(nameList: _getFilteredCompanies())),
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
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            itemCount: nameList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CompanyDetail(
                        id: nameList[index]['id'],
                        companyName: nameList[index]['companyName'],
                        skillRequire: nameList[index]['skillRequire'],
                        companyImage: nameList[index]['companyImage'],
                        companyRating: nameList[index]['companyRating'],
                        salary: nameList[index]['salary'],
                        description: nameList[index]['description'],
                      ),
                    ),
                  );
                },
                child: CompanyList(
                  id: nameList[index]['id'],
                  companyName: nameList[index]['companyName'],
                  skillRequire: nameList[index]['skillRequire'],
                  companyImage: nameList[index]['companyImage'],
                  salary: nameList[index]['salary'],
                  companyRating: nameList[index]['companyRating'],
                  description: nameList[index]['description'],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
