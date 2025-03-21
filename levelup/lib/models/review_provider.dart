import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Review {
  final String course_id;
  final String userName;
  final String comment;
  final double rating;
  final DateTime timestamp;

  Review({
    required this.course_id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Review(
      course_id: doc.reference.parent.parent?.id ?? "",
      userName: data['username'] ?? data['user'] ?? 'Unknown User',
      comment: data['review'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] != null)
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];
  List<Map<String, dynamic>> _courses = [];

  List<Review> get reviews => _reviews;

  Future<String> fetchUserName(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.exists ? userDoc['username'] : 'Unknown User';
  }

  Future<void> fetchCourses() async {
    try {
      final response =
          await http.get(Uri.parse('http://172.20.10.6:3000/courses'));

      if (response.statusCode == 200) {
        final List<dynamic> courseData = json.decode(response.body);

        _courses = courseData
            .map((course) => Map<String, dynamic>.from(course))
            .toList();
        print("Fetched Courses: $_courses");

        notifyListeners();
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching courses: $error');
    }
  }

  // Get reviews for a specific course
  List<Review> getReviewsForCourse(String courseId) {
    print("Filtering reviews for course: $courseId");
    final filteredReviews =
        _reviews.where((review) => review.course_id == courseId).toList();
    print("Filtered reviews count: ${filteredReviews.length}");
    return filteredReviews;
  }

  Future<void> fetchReviews() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reviews').get();
    _reviews = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final userId = data['id'];
      final userName = await fetchUserName(userId);

      _reviews.add(Review(
        course_id: doc.reference.parent.parent?.id ?? "",
        userName: userName,
        comment: data['review'] ?? '',
        rating: (data['rating'] ?? 0.0).toDouble(),
        timestamp: (data['timestamp'] != null)
            ? (data['timestamp'] as Timestamp).toDate()
            : DateTime.now(),
      ));
    }

    notifyListeners();
  }

  // Update the course rating after a review is added
  void updateCourseRating(String courseId, double newRating) {
    try {
      print("Updating course rating for courseId: $courseId");

      final courseIndex =
          _courses.indexWhere((course) => course['id'] == courseId);

      if (courseIndex != -1) {
        final course = _courses[courseIndex];
        int countRating = course['countRating'] ?? 0;
        double oldRating = course['courseRating'] ?? 0.0;

        double totalRating = oldRating * countRating + newRating;
        countRating++;
        double updatedRating = totalRating / countRating;

        course['courseRating'] = updatedRating;
        course['countRating'] = countRating;

        notifyListeners();
      } else {
        print('Course not found for courseId: $courseId');
      }
    } catch (e) {
      print('Error updating course rating: $e');
    }
  }
}
