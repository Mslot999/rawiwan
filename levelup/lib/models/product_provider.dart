import 'package:LevelUp/models/review_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseItem {
  final String course_id;
  final String name;
  final double price;
  final String image;
  final double rating;
  final String tutorName;
  final List<String> category;
  bool isFavorite;
  bool isPurchased;

  CourseItem({
    required this.course_id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.tutorName,
    required this.category,
    this.isFavorite = false,
    this.isPurchased = false,
  });

  CourseItem.fromJson(Map<String, dynamic> json)
      : course_id = json['course_id'] ?? '',
        name = json['courseName'] ?? '',
        price = (json['coursePrice'] ?? 0.0).toDouble(),
        image = json['courseImage'] ?? '',
        rating = (json['courseRating'] ?? 0.0).toDouble(),
        tutorName = json['tutorName'] ?? '',
        category = List<String>.from(json['category'] ?? []),
        isFavorite = json['isFavorite'] ?? false,
        isPurchased = json['isPurchased'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'course_id': course_id,
      'courseName': name,
      'coursePrice': price,
      'courseRating': rating,
      'tutorName': tutorName,
      'category': category,
      'isFavorite': isFavorite,
      'isPurchased': isPurchased,
    };
  }
}

class CourseProvider with ChangeNotifier {
  List<Review> _reviews = [];

  List<CourseItem> _items = [];
  List<CourseItem> _cartItems = [];
  List<CourseItem> _purchasedCourses = [];
  List<CourseItem> _favoriteCourses = [];

  List<CourseItem> get items => _items;
  List<CourseItem> get cartItems => _cartItems;
  List<CourseItem> get purchasedCourses => _purchasedCourses;
  List<CourseItem> get favoriteCourses => _favoriteCourses;

  CourseItem getCourseById(String course_id) {
    return items.firstWhere(
      (course) => course.course_id == course_id,
      orElse: () => CourseItem(
          course_id: '',
          name: '',
          price: 0.0,
          image: '',
          rating: 0.0,
          tutorName: '',
          category: [],
          isFavorite: false,
          isPurchased: false),
    );
  }

  Future<void> fetchReviewsForCourse(String course_id) async {
    try {
      print('Fetching reviews for course: $course_id');

      final snapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(course_id)
          .collection('reviews')
          .get();

      _reviews = snapshot.docs.map((doc) {
        print('Review found: ${doc.data()}');
        return Review.fromFirestore(doc);
      }).toList();

      print('Total reviews fetched: ${_reviews.length}');
      print('Calling notifyListeners()...');
      notifyListeners();
      print('notifyListeners() called');
    } catch (e) {
      print('Error fetching reviews: $e');
    }
  }

  List<Review> getReviewsForCourse(String course_id) {
    return _reviews.where((review) => review.course_id == course_id).toList();
  }

  Future<void> fetchCourses() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('courses').get();
      _items = snapshot.docs
          .map((doc) =>
              CourseItem.fromJson({...doc.data(), 'course_id': doc.id}))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }

  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.price);

  String get formattedTotalPrice {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(totalPrice);
  }

  // cart
  int get cartItemCount => _cartItems.length;

  bool isItemInCart(String courseId) {
    return cartItems.any((item) => item.course_id == courseId);
  }

  Future<void> addItemToCart(String courseId) async {
    try {
      final course = _items.firstWhere((item) => item.course_id == courseId);
      if (!_cartItems.contains(course)) {
        _cartItems.add(course);

        await FirebaseFirestore.instance.collection('cart').add({
          'course_id': course.course_id,
          'name': course.name,
          'price': course.price,
          'image': course.image,
          'rating': course.rating,
          'tutorName': course.tutorName,
          'category': course.category,
          'isFavorite': course.isFavorite,
          'isPurchased': course.isPurchased,
        });

        notifyListeners();
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  Future<void> fetchCartItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cart').get();
      _cartItems = snapshot.docs
          .map((doc) => CourseItem.fromJson({
                ...doc.data(),
                'course_id': doc.id,
              }))
          .toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching cart items: $e');
    }
  }

  Future<void> removeItemFromCart(String courseId) async {
    try {
      final cartSnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .where('course_id', isEqualTo: courseId)
          .get();

      for (var doc in cartSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(doc.id)
            .delete();
      }

      _cartItems.removeWhere((item) => item.course_id == courseId);
      notifyListeners();
    } catch (e) {
      print('Error removing item from cart: $e');
    }
  }

  Future<void> clearCart() async {
    try {
      final cartSnapshot =
          await FirebaseFirestore.instance.collection('cart').get();
      for (var doc in cartSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(doc.id)
            .delete();
      }

      _cartItems.clear();
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  // purchase
  bool isPurchased(String courseId) {
    return purchasedCourses.any((course) => course.course_id == courseId);
  }

  Future<void> addDirectPurchaseItem(String courseId) async {
    final course = _items.firstWhere((item) => item.course_id == courseId);
    if (!course.isPurchased) {
      try {
        await FirebaseFirestore.instance.collection('courses').doc(courseId);
      } catch (e) {
        print('Error in setting initial status: $e');
      }
    }
  }

  Future<void> checkoutCart() async {
    for (var course in _cartItems) {
      if (!course.isPurchased) {
        course.isPurchased = true;
        _purchasedCourses.add(course);
        try {
          await FirebaseFirestore.instance
              .collection('courses')
              .doc(course.course_id)
              .update({'isPurchased': true});
        } catch (e) {
          print('Error purchasing course ${course.course_id}: $e');
        }
      }
    }
    _cartItems.clear();
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('cart').get();
      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('cart')
            .doc(doc.id)
            .delete();
      }
      notifyListeners();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  Future<void> purchaseCourse(String courseId) async {
    final courseIndex = _items.indexWhere((item) => item.course_id == courseId);

    if (courseIndex != -1 && !_items[courseIndex].isPurchased) {
      final currentStatus = _items[courseIndex].isPurchased;
      final newStatus = !currentStatus;

      _items[courseIndex].isPurchased = newStatus;

      if (newStatus) {
        _purchasedCourses.add(_items[courseIndex]);
      } else {
        _purchasedCourses.removeWhere((item) => item.course_id == courseId);
      }

      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(courseId)
            .update({'isPurchased': newStatus});
      } catch (error) {
        final courseIndex =
            _items.indexWhere((item) => item.course_id == courseId);
        if (courseIndex != -1) {
          final currentStatus = _items[courseIndex].isPurchased;
          final newStatus = !currentStatus;

          _items[courseIndex].isPurchased = currentStatus;

          if (newStatus) {
            _purchasedCourses.add(_items[courseIndex]);
          } else {
            _purchasedCourses.removeWhere((item) => item.course_id == courseId);
          }

          notifyListeners();
        }

        print('Error purchasing course: $error');
      }
    }
  }

  void confirmPurchase(List<String> courseIds) async {
    List<CourseItem> coursesToPurchase = [];

    for (var courseId in courseIds) {
      final course = cartItems.firstWhere((item) => item.course_id == courseId,
          orElse: () => CourseItem(
              course_id: '',
              name: '',
              price: 0.0,
              image: '',
              rating: 0.0,
              tutorName: '',
              category: [],
              isFavorite: false,
              isPurchased: false));

      if (course.course_id.isNotEmpty) {
        coursesToPurchase.add(course);
      }
    }

    for (var course in coursesToPurchase) {
      purchasedCourses.add(course);

      cartItems.remove(course);

      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(course.course_id)
            .update({'isPurchased': true});

        print('Course ${course.course_id} marked as isPurchased in Firebase.');
      } catch (error) {
        print('Error updating Firebase for course ${course.course_id}: $error');
      }
    }

    notifyListeners();
  }

  void purchaseAllCourses(List<String> courseIds) {
    for (var courseId in courseIds) {
      purchaseCourse(courseId);
    }
  }

  // fav
  Future<void> toggleFavorite(String id) async {
    final courseIndex = _items.indexWhere((course) => course.course_id == id);

    if (courseIndex != -1) {
      final currentStatus = _items[courseIndex].isFavorite;
      final newStatus = !currentStatus;

      _items[courseIndex].isFavorite = newStatus;

      if (newStatus) {
        _favoriteCourses.add(_items[courseIndex]);
      } else {
        _favoriteCourses.removeWhere((course) => course.course_id == id);
      }

      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('courses')
            .doc(id)
            .update({'isFavorite': newStatus});
      } catch (error) {
        _items[courseIndex].isFavorite = currentStatus;
        if (currentStatus) {
          _favoriteCourses.add(_items[courseIndex]);
        } else {
          _favoriteCourses.removeWhere((course) => course.course_id == id);
        }
        notifyListeners();
        print('Error updating favorite status: $error');
      }
    } else {
      print('course with id $id not found.');
    }
  }
}
