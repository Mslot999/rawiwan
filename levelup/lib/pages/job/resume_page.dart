import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:LevelUp/models/company_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';

class ResumePage extends StatefulWidget {
  final String id;
  final String companyName;
  final String skillRequire;
  final String companyImage;
  final double companyRating;
  final int salary;
  final String description;

  const ResumePage({
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
  _ResumePageState createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  File? _resumeFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
    
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        _nameController.text = userDoc['username'] ?? 'Not available';
        _emailController.text = currentUser.email ?? 'Not available';
      }
    }
  }

  Future<void> _pickResumeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null) {
      setState(() {
        _resumeFile = File(result.files.single.path!);
      });
    }
  }

  void _submitApplication() {
    final companyProvider = Provider.of<CompanyProvider>(context, listen: false);
    companyProvider.ApplyCompany(widget.id);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Application submitted to ${widget.companyName}'),
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF295F98)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Apply for Job at ${widget.companyName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Your Name'),
                readOnly: true, 
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Your Email'),
                readOnly: true, 
              ),
              SizedBox(height: 20),
              Text(
                'Your Resume',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: _pickResumeFile,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.attach_file),
                    SizedBox(width: 8),
                    Text('Choose File'),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color.fromARGB(255, 218, 218, 218),
                  padding: EdgeInsets.symmetric(horizontal: 10.5, vertical: 10.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              if (_resumeFile != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Selected File: ${_resumeFile!.path.split('/').last}',
                    style: TextStyle(fontSize: 14, color: Colors.green),
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitApplication,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10.5, horizontal: 10.5),
                  textStyle: TextStyle(fontSize: 14),
                  backgroundColor: Color(0xFF295F98),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
