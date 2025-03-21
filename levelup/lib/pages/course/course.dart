import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:LevelUp/components/course_card.dart';
import 'package:LevelUp/models/product_provider.dart';
import 'package:LevelUp/pages/course/cartview.dart';
import 'package:LevelUp/pages/course/course_detail.dart';
import 'package:LevelUp/pages/course/filter_course.dart';
import 'package:provider/provider.dart';

class CoursePage extends StatefulWidget {
  const CoursePage({super.key});

  @override
  _CoursePageState createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  String selectedCategory = 'All';
  bool isPriceExpanded = false;
  bool isAscending = true;
  String searchQuery = '';
  List<Map<String, dynamic>> courses = [];
  bool isFavorite = false; 
  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      setState(() {
        courses = snapshot.docs.map((doc) {
          final data = doc.data();
          return {
            'course_id': doc.id, 
            'courseName': data['courseName'] ?? '',
            'coursePrice': data['coursePrice']?.toDouble() ?? 0.0,
            'courseImage': data['courseImage'] ?? '',
            'courseRating': data['courseRating']?.toDouble() ?? 0.0,
            'courseAddedDate': data['courseAddedDate'] ?? '',
            'category': List<String>.from(data['category'] ?? []),
            'tutorName': data['tutorName'] ?? '',
          };
        }).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching courses: $error')),
      );
    }
  }

  void _showFilterDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const FilterCourse();
      },
    );

    if (result != null) {
      setState(() {
        selectedCategory = result;
      });
    }
  }

  void _onCategoryTap(String category) {
    setState(() {
      if (category == 'Price') {
        isPriceExpanded = !isPriceExpanded;
        isAscending = !isAscending;
      } else {
        isPriceExpanded = false;
      }
      selectedCategory = category;
    });
  }

  List<Map<String, dynamic>> _getFilteredCourses() {
    List<Map<String, dynamic>> filteredCourses = List.from(courses);

    if (searchQuery.isNotEmpty) {
      filteredCourses = filteredCourses.where((course) {
        return course['courseName']
            .toString()
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    } else if (selectedCategory == 'All') {
      return filteredCourses;
    } else if (selectedCategory == 'Price') {
      filteredCourses.sort((a, b) {
        if (isAscending) {
          return a['coursePrice'].compareTo(b['coursePrice']);
        } else {
          return b['coursePrice'].compareTo(a['coursePrice']);
        }
      });
    } else if (selectedCategory == 'Latest') {
      filteredCourses.sort((a, b) {
        DateTime dateA = DateTime.parse(a['courseAddedDate']);
        DateTime dateB = DateTime.parse(b['courseAddedDate']);
        return dateB.compareTo(dateA);
      });
    } else if (selectedCategory == 'Popular') {
      filteredCourses.sort((a, b) {
        return b['courseRating'].compareTo(a['courseRating']);
      });
    } else {
      filteredCourses = filteredCourses.where((course) {
        var categories = course['category'];
        return categories != null && categories.contains(selectedCategory);
      }).toList();
    }

    return filteredCourses;
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
                    hintText: 'Search Courses',
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
            icon: Icon(Icons.filter_alt, color: Color(0xFF295F98)),
          ),
          Consumer<CourseProvider>(
            builder: (context, courseProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Cartview(),
                        ),
                      );
                    },
                    icon: Icon(Icons.shopping_cart_rounded,
                        color: Color(0xFF295F98)),
                  ),
                  if (courseProvider.cartItemCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${courseProvider.cartItemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: courses.isEmpty
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
                        onTap: () => _onCategoryTap('Latest'),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            color: selectedCategory == 'Latest'
                                ? Color(0xFF295F98)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => _onCategoryTap('Popular'),
                        child: Text(
                          'Popular',
                          style: TextStyle(
                            color: selectedCategory == 'Popular'
                                ? Color(0xFF295F98)
                                : Colors.grey,
                          ),
                        ),
                      ),
                      Text('|', style: TextStyle(color: Colors.grey)),
                      GestureDetector(
                        onTap: () => _onCategoryTap('Price'),
                        child: Row(
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                color: selectedCategory == 'Price'
                                    ? Color(0xFF295F98)
                                    : Colors.grey,
                              ),
                            ),
                            Icon(
                              isPriceExpanded
                                  ? Icons.arrow_drop_down
                                  : Icons.arrow_drop_up,
                              color: selectedCategory == 'Price'
                                  ? Color(0xFF295F98)
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: CardGrid(nameList: _getFilteredCourses())),
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
        bool isFavorite = nameList[index]['isFavorite'] ?? false;
        bool isPurchased = nameList[index]['isPurchased'] ?? false;

        return GestureDetector(
          onTap: () {
            print('Tapped on: ${nameList[index]['courseName']}');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetail(
                  courseId: nameList[index]['course_id'],
                  courseName: nameList[index]['courseName'],
                  coursePrice: nameList[index]['coursePrice'],
                  courseImage: nameList[index]['courseImage'],
                  courseRating: nameList[index]['courseRating'],
                  tutorName: nameList[index]['tutorName'],
                  category: List<String>.from(nameList[index]['category']),
                  isFavorite: isFavorite,
                  isPurchased: isPurchased,
                ),
              ),
            );
          },
          child: CourseCard(
            courseName: nameList[index]['courseName'],
            coursePrice: nameList[index]['coursePrice'],
            courseImage: nameList[index]['courseImage'],
            courseRating: nameList[index]['courseRating'],
          ),
        );
      },
    );
  }
}
