import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/product_provider.dart';
import 'package:LevelUp/pages/course/course_detail.dart';
import 'package:LevelUp/pages/course/favcourseview.dart';
import 'package:LevelUp/pages/course/purchaseview.dart';

class MyCourseView extends StatefulWidget {
  @override
  _MyCourseViewState createState() => _MyCourseViewState();
}

class _MyCourseViewState extends State<MyCourseView> {
  @override
  void initState() {
    super.initState();
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    courseProvider
        .fetchCourses(); 
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.items.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          appBar: AppBar(
            title:
                Text('My Courses', style: TextStyle(color: Color(0xFF295F98))),
            backgroundColor: Color(0xFFF4F4F4),
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildCourseSection(
                  context,
                  title: 'My Favorite',
                  courses: courseProvider.favoriteCourses,
                  screenHeight: screenHeight,
                  onEmptyMessage: 'No favorite courses yet!',
                  onMorePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FavoriteCoursesView()),
                    );
                  },
                ),
                _buildCourseSection(
                  context,
                  title: 'My Purchased',
                  courses: courseProvider.purchasedCourses,
                  screenHeight: screenHeight,
                  onEmptyMessage: 'No purchased courses yet!',
                  onMorePressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PurchasedCoursesView()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCourseSection(
    BuildContext context, {
    required String title,
    required List<CourseItem> courses, 
    required double screenHeight,
    required String onEmptyMessage,
    required VoidCallback onMorePressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      height: screenHeight * 0.35,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF295F98)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF295F98),
                  foregroundColor: Colors.white,
                ),
                onPressed: onMorePressed,
                child: Text(
                  'More',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          if (courses.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                onEmptyMessage,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final courseData = courses[index]; 

                  return _buildCourseCard(
                      context, courseData); 
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseItem courseData) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CourseDetail(
                courseId: courseData.course_id,
                courseName: '',
                coursePrice: 0,
                courseImage: '',
                courseRating: 0,
                tutorName: '',
                category: [],
                isFavorite: false,
                isPurchased: false,
              ),
            ),
          );
        },
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(courseData.image),
              fit: BoxFit.cover,
            ),
          ),
          child: ListTile(
            title: Text(
              courseData.name,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
