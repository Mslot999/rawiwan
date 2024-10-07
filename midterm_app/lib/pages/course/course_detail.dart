import 'package:midterm_app/models/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class CourseDetail extends StatelessWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final double courseRating;
  final String tutorName;

  const CourseDetail({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.coursePrice,
    required this.courseImage,
    required this.courseRating,
    required this.tutorName,
  }) : super(key: key);

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }}

  @override
  Widget build(BuildContext context) {
 

    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(courseName),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Color(0xFF295F98)),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cart');
                    },
                  ),
                  if (courseProvider.cartItemCount > 0)
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(2),
                        constraints: BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${courseProvider.cartItemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      courseImage,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        courseName,
                        style: TextStyle(fontSize: 28),
                      ),
                      IconButton(
                        icon: Icon(
                          courseProvider.isFavorite(courseId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: courseProvider.isFavorite(courseId)
                              ? Colors.red
                              : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () {
                          courseProvider.toggleFavorite(courseId);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'By $tutorName',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Price: ฿${coursePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Rating: ${courseRating.toString()}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      // Star Rating
                      Row(
                        children: List.generate(5, (index) {
                          if (index < courseRating.toInt()) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            );
                          } else if (index == courseRating.toInt() &&
                              courseRating % 1 >= 0.5) {
                            return Icon(
                              Icons.star_half,
                              color: Colors.amber,
                              size: 18,
                            );
                          } else {
                            return Icon(
                              Icons.star_border,
                              color: Colors.amber,
                              size: 18,
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Course Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            height: 60,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 80,
                    color: Colors.transparent,
                    child: ElevatedButton(
                      onPressed: () {
                        if (courseProvider.isPurchased(courseId)) {
                          Navigator.pushNamed(context, '/play', arguments: courseId);
                        } else {
                          if (!courseProvider.isItemInCart(courseId)) {
                            courseProvider.addItemToCart(CourseItem(
                              id: courseId,
                              name: courseName,
                              price: coursePrice,
                              image: courseImage,
                              rating: courseRating,
                              tutorName: tutorName,
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('This item is already in the cart!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 230, 230),
                        foregroundColor: Color(0xFF295F98),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        courseProvider.isPurchased(courseId) ? 'WRITE REVIEW' : 'ADD TO CART',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!courseProvider.isPurchased(courseId)) {
                          final directPurchaseItems = CourseItem(
                            id: courseId,
                            name: courseName,
                            price: coursePrice,
                            image: courseImage,
                            rating: courseRating,
                            tutorName: tutorName,
                          );
                          courseProvider.addDirectPurchaseItem(directPurchaseItems);
                          Navigator.pushNamed(context, '/payment', arguments: [directPurchaseItems]);
                        } else {
                          _launchURL(Uri.parse('https://www.youtube.com/@KongRuksiamTutorial'));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF295F98),
                        foregroundColor: Color.fromARGB(255, 230, 230, 230),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: Text(
                        courseProvider.isPurchased(courseId) ? 'PLAY NOW' : 'BUY NOW',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
