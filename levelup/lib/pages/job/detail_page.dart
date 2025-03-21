import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/company_provider.dart';
import 'package:LevelUp/pages/job/resume_page.dart';

class CompanyDetail extends StatefulWidget {
  final String id;
  final String companyName;
  final String skillRequire;
  final String companyImage;
  final double companyRating;
  final int salary;
  final String description;

  const CompanyDetail({
    Key? key,
    required this.id,
    required this.companyName,
    required this.skillRequire,
    required this.companyImage,
    required this.companyRating,
    required this.salary,
    required this.description,
  }) : super(key: key);

  @override
  _CompanyDetailState createState() => _CompanyDetailState();
}

class _CompanyDetailState extends State<CompanyDetail> {
  late CompanyItem company;

  @override
  void initState() {
    super.initState();
   
    Provider.of<CompanyProvider>(context, listen: false).fetchCompaniesFromDb();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CompanyProvider>(
      builder: (context, companyProvider, child) {
      
        if (companyProvider.companies.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

       
        company = companyProvider.companies.firstWhere(
          (comp) => comp.id == widget.id,
          orElse: () => CompanyItem(
            id: widget.id,
            companyName: widget.companyName,
            skillRequire: widget.skillRequire,
            companyImage: widget.companyImage,
            companyRating: widget.companyRating,
            salary: widget.salary,
            description: widget.description,
            favorite: false,
            apply: false,
          ),
        );

        bool isFavorite = company.favorite;
        bool isApplied = company.apply;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(widget.companyName),
            foregroundColor: Color(0xFF295F98),
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
                      widget.companyImage,
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.companyName,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Skills Required: ${widget.skillRequire}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.description,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Salary: ${widget.salary} Baht',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${widget.companyRating}/5',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: isApplied
                                    ? null
                                    : () {
                                       Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ResumePage(
                                              id: company.id,
                                              companyName: company.companyName,
                                              skillRequire: company.skillRequire,
                                              companyImage: company.companyImage,
                                              companyRating: company.companyRating,
                                              salary: company.salary,
                                              description: company.description,
                                            ),
                                          ),
                                        );
                                      },
                                child: Text(isApplied
                                    ? 'Already Sent Resume'
                                    : 'Apply for Job'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 10.5, horizontal: 10.5),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF295F98),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : Colors.grey,
                                ),
                                onPressed: () {
                                  
                                  companyProvider.toggleFavorite(widget.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
