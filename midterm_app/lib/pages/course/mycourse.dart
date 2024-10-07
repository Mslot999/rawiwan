import 'package:midterm_app/data/coursecard_data.dart';
import 'package:midterm_app/models/product_provider.dart';
import 'package:midterm_app/pages/course/course_detail.dart';
import 'package:midterm_app/pages/course/favcourseview.dart';
import 'package:midterm_app/pages/course/purchaseview.dart'; 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyCourseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF4F4F4), 
          appBar: AppBar(
            title: Text('My Courses', style: TextStyle(color: Color(0xFF295F98))),
            backgroundColor: Color(0xFFF4F4F4),
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
                      MaterialPageRoute(builder: (context) => FavoriteCoursesView()),
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
                      MaterialPageRoute(builder: (context) => PurchasedCoursesView()),
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

  Widget _buildCourseSection(BuildContext context, {
    required String title,
    required List<String> courses,
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
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF295F98)),
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
                  final courseId = courses[index];
                  final courseData = CourseCardData.firstWhere(
                    (course) => course['courseId'] == courseId,
                    orElse: () => {
                      'courseName': 'Unknown',
                      'courseImage': 'assets/images/default_image.png',
                      'coursePrice': 0.0,
                      'courseRating': 0.0,
                      'tutorName': 'Unknown',
                    },
                  );

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
                              courseId: courseData['courseId'],
                              courseName: courseData['courseName'],
                              coursePrice: courseData['coursePrice'],
                              courseImage: courseData['courseImage'],
                              courseRating: courseData['courseRating'],
                              tutorName: courseData['tutorName'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(courseData['courseImage']),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            courseData['courseName'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
