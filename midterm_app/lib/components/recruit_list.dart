import 'package:flutter/material.dart';

class RecruitList extends StatelessWidget {
  final String companyname;
  final String skillrequire;
  final String companyImage;
  final double companyRating;
  final String salary;
  
  const RecruitList({
    super.key,
    required this.companyname,
    required this.skillrequire,
    required this.companyImage,
    required this.companyRating,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
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
                companyImage,
                width: 110, 
                height: 110, 
                fit: BoxFit.cover, 
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company Name: $companyname',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Skill Required: $skillrequire',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Salary: $salary',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        if (index < companyRating.toInt()) {
                          return Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          );
                        } else if (index == companyRating.toInt() && companyRating % 1 >= 0.5) {
                          return Icon(
                            Icons.star_half,
                            color: Colors.amber,
                            size: 14,
                          );
                        } else {
                          return Icon(
                            Icons.star_border,
                            color: Colors.amber,
                            size: 14,
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}