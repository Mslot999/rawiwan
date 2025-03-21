import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String courseName;
  final double coursePrice;
  final String courseImage;
  final double courseRating;

  const CourseCard({
    super.key,
    required this.courseName,
    required this.coursePrice,
    required this.courseImage,
    required this.courseRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 3,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(15.0)),
              child: Image.asset(
                courseImage,
                width: 95, 
                height: 95, 
                fit: BoxFit.cover, 
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
      
                  Text(
                    '\฿${coursePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
      
                  Row(
                    children: List.generate(5, (index) {
                      if (index < courseRating.toInt()) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else if (index == courseRating.toInt() && courseRating % 1 >= 0.5) {
                        return Icon(
                          Icons.star_half,
                          color: Colors.amber,
                          size: 16,
                        );
                      } else {
                        return Icon(
                          Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                       );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
