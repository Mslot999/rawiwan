import 'package:LevelUp/models/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetail extends StatefulWidget {
  final String courseId;
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final double courseRating;
  final String tutorName;
  final List<String> category;
  final bool isFavorite;
  final bool isPurchased;

  const CourseDetail({
    Key? key,
    required this.courseId,
    required this.courseName,
    required this.coursePrice,
    required this.courseImage,
    required this.courseRating,
    required this.tutorName,
    required this.category,
    required this.isFavorite,
    required this.isPurchased,
  }) : super(key: key);

  @override
  _CourseDetailState createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  late CourseItem course;

  @override
  void initState() {
    super.initState();
    Provider.of<CourseProvider>(context, listen: false).fetchCourses();
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, courseProvider, child) {
        if (courseProvider.items.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        course = courseProvider.items.firstWhere(
          (c) => c.course_id == widget.courseId,
          orElse: () => CourseItem(
            course_id: widget.courseId,
            name: widget.courseName,
            price: widget.coursePrice,
            image: widget.courseImage,
            rating: widget.courseRating,
            tutorName: widget.tutorName,
            category: widget.category,
            isFavorite: false,
            isPurchased: false,
          ),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(course.name),
            foregroundColor: Color(0xFF295F98),
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
                  if (Provider.of<CourseProvider>(context).cartItemCount > 0)
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
                          '${Provider.of<CourseProvider>(context).cartItemCount}',
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
                      course.image,
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
                        course.name,
                        style: TextStyle(fontSize: 28),
                      ),
                      IconButton(
                        icon: Icon(
                          course.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: course.isFavorite ? Colors.red : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () async {
                          await courseProvider.toggleFavorite(course.course_id);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'By ${course.tutorName}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Price: ฿${course.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/course-reviews',
                        arguments: widget.courseId,
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          'Rating: ${course.rating.toString()}',
                          style: TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        SizedBox(width: 8),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < course.rating.toInt()) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              );
                            } else if (index == course.rating.toInt() &&
                                course.rating % 1 >= 0.5) {
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
                        if (Provider.of<CourseProvider>(context, listen: false)
                            .isPurchased(course.course_id)) {
                          Navigator.pushNamed(context, '/review',
                              arguments: course.course_id);
                        } else {
                          if (!Provider.of<CourseProvider>(context,
                                  listen: false)
                              .isItemInCart(course.course_id)) {
                            Provider.of<CourseProvider>(context, listen: false)
                                .addItemToCart(course.course_id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('This item is already in the cart!'),
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
                        Provider.of<CourseProvider>(context, listen: false)
                                .isPurchased(course.course_id)
                            ? 'WRITE REVIEW'
                            : 'ADD TO CART',
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
                        if (!Provider.of<CourseProvider>(context, listen: false)
                            .isPurchased(course.course_id)) {
                          final directPurchaseItem = CourseItem(
                            course_id: course.course_id,
                            name: course.name,
                            price: course.price,
                            image: course.image,
                            rating: course.rating,
                            tutorName: course.tutorName,
                            category: course.category,
                            isFavorite: course.isFavorite,
                            isPurchased: course.isPurchased,
                          );
                          Provider.of<CourseProvider>(context, listen: false)
                              .addDirectPurchaseItem(
                                  directPurchaseItem.course_id);
                          Navigator.pushNamed(context, '/payment',
                              arguments: [directPurchaseItem]);
                        } else {
                          _launchURL(Uri.parse(
                              'https://www.youtube.com/@KongRuksiamTutorial'));
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
                        Provider.of<CourseProvider>(context, listen: false)
                                .isPurchased(course.course_id)
                            ? 'PLAY NOW'
                            : 'BUY NOW',
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
