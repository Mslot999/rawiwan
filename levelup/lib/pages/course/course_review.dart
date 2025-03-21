import 'package:LevelUp/models/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseReviewsPage extends StatefulWidget {
  @override
  _CourseReviewsPageState createState() => _CourseReviewsPageState();
}

class _CourseReviewsPageState extends State<CourseReviewsPage> {
  late Future<void> _reviewsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final courseId = ModalRoute.of(context)!.settings.arguments as String;
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);

    _reviewsFuture = courseProvider.fetchReviewsForCourse(courseId);
  }

  @override
  Widget build(BuildContext context) {
    final courseId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Course Reviews'),
        foregroundColor: Color(0xFF295F98),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error loading reviews"));
          }

          return Consumer<CourseProvider>(
            builder: (context, courseProvider, child) {
              final reviews = courseProvider.getReviewsForCourse(courseId);

              print("UI reviews count: ${reviews.length}");

              if (reviews.isEmpty) {
                return Center(
                    child: Text('No reviews yet.',
                        style: TextStyle(fontSize: 18)));
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.userName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 18,
                                  );
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            review.comment,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
