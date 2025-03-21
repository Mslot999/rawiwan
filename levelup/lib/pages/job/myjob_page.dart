import 'package:LevelUp/pages/job/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/company_provider.dart';
import 'package:LevelUp/pages/job/favorite_page.dart';
import 'package:LevelUp/pages/job/sent_resume.dart';

class MyJobPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
        return Scaffold(
          backgroundColor: Color(0xFFF4F4F4),
          appBar: AppBar(
            title: Text('My Job', style: TextStyle(color: Color(0xFF295F98))),
            backgroundColor: Color(0xFFF4F4F4),
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              _buildCompanySection(
                context,
                title: 'Favorite Company',
                companies: companyProvider.favoriteCompanies,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onEmptyMessage: 'No favorite companies',
                onMorePressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteCompaniesPage()),
                  );
                },
              ),
              _buildCompanySection(
                context,
                title: 'Applyed',
                companies: companyProvider.applyCompanies,
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onEmptyMessage: 'No companies sent resume',
                onMorePressed: () {
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SentResume()),
                  );
                },
              ),
              _buildCompanySection(
                context,
                title: 'Approved',
                companies: [], 
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onEmptyMessage:
                    'No companies approved yet', 
                onMorePressed: () {},
              ),
              _buildCompanySection(
                context,
                title: 'Rejected',
                companies: [], 
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                onEmptyMessage:
                    'No companies rejected yet', 
                onMorePressed: () {},
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildCompanySection(
    BuildContext context, {
    required String title,
    required List<CompanyItem> companies,
    required double screenHeight,
    required double screenWidth,
    required String onEmptyMessage,
    required VoidCallback onMorePressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF295F98)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF295F98),
                  foregroundColor: Colors.white,
                ),
                onPressed: onMorePressed,
                child: Text(
                  'More',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

         
          companies.isEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    onEmptyMessage,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : Container(
                  height: screenHeight *
                      0.3, 
                  child: SingleChildScrollView(
                    child: GridView.builder(
                      shrinkWrap:
                          true, 
                      physics:
                          NeverScrollableScrollPhysics(), 
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, 
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: (screenWidth * 0.45) /
                            (screenHeight * 0.25),
                      ),
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];

                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompanyDetail(
                                    id: company.id,
                                    companyName: company.companyName,
                                    description: company.description,
                                    companyRating: company.companyRating,
                                    companyImage: company.companyImage,
                                    salary: company.salary,
                                    skillRequire: company.skillRequire,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      company.companyImage,
                                      height:
                                          120, 
                                      width: double.infinity,
                                      fit: BoxFit
                                          .cover, 
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    company.companyName,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
