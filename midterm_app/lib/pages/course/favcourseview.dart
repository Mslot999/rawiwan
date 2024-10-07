import 'package:midterm_app/data/coursecard_data.dart';
import 'package:midterm_app/models/product_provider.dart';
import 'package:midterm_app/pages/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCoursesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Favorite Courses'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: courseProvider.favoriteCourses.isEmpty
              ? Center(
                  child: Text(
                    'No favorite courses yet!',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: courseProvider.favoriteCourses.length,
                  itemBuilder: (context, index) {
                    final courseId = courseProvider.favoriteCourses[index];

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
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: Image.asset(
                          courseData['courseImage'], 
                          width: 50,
                          height: 50,
                        ),
                        title: Text(courseData['courseName']),
                        subtitle: Text('\฿${courseData['coursePrice'].toStringAsFixed(2)}'), // แสดงราคาคอร์ส
                        trailing: IconButton(
                          icon: Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            courseProvider.toggleFavorite(courseId); 
                          },
                        ),
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
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
