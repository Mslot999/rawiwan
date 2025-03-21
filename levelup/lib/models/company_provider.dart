import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CompanyItem {
  final String id;
  final String companyName;
  final String skillRequire;
  final String companyImage;
  final double companyRating;
  final int salary;
  final String description;
  bool favorite;
  bool apply;

  CompanyItem({
    required this.id,
    required this.companyName,
    required this.skillRequire,
    required this.companyImage,
    required this.companyRating,
    required this.salary,
    required this.description,
    this.favorite = false,
    this.apply = false,
  });

  CompanyItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        companyName = json['companyName'],
        skillRequire = json['skillRequire'],
        companyImage = json['companyImage'],
        companyRating = json['companyRating'].toDouble(),
        salary = json['salary'],
        description = json['description'],
        favorite = json['favorite'] ?? false,
        apply = json['apply'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'companyName': companyName,
      'skillRequire': skillRequire,
      'companyImage': companyImage,
      'companyRating': companyRating,
      'salary': salary,
      'description': description,
      'favorite': favorite,
      'apply': apply,
    };
  }
}

class CompanyProvider with ChangeNotifier {
  List<CompanyItem> _companies = [];
  List<CompanyItem> _favoriteCompanies = [];
  List<CompanyItem> _applyCompanies = [];

  List<CompanyItem> get companies => _companies;
  List<CompanyItem> get favoriteCompanies => _favoriteCompanies;
  List<CompanyItem> get applyCompanies => _applyCompanies;

  Future<void> fetchCompaniesFromDb() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('companies').get();

      if (snapshot.docs.isNotEmpty) {
        _companies = snapshot.docs.map((doc) {
          final data = doc.data();
          return CompanyItem(
            id: doc.id,
            companyName: data['companyName'] ?? '',
            skillRequire: data['skillRequire'] ?? '',
            companyImage: data['companyImage'] ?? '',
            companyRating: (data['companyRating'] ?? 0).toDouble(),
            salary: data['salary'] ?? 0,
            description: data['description'] ?? '',
            favorite: data['favorite'] ?? false,
            apply: data['apply'] ?? false,
          );
        }).toList();

        print(_companies);
        notifyListeners();
      } else {
        throw Exception('No companies found in Firestore.');
      }
    } catch (error) {
      print('Error fetching data from Firebase: $error');
    }
  }

  Future<void> toggleFavorite(String id) async {
    final companyIndex = _companies.indexWhere((company) => company.id == id);

    if (companyIndex != -1) {
      final currentStatus = _companies[companyIndex].favorite;
      final newStatus = !currentStatus;

      _companies[companyIndex].favorite = newStatus;

      if (newStatus) {
        _favoriteCompanies.add(_companies[companyIndex]);
      } else {
        _favoriteCompanies.removeWhere((company) => company.id == id);
      }

      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(id)
            .update({'favorite': newStatus});
      } catch (error) {
        _companies[companyIndex].favorite = currentStatus;
        if (currentStatus) {
          _favoriteCompanies.add(_companies[companyIndex]);
        } else {
          _favoriteCompanies.removeWhere((company) => company.id == id);
        }
        notifyListeners();
        print('Error updating favorite status: $error');
      }
    } else {
      print('Company with id $id not found.');
    }
  }

  Future<void> ApplyCompany(String id) async {
    final companyIndex = _companies.indexWhere((company) => company.id == id);

    if (companyIndex != -1) {
      final currentStatus = _companies[companyIndex].apply;
      final newStatus = !currentStatus;

      _companies[companyIndex].apply = newStatus;

      if (newStatus) {
        _applyCompanies.add(_companies[companyIndex]);
      } else {
        _applyCompanies.removeWhere((company) => company.id == id);
      }

      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('companies')
            .doc(id)
            .update({'apply': newStatus});
      } catch (error) {
        _companies[companyIndex].apply = currentStatus;
        if (currentStatus) {
          _applyCompanies.add(_companies[companyIndex]);
        } else {
          _applyCompanies.removeWhere((company) => company.id == id);
        }
        notifyListeners();
        print('Error updating apply status: $error');
      }
    } else {
      print('Company with id $id not found.');
    }
  }
}
