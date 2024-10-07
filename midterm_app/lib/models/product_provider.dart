import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CourseItem {
  final String id; 
  final String name;
  final double price;
  final String image;
  final double rating;
  final String tutorName;

  CourseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.rating,
    required this.tutorName,
  });
}

class CourseProvider with ChangeNotifier {
  List<CourseItem> _items = [];
  List<CourseItem> _cartItems = []; 
  List<CourseItem> _directPurchaseItems = []; 
  List<String> _favoriteCourses = []; 
  List<String> _purchasedCourses = []; 

  List<CourseItem> get items => _items;   
  List<CourseItem> get cartItems => _cartItems;
  List<CourseItem> get directPurchaseItems => _directPurchaseItems;
  List<String> get favoriteCourses => _favoriteCourses;
  List<String> get purchasedCourses => _purchasedCourses;

  void addItemToCart(CourseItem item) {
    if (!isItemInCart(item.id)) {
      _cartItems.add(item);
      notifyListeners(); 
    } else {
      print('This item is already in the cart.');
    }
  }

  void addDirectPurchaseItem(CourseItem item) {
    if (!_directPurchaseItems.any((existingItem) => existingItem.id == item.id)) {
      _directPurchaseItems.add(item);
      notifyListeners(); 
    } else {
      print('This item is already in the direct purchase list.');
    }
  }

  void confirmPurchase() {
    for (var item in _directPurchaseItems) {
      if (!isPurchased(item.id)) {
        _purchasedCourses.add(item.id); 
      }
    }
    _directPurchaseItems.clear(); 
    notifyListeners();
  }

  void removeItemFromCart(String id) {
    _cartItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  double get totalPrice => _cartItems.fold(0.0, (sum, item) => sum + item.price);

  int get cartItemCount => _cartItems.length;

  bool isItemInCart(String id) {
    return _cartItems.any((item) => item.id == id);
  }

  bool isPurchased(String id) {
    return _purchasedCourses.contains(id);
  }

  void purchaseItem(String id) {
    if (!isPurchased(id)) {
      _purchasedCourses.add(id);
      notifyListeners(); 
    }
  }

  String get formattedTotalPrice {
    final formatter = NumberFormat('#,##0.00');
    return formatter.format(totalPrice);
  }

  void toggleFavorite(String courseId) {
    if (_favoriteCourses.contains(courseId)) {
      _favoriteCourses.remove(courseId);
    } else {
      _favoriteCourses.add(courseId);
    }
    notifyListeners();
  }

  bool isFavorite(String courseId) {
    return _favoriteCourses.contains(courseId);
  }

}
