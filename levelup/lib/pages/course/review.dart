import 'package:LevelUp/models/product_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AddReview extends StatefulWidget {
  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  double rating = 0.0;
  final TextEditingController reviewController = TextEditingController();
  bool isAnonymous = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false).fetchCourses();
    });
  }

  Future<void> confirmReview(String courseId, String userName) async {
    try {
      DocumentReference courseRef =
          FirebaseFirestore.instance.collection('courses').doc(courseId);

      await courseRef.collection('reviews').add({
        'rating': rating,
        'review': reviewController.text.trim(), // ไม่บังคับให้กรอก
        'user': isAnonymous ? 'ไม่ระบุตัวตน' : userName,
        'timestamp': FieldValue.serverTimestamp(),
      });

      QuerySnapshot reviewSnapshot = await courseRef.collection('reviews').get();
      double totalRating = 0.0;
      int reviewCount = reviewSnapshot.size;

      reviewSnapshot.docs.forEach((doc) {
        totalRating += (doc['rating'] as num).toDouble();
      });

      double newAverageRating = reviewCount > 0 ? totalRating / reviewCount : 0.0;
      await courseRef.update({'courseRating': newAverageRating, 'countRating': reviewCount});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('รีวิวถูกบันทึกเรียบร้อย!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final boughtCourses = courseProvider.purchasedCourses;

    if (boughtCourses.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Review'),
          foregroundColor: Color(0xFF295F98),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(child: Text('No courses purchased for review.')),
      );
    }

    final selectedCourse = boughtCourses[0];
final user = FirebaseAuth.instance.currentUser;
final userName = user?.displayName ?? 'Unknown User'; // ใช้ displayName จาก Firebase Auth

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
        foregroundColor: Color(0xFF295F98),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmReview(selectedCourse.course_id, userName);
            },
            style: TextButton.styleFrom(foregroundColor: Color(0xFF295F98)),
            child: Text('Confirm'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.only(bottom: 16.0),
                child: ListTile(
                  leading: Image.asset(
                    selectedCourse.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    selectedCourse.name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tutor: ${selectedCourse.tutorName}', style: TextStyle(fontSize: 14)),
                      Text('Price: ${selectedCourse.price} ฿', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
              Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (newRating) {
                    setState(() {
                      rating = newRating;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: reviewController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Write your review (optional)...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        isAnonymous = value!;
                      });
                    },
                  ),
                  Text('โพสต์แบบไม่ระบุตัวตน')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
