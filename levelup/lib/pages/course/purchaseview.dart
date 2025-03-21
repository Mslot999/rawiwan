import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/product_provider.dart';
import 'package:LevelUp/pages/course/course_detail.dart';

class PurchasedCoursesView extends StatefulWidget {
  @override
  _PurchasedCoursesViewState createState() => _PurchasedCoursesViewState();
}

class _PurchasedCoursesViewState extends State<PurchasedCoursesView> {
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

    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Purchased Courses'),
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
                  : courseProvider.purchasedCourses.isEmpty
                      ? Center(
                          child: Text(
                            'No purchased courses yet!',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : ListView.builder(
                          itemCount: courseProvider.purchasedCourses.length,
                          itemBuilder: (context, index) {
                            final purchasedCourses =
                                courseProvider.purchasedCourses[index];
                            final courseId = purchasedCourses.course_id;
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
                                ),
                                title: Text(courseData.name),
                                subtitle: Text(
                                    '฿${courseData.price.toStringAsFixed(2)}'),
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
                        ),
        );
      },
    );
  }
}
