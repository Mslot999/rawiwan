import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/company_provider.dart';
import 'package:LevelUp/pages/job/detail_page.dart';

class SentResume extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
    
        final applyCompanies = companyProvider.applyCompanies
            .where((company) => company.apply)
            .toList();

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text('Apply'),
            foregroundColor: Color(0xFF295F98),
          ),
          body: applyCompanies.isEmpty
              ? Center(
                  child: Text(
                    'No Apply companies yet.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: applyCompanies.length,
                  itemBuilder: (context, index) {
                    final company = applyCompanies[index];

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  company.companyImage,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.broken_image,
                                      size: 80,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      company.companyName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Salary: ${company.salary} Baht',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
