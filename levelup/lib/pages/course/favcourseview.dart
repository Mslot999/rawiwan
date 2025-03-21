import 'package:LevelUp/models/product_provider.dart';
import 'package:LevelUp/pages/course/course_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteCoursesView extends StatefulWidget {
  @override
  _FavoriteCoursesViewState createState() => _FavoriteCoursesViewState();
}

class _FavoriteCoursesViewState extends State<FavoriteCoursesView> {
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _fetchCourses(CourseProvider courseProvider) async {
    try {
      await courseProvider.fetchCourses();
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to fetch courses: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    if (_isLoading) {
      _fetchCourses(courseProvider);
    }

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
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Text(
                      'Error: $_errorMessage',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                : courseProvider.favoriteCourses.isEmpty
                    ? Center(
                        child: Text(
                          'No favorite courses yet!',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: courseProvider.favoriteCourses.length,
                        itemBuilder: (context, index) {
                          final favoriteCourse =
                              courseProvider.favoriteCourses[index];
                          final courseId = favoriteCourse.course_id;
                          final courseData =
                              courseProvider.getCourseById(courseId);

                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              leading: Image.asset(
                                courseData.image,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(courseData.name),
                              subtitle: Text(
                                  '฿${courseData.price.toStringAsFixed(2)}'),
                              trailing: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.red),
                                onPressed: () {
                                  courseProvider
                                      .toggleFavorite(courseData.course_id);
                                },
                              ),
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
                            ),
                          );
                        },
                      ));
  }
}
